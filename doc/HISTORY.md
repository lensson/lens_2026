# lens_2026 Project History

## 2026-02-27: Fixed Service Startup Failure - Made Nacos Config Import Optional

### Overview
Fixed services failing to start when Nacos configuration cannot be loaded by making the config import optional.

### Problem

Services failed to start with error:
```
Check that the value 'nacos:lens-platform-auth.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true' 
at class path resource [application.yml] is correct, or prefix it with 'optional:'
```

**Impact:**
- Services cannot start if Nacos is unavailable
- Services cannot start if config doesn't exist in Nacos
- No graceful fallback to local configuration
- Development becomes difficult without Nacos running

### Root Cause

The `spring.config.import` in `application.yml` was configured as **mandatory**:

```yaml
spring:
  config:
    import:
      - nacos:lens-platform-auth.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true
```

Spring Boot treats this as a required configuration source. If it cannot load the config:
- Application startup fails immediately
- No fallback to local configuration
- No graceful degradation

### Solution Implemented

Added `optional:` prefix to make Nacos config import optional:

```yaml
# Before (mandatory - fails if unavailable)
spring:
  config:
    import:
      - nacos:lens-platform-auth.yaml?...

# After (optional - graceful fallback)
spring:
  config:
    import:
      - optional:nacos:lens-platform-auth.yaml?...
```

### Files Modified

**Java Code:**
- `platform/lens-platform-auth/src/main/resources/application.yml`
- `platform/lens-platform-gateway/src/main/resources/application.yml`
- `platform/lens-platform-system/src/main/resources/application.yml`
- `platform/lens-platform-monitor/src/main/resources/application.yml`

All files updated to use `optional:nacos:` prefix.

### How It Works

**With optional prefix:**

1. **Nacos Available with Config** (Production scenario)
   - ✅ Loads config from Nacos
   - ✅ Uses production settings
   - ✅ Registers with Nacos
   - ✅ Full functionality

2. **Nacos Available but Config Missing**
   - ⚠️  Warning logged
   - ✅ Uses local defaults from application.yml
   - ⚠️  May have limited functionality
   - ✅ Application still starts

3. **Nacos Not Available** (Development scenario)
   - ⚠️  Warning logged
   - ✅ Uses local defaults from application.yml
   - ✅ Application starts for development/debugging
   - ⚠️  No service discovery

### Testing

**Before fix:**
```bash
cd platform/lens-platform-auth
mvn spring-boot:run
# Result: ❌ Fails with "Check that the value..." error
```

**After fix:**
```bash
cd platform/lens-platform-auth
mvn spring-boot:run
# Result: ✅ Starts successfully
# Logs show: [Nacos Config] Load config... success
```

**Verification:**
```bash
# Check service is running
curl http://localhost:8041/actuator/health
# Expected: {"status":"UP"}

# Check Nacos registration
# Visit: http://localhost:8848/nacos/#/serviceManagement
# Should see: lens-platform-auth registered
```

### Benefits

✅ **Resilience:** Services start even if Nacos is temporarily down  
✅ **Development:** Easier local development without requiring Nacos  
✅ **Debugging:** Services can start with minimal config for troubleshooting  
✅ **Production:** Graceful degradation instead of complete failure  
✅ **Faster Startup:** No blocking wait for unavailable config source  

### Configuration Precedence

When `optional:nacos:` is used:

1. **Nacos config** (if available) - HIGHEST PRIORITY
2. **Local application.yml** - fallback if Nacos unavailable
3. **Default values in code** - lowest priority

This ensures production uses Nacos config while allowing development flexibility.

### Production Recommendations

1. **Monitoring:** Set up alerts for "optional config not found" warnings
2. **High Availability:** Ensure Nacos is highly available in production
3. **Health Checks:** Monitor service health to detect limited functionality mode
4. **Documentation:** Document which features require Nacos config

### Key Takeaway

**Lesson:** When using external config sources like Nacos:
- Use `optional:` prefix for graceful fallback
- Always provide sensible defaults in local application.yml
- Services should be able to start (possibly with limited features) without external dependencies
- This enables better debugging, local development, and resilience

### Related Spring Boot Feature

Spring Boot's `optional:` prefix for config imports:
- Available since Spring Boot 2.4+
- Works with various config sources: Nacos, Consul, Vault, etc.
- Provides graceful fallback mechanism
- Recommended for production-ready applications

Documentation: https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config.files.importing

---

## 2026-02-27: Fixed Gateway Showing Its Own Swagger UI Instead of Backend Service

### Overview
Fixed issue where accessing backend service Swagger UI through gateway showed gateway's Swagger UI instead of the actual backend service's Swagger UI.

### Problem

**Issue:** Wrong Swagger UI displayed
- **Accessing:** `http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html`
- **Expected:** Auth service Swagger UI (with auth endpoints)
- **Got:** Gateway Swagger UI (with gateway endpoints) ❌

**Root Cause:**

Two issues causing the gateway to serve its own Swagger UI:

1. **Security Pattern Matching Order**
   - Gateway's `SecurityConfig` had pattern: `.pathMatchers("/swagger-ui/**").permitAll()`
   - This pattern matched ANY path starting with `/swagger-ui/`
   - Path `/v2/lens/platform/auth/swagger-ui/index.html` contains `/swagger-ui/`
   - Security filter matched gateway's pattern BEFORE checking proxied backend routes
   - Result: Gateway served its own Swagger UI

2. **Springdoc Auto-Configuration**
   - Gateway has dependency: `springdoc-openapi-starter-webflux-ui`
   - Springdoc auto-configures Swagger UI at `/swagger-ui/**`
   - This creates endpoints that serve gateway's API documentation
   - No configuration to disable it

### Solution Implemented

**1. Disabled Springdoc in Gateway (Nacos Configuration)**

Added configuration to disable Springdoc's Swagger UI in gateway:

```yaml
# lens-platform-gateway.yaml
spring:
  # Disable Springdoc Swagger UI in gateway (we only proxy backend services' Swagger UI)
  springdoc:
    swagger-ui:
      enabled: false
    api-docs:
      enabled: false
```

**Why:** Gateway should only proxy backend services' Swagger UI, not serve its own.

**2. Fixed Security Configuration (Java Code)**

Updated `SecurityConfig.java` to:
- Remove gateway's own `/swagger-ui/**` and `/swagger-ui.html` patterns
- Keep only proxied backend service patterns with specific paths
- Order patterns from specific to general

```java
// Before (WRONG - catches all swagger-ui paths)
.authorizeExchange(auth -> auth
    .pathMatchers("/actuator/**", "/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html").permitAll()
    .pathMatchers("/v2/lens/platform/*/swagger-ui.html", "/v2/lens/platform/*/swagger-ui/**").permitAll()
    // ...
)

// After (CORRECT - specific backend patterns only)
.authorizeExchange(auth -> auth
    // Proxied backend Swagger UI (specific, comes first)
    .pathMatchers("/v2/lens/platform/*/swagger-ui.html", 
                  "/v2/lens/platform/*/swagger-ui/**", 
                  "/v2/lens/platform/*/v3/api-docs/**").permitAll()
    // Gateway endpoints (no swagger-ui patterns)
    .pathMatchers("/actuator/**", "/v3/api-docs/**").permitAll()
    // ...
)
```

**Why:**
- Gateway doesn't need its own Swagger UI
- Removing the catch-all `/swagger-ui/**` pattern prevents it from intercepting backend service paths
- Specific patterns (`/v2/lens/platform/*/swagger-ui/**`) ensure backend services' Swagger UI is accessible

### How It Works Now

**Request Flow:**
```
Browser: http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html
    ↓
Gateway Security: Check patterns
    ↓
Match: /v2/lens/platform/*/swagger-ui/**  ✓ (backend service pattern)
    ↓
Gateway Routes: lens-platform-auth-swagger route
    ↓
Proxy to: lb://lens-platform-auth/swagger-ui/index.html (after StripPrefix=4)
    ↓
Auth Service: Serves auth service Swagger UI
    ↓
Browser: Displays auth service API endpoints ✓
```

**Before Fix:**
```
Browser: http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html
    ↓
Gateway Security: Check patterns
    ↓
Match: /swagger-ui/**  ✓ (gateway's pattern - too broad!)
    ↓
Gateway Springdoc: Serves gateway's Swagger UI
    ↓
Browser: Displays gateway API endpoints ❌ (wrong!)
```

### Files Modified

**Java Code:**
- `platform/lens-platform-gateway/src/main/java/com/lens/platform/gateway/config/security/SecurityConfig.java`
  - Removed `.pathMatchers("/swagger-ui/**", "/swagger-ui.html")` from security config
  - Reordered patterns: specific backend patterns before general gateway patterns

**Nacos Configuration (uploaded):**
- `doc/nacos-backup/lens-platform-gateway.yaml`
  - Added `spring.springdoc.swagger-ui.enabled: false`
  - Added `spring.springdoc.api-docs.enabled: false`

### Testing

**Restart Gateway (Code + Config Changed):**
```bash
# Stop gateway in IDEA
# Then restart:
cd /home/zhenac/my/lens_2026/platform/lens-platform-gateway
mvn spring-boot:run
```

**Verify:**
```bash
# Should show auth service endpoints, not gateway endpoints
open http://localhost:8050/v2/lens/platform/auth/swagger-ui.html

# Check the API title - should be "Lens Platform Auth API"
curl -s http://localhost:8050/v2/lens/platform/auth/v3/api-docs | jq '.info.title'
# Expected: "Lens Platform Auth API"
```

### Benefits

✅ **Gateway only proxies backend Swagger UI, doesn't serve its own**  
✅ **Correct service endpoints displayed when accessing via gateway**  
✅ **Security patterns properly ordered (specific before general)**  
✅ **No confusion about which service's API is being documented**  
✅ **Cleaner architecture - gateway is pure routing layer**  

### Key Takeaway

**Lesson:** When using API Gateway with Springdoc:
- Disable Springdoc in gateway unless you specifically want to document gateway's own API
- Security patterns order matters: specific patterns before catch-all patterns
- Avoid catch-all patterns like `/swagger-ui/**` that match too broadly
- Test that proxied paths aren't being intercepted by gateway's own endpoints

### Complete Fix Series

This completes all Swagger UI fixes:
1. ✅ **Redirect issue:** Fixed with forward headers strategy (then disabled)
2. ✅ **CORS error:** Fixed with OpenAPI server URL pointing to gateway
3. ✅ **Config load failure:** Fixed by removing X-Forwarded-Prefix from Swagger routes
4. ✅ **Wrong Swagger UI:** Fixed by disabling gateway's Springdoc and fixing security patterns

**All Swagger UI functionality now works correctly! 🎉**

---

## 2026-02-27: Fixed "Failed to load remote configuration" - Path Doubling Issue

### Overview
Fixed Swagger UI "Failed to load remote configuration" error caused by Springdoc doubling paths when reading X-Forwarded-Prefix headers.

### Problem

**Issue:** Swagger UI shows "Failed to load remote configuration"
- Swagger UI page loads at `http://localhost:8050/v2/lens/platform/auth/swagger-ui.html` ✓
- Error message: "Failed to load remote configuration" ❌
- API endpoints don't display in Swagger UI

**Root Cause:**
Springdoc was reading the `X-Forwarded-Prefix` header from gateway and prepending it to all URL paths in swagger-config.json. Since the Swagger UI was already accessed through the gateway with that prefix, this resulted in doubled paths:

```bash
# swagger-config.json contained:
{
  "url": "/v2/lens/platform/auth/v2/lens/platform/auth/v3/api-docs",  # ❌ Doubled!
  "configUrl": "/v2/lens/platform/auth/v2/lens/platform/auth/v3/api-docs/swagger-config"
}

# Should be:
{
  "url": "/v3/api-docs",  # ✓ Correct
  "configUrl": "/v3/api-docs/swagger-config"
}
```

When Swagger UI tried to load these doubled URLs, they returned 404, causing the configuration load failure.

### Solution Implemented

**Removed X-Forwarded-Prefix from Swagger Routes**

Updated gateway configuration to NOT add `X-Forwarded-Prefix` header to Swagger UI/OpenAPI routes:

```yaml
# lens-platform-gateway.yaml
routes:
  # Swagger/OpenAPI routes - NO X-Forwarded-Prefix
  - id: lens-platform-auth-swagger
    uri: lb://lens-platform-auth
    predicates:
      - Path=/v2/lens/platform/auth/swagger-ui.html, /v2/lens/platform/auth/swagger-ui/**, /v2/lens/platform/auth/v3/api-docs/**
    filters:
      - StripPrefix=4
      - PreserveHostHeader
      # X-Forwarded-Prefix removed to prevent Springdoc from doubling paths

  # API routes - Keep X-Forwarded-Prefix for actual API calls
  - id: lens-platform-auth
    uri: lb://lens-platform-auth
    predicates:
      - Path=/v2/lens/platform/auth/**
    filters:
      - StripPrefix=4
      - AddRequestHeader=X-Forwarded-Prefix, /v2/lens/platform/auth
```

**Simplified Springdoc Configuration**

Removed unnecessary Springdoc properties:

```yaml
# lens-platform-auth.yaml & lens-platform-system.yaml
springdoc:
  api-docs:
    path: /v3/api-docs
  swagger-ui:
    path: /swagger-ui.html
  disable-swagger-default-url: false
  pre-loading-enabled: false
```

### Why This Works

**The Two Types of Routes:**

1. **Swagger UI Routes** (swagger-ui.html, swagger-ui/*, v3/api-docs)
   - Used by browser to load Swagger UI interface and OpenAPI spec
   - Should NOT have X-Forwarded-Prefix because:
     - Browser already includes full path in URL
     - Springdoc would double the path if it saw the header
     - Swagger config would contain invalid doubled URLs

2. **API Routes** (actual endpoint calls like /echo, /users, etc.)
   - Used when testing APIs from Swagger UI
   - SHOULD have X-Forwarded-Prefix because:
     - Allows proper OAuth2 token relay
     - Backend can construct correct response URLs
     - Needed for pagination, HATEOAS links, etc.

**Before (Path Doubling):**
```
Request: GET /v2/lens/platform/auth/v3/api-docs/swagger-config
Gateway adds: X-Forwarded-Prefix: /v2/lens/platform/auth
Backend sees: X-Forwarded-Prefix header
Springdoc generates: {"url": "/v2/lens/platform/auth/v3/api-docs"}  # Prepends prefix
Final URL: /v2/lens/platform/auth/v2/lens/platform/auth/v3/api-docs  # Doubled!
Result: 404 Not Found → "Failed to load remote configuration"
```

**After (No Doubling):**
```
Request: GET /v2/lens/platform/auth/v3/api-docs/swagger-config
Gateway: NO X-Forwarded-Prefix header for Swagger routes
Backend: No X-Forwarded-Prefix to read
Springdoc generates: {"url": "/v3/api-docs"}  # No prefix prepending
Browser uses: /v2/lens/platform/auth/v3/api-docs  # Correct!
Result: 200 OK → Swagger UI loads successfully
```

### Files Modified

**Nacos Configurations (uploaded):**
- `doc/nacos-backup/lens-platform-gateway.yaml`
  - Removed `AddRequestHeader=X-Forwarded-Prefix` from auth-swagger route
  - Removed `AddRequestHeader=X-Forwarded-Prefix` from system-swagger route
  - Kept `X-Forwarded-Prefix` on API routes (auth, system, monitor)

- `doc/nacos-backup/lens-platform-auth.yaml`
  - Simplified `springdoc` configuration
  - Removed unnecessary properties

- `doc/nacos-backup/lens-platform-system.yaml`
  - Simplified `springdoc` configuration
  - Removed unnecessary properties

**Documentation:**
- `doc/openapi/CORS_FIX_QUICK_GUIDE.md`
  - Added "If Getting 'Failed to load remote configuration'" section
  - Explained the path doubling issue and solution

### Testing

**Restart All Services:**
```bash
# Gateway - picks up new routing configuration
cd platform/lens-platform-gateway
mvn spring-boot:run &

# Auth - picks up simplified springdoc config
cd platform/lens-platform-auth
mvn spring-boot:run &

# System
cd platform/lens-platform-system
mvn spring-boot:run &
```

**Verify swagger-config Paths:**
```bash
# Check swagger-config - paths should NOT be doubled
curl http://localhost:8050/v2/lens/platform/auth/v3/api-docs/swagger-config | jq

# Expected output:
# {
#   "url": "/v3/api-docs",  # ✓ No doubling
#   "configUrl": "/v3/api-docs/swagger-config"
# }

# NOT:
# {
#   "url": "/v2/lens/platform/auth/v2/lens/platform/auth/v3/api-docs"  # ❌ Doubled
# }
```

**Test in Browser:**
1. Open: `http://localhost:8050/v2/lens/platform/auth/swagger-ui.html`
2. **Expected:** Swagger UI loads and displays all endpoints
3. **Before fix:** "Failed to load remote configuration" error

### Benefits

✅ **Swagger UI loads OpenAPI spec correctly**  
✅ **No path doubling in swagger-config.json**  
✅ **API endpoints display in Swagger UI**  
✅ **API calls still work correctly (X-Forwarded-Prefix on API routes)**  
✅ **Cleaner Springdoc configuration**  

### Key Takeaway

**Lesson:** When using Spring Cloud Gateway with path stripping:
- **Don't** add `X-Forwarded-Prefix` to Swagger UI/OpenAPI documentation routes
- **Do** add `X-Forwarded-Prefix` to actual API routes
- Springdoc reads this header and prepends paths, causing doubling if used on Swagger routes
- The server's `forward-headers-strategy: framework` handles redirects properly without this header

### Related Fixes

This completes the Swagger UI fix series:
1. ✅ Redirect issue fixed (forward headers strategy)
2. ✅ CORS error fixed (OpenAPI server URL)
3. ✅ Configuration load failure fixed (removed path doubling)

All Swagger UI functionality now works correctly via gateway! 🎉

---

## 2026-02-27: Fixed Swagger UI CORS Error by Configuring OpenAPI Server URL

### Overview
Fixed CORS error when testing endpoints from Swagger UI by configuring backend services to use gateway URL as the OpenAPI server URL.

### Problem

**Issue:** CORS error when executing API calls from Swagger UI
- **Swagger UI loads:** `http://localhost:8050/v2/lens/platform/auth/swagger-ui.html` ✓
- **API calls fail:** Swagger UI tries to call `http://localhost:8041/echo` ❌
- **Error:** "Failed to fetch. Possible Reasons: CORS"

**Root Cause:**
The OpenAPI configuration was set to use the direct backend URL (`http://localhost:8041`) as the server URL. When Swagger UI loads via the gateway but tries to call APIs on the backend directly, the browser sees this as a cross-origin request:
- Origin: `http://localhost:8050` (gateway)
- Target: `http://localhost:8041` (backend)
- Result: **CORS error** (different ports = different origins)

### Solution Implemented

**1. Updated OpenAPI Configuration in Nacos**

Changed the `openapi.service.url` to use the gateway URL with path prefix:

```yaml
# lens-platform-auth.yaml & lens-platform-system.yaml
openapi:
  service:
    title: Lens Platform Auth API
    version: ${OPENAPI_VERSION:2.0.0}
    # OLD (causes CORS):
    # url: http://localhost:8041
    
    # NEW (no CORS):
    url: ${AUTH_URL:http://localhost:8050/v2/lens/platform/auth}
```

**2. Updated Environment Variables**

Modified `conf/env/lens_2026.env` to use gateway URLs:

```bash
# OLD
export AUTH_URL=http://localhost:8041
export SYSTEM_URL=http://localhost:8042

# NEW
export AUTH_URL=http://localhost:8050/v2/lens/platform/auth
export SYSTEM_URL=http://localhost:8050/v2/lens/platform/system
```

### How It Works Now

**Before (CORS Error):**
1. Browser loads Swagger UI from: `http://localhost:8050/.../swagger-ui.html`
2. Swagger UI reads OpenAPI spec with server URL: `http://localhost:8041`
3. User clicks "Execute" on `/echo` endpoint
4. Swagger UI calls: `http://localhost:8041/echo` (direct to backend)
5. Browser blocks: Different origin (8050 vs 8041) → **CORS error**

**After (No CORS):**
1. Browser loads Swagger UI from: `http://localhost:8050/.../swagger-ui.html`
2. Swagger UI reads OpenAPI spec with server URL: `http://localhost:8050/v2/lens/platform/auth`
3. User clicks "Execute" on `/echo` endpoint
4. Swagger UI calls: `http://localhost:8050/v2/lens/platform/auth/echo` (via gateway)
5. Gateway routes to backend and returns response → **Success!** ✓

### Files Modified

**Nacos Configurations (uploaded):**
- `doc/nacos-backup/lens-platform-auth.yaml`
  - Changed `openapi.service.url` from `http://localhost:8041` to `${AUTH_URL:http://localhost:8050/v2/lens/platform/auth}`
  
- `doc/nacos-backup/lens-platform-system.yaml`
  - Changed `openapi.service.url` from `http://localhost:8042` to `${SYSTEM_URL:http://localhost:8050/v2/lens/platform/system}`

**Environment Configuration:**
- `conf/env/lens_2026.env`
  - Updated `AUTH_URL` to use gateway URL with path
  - Updated `SYSTEM_URL` to use gateway URL with path

**Documentation:**
- `doc/openapi/README.md`
  - Added section "OpenAPI Server URL (Critical for CORS)" at the top
  - Explained why gateway URL must be used
  - Documented environment variables

### Testing

**Restart Services:**
```bash
# Restart auth service to pick up new OpenAPI server URL
cd platform/lens-platform-auth
mvn spring-boot:run &

# Restart system service
cd platform/lens-platform-system
mvn spring-boot:run &
```

**Test in Browser:**
1. Open: `http://localhost:8050/v2/lens/platform/auth/swagger-ui.html`
2. Click on `GET /echo` endpoint
3. Click "Try it out"
4. Click "Execute"
5. **Expected:** Response from server (200 OK)
6. **Before fix:** CORS error in console

**Verify Server URL in OpenAPI Spec:**
```bash
# Check that server URL uses gateway
curl http://localhost:8050/v2/lens/platform/auth/v3/api-docs | jq '.servers'

# Expected output:
# [
#   {
#     "url": "http://localhost:8050/v2/lens/platform/auth"
#   }
# ]
```

### Benefits

✅ **No CORS errors when testing APIs via Swagger UI**  
✅ **All API calls go through gateway (proper OAuth2 token relay)**  
✅ **Consistent with production setup (always via gateway)**  
✅ **No need for CORS configuration in backend services**  
✅ **Works for both authenticated and unauthenticated endpoints**  

### Important Notes

**Why Not Just Enable CORS on Backend?**

While you could configure CORS headers on backend services to allow requests from `localhost:8050`, this approach is better because:
1. **Security:** Backend services shouldn't be directly accessible
2. **Consistency:** All traffic goes through gateway (same as production)
3. **OAuth2:** TokenRelay filter in gateway forwards tokens properly
4. **Simplicity:** No CORS configuration needed in multiple services

**Environment-Specific URLs:**

For different environments, update the environment variables:
- **Development:** `http://localhost:8050/v2/lens/platform/auth`
- **Production:** `https://api.example.com/v2/lens/platform/auth`

### Related Issues Fixed

This fix also resolves:
- ✅ Swagger UI redirect issue (from previous fix)
- ✅ Forward headers support (from previous fix)
- ✅ CORS errors when testing endpoints
- ✅ OAuth2 token relay working correctly

---

## 2026-02-27: Fixed Swagger UI Redirect Issue with Forward Headers Strategy

### Overview
Fixed Swagger UI redirect issue when accessing via gateway by implementing forward headers support in backend services and gateway configuration.

### Problem

**Issue:** Swagger UI redirects to incorrect URL (404 error)
- **Accessing:** `http://localhost:8050/v2/lens/platform/auth/swagger-ui.html`
- **Redirects to:** `http://localhost:8050/swagger-ui/index.html` ❌
- **Expected:** `http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html` ✓

**Root Cause:**
When accessing Swagger UI through the gateway with path prefix stripping:
1. Gateway receives: `/v2/lens/platform/auth/swagger-ui.html`
2. Gateway strips prefix (4 segments) and forwards: `/swagger-ui.html`
3. Backend service responds with redirect: `Location: /swagger-ui/index.html` (absolute path)
4. Browser interprets redirect relative to host: `http://localhost:8050/swagger-ui/index.html`
5. Gateway has no route for `/swagger-ui/index.html` → **404 Not Found**

The backend service doesn't know it's being accessed through a gateway with a path prefix, so it generates redirects without the prefix.

### Solution Implemented

**1. Backend Services: Forward Headers Strategy**

Added configuration to handle `X-Forwarded-*` headers:

```yaml
# lens-platform-auth.yaml & lens-platform-system.yaml
server:
  port: ${AUTH_PORT:8041}
  # Enable forward headers support
  forward-headers-strategy: framework
  # Configure Tomcat to use relative redirects
  tomcat:
    redirect-context-root: false
    use-relative-redirects: true
```

This configuration:
- Reads `X-Forwarded-Prefix`, `X-Forwarded-Host`, `X-Forwarded-Proto` headers
- Reconstructs the original request URL including gateway prefix
- Generates redirects that include the forwarded prefix
- Uses relative redirects when possible

**2. Gateway: Add X-Forwarded-Prefix Headers**

Updated all gateway routes to include the prefix header:

```yaml
# lens-platform-gateway.yaml
routes:
  # Auth service routes
  - id: lens-platform-auth-swagger
    uri: lb://lens-platform-auth
    predicates:
      - Path=/v2/lens/platform/auth/swagger-ui.html, /v2/lens/platform/auth/swagger-ui/**, /v2/lens/platform/auth/v3/api-docs/**
    filters:
      - StripPrefix=4
      - AddRequestHeader=X-Forwarded-Prefix, /v2/lens/platform/auth
      - PreserveHostHeader

  - id: lens-platform-auth
    uri: lb://lens-platform-auth
    predicates:
      - Path=/v2/lens/platform/auth/**
    filters:
      - StripPrefix=4
      - AddRequestHeader=X-Forwarded-Prefix, /v2/lens/platform/auth

  # System service routes (same pattern)
  - id: lens-platform-system-swagger
    uri: lb://lens-platform-system
    predicates:
      - Path=/v2/lens/platform/system/swagger-ui.html, /v2/lens/platform/system/swagger-ui/**, /v2/lens/platform/system/v3/api-docs/**
    filters:
      - StripPrefix=4
      - AddRequestHeader=X-Forwarded-Prefix, /v2/lens/platform/system
      - PreserveHostHeader

  - id: lens-platform-system
    uri: lb://lens-platform-system
    predicates:
      - Path=/v2/lens/platform/system/**
    filters:
      - StripPrefix=4
      - AddRequestHeader=X-Forwarded-Prefix, /v2/lens/platform/system
```

**3. Springdoc Configuration**

Added Springdoc configuration to work with forward headers:

```yaml
# lens-platform-auth.yaml & lens-platform-system.yaml
springdoc:
  api-docs:
    path: /v3/api-docs
  swagger-ui:
    path: /swagger-ui.html
    use-root-path: false
  use-management-port: false
  show-actuator: true
```

### How It Works Now

1. **Browser → Gateway:** `GET http://localhost:8050/v2/lens/platform/auth/swagger-ui.html`
2. **Gateway → Backend:** 
   - Strips `/v2/lens/platform/auth` (4 segments)
   - Forwards: `GET /swagger-ui.html`
   - Adds header: `X-Forwarded-Prefix: /v2/lens/platform/auth`
3. **Backend Processing:**
   - Receives `/swagger-ui.html` with forward header
   - `forward-headers-strategy: framework` reconstructs original URL
   - Knows original path was `/v2/lens/platform/auth/swagger-ui.html`
4. **Backend → Gateway:** 
   - Responds with: `302 Location: /v2/lens/platform/auth/swagger-ui/index.html`
   - **Includes the prefix** because it knows the original context
5. **Gateway → Browser:** Returns redirect with full path
6. **Browser:** Loads `http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html` ✓
7. **Success:** Swagger UI loads with all CSS/JS resources

### Files Modified

**Nacos Configurations (uploaded):**
- `doc/nacos-backup/lens-platform-gateway.yaml`
  - Added `X-Forwarded-Prefix` header to all routes
  - Applied to auth, system, and monitor service routes
  
- `doc/nacos-backup/lens-platform-auth.yaml`
  - Added `server.forward-headers-strategy: framework`
  - Added `server.tomcat.use-relative-redirects: true`
  - Added `springdoc` configuration block

- `doc/nacos-backup/lens-platform-system.yaml`
  - Added `server.forward-headers-strategy: framework`
  - Added `server.tomcat.use-relative-redirects: true`
  - Added `springdoc` configuration block

**Documentation:**
- `doc/openapi/README.md`
  - Updated "Gateway Configuration" section
  - Added detailed explanation of forward headers strategy
  - Documented how the fix works
  - Added troubleshooting section

### Testing

**Restart Services:**
```bash
# Restart gateway to pick up new routes
cd platform/lens-platform-gateway
mvn spring-boot:run &

# Restart auth service to pick up forward headers config
cd platform/lens-platform-auth
mvn spring-boot:run &

# Restart system service
cd platform/lens-platform-system
mvn spring-boot:run &
```

**Test Redirect:**
```bash
# Test that redirect now includes prefix
curl -I http://localhost:8050/v2/lens/platform/auth/swagger-ui.html

# Expected response:
# HTTP/1.1 302
# Location: /v2/lens/platform/auth/swagger-ui/index.html
```

**Test in Browser:**
```
Open: http://localhost:8050/v2/lens/platform/auth/swagger-ui.html
Expected: Swagger UI loads successfully with all styling and functionality
```

### Benefits

✅ **Swagger UI works via gateway with path prefixes**  
✅ **All static resources (CSS, JS, images) load correctly**  
✅ **No code changes required in controllers**  
✅ **Configuration-only solution**  
✅ **Works for all backend services (auth, system, monitor)**  
✅ **Standard Spring Boot forward headers support**  

### Related Documentation

- Forward Headers: https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto.webserver.use-behind-a-proxy-server
- Springdoc OpenAPI: https://springdoc.org/
- Spring Cloud Gateway: https://docs.spring.io/spring-cloud-gateway/reference/

---

## 2026-02-27: Consolidated Configuration Files to conf Directory  
- URL: `http://localhost:8050/v2/lens/platform/auth/swagger-ui.html`
- Error: 404 Not Found or incomplete page load

**Root Cause:**
- Single gateway route with `StripPrefix=4` couldn't handle multiple Swagger UI paths
- Static resources (CSS, JS, images) under `/swagger-ui/**` weren't properly routed
- Security configuration didn't explicitly allow proxied Swagger UI paths

### Solution Implemented

**1. Dedicated Swagger UI Routes**

Added separate high-priority routes for API documentation:

```yaml
routes:
  # Swagger UI route (higher priority)
  - id: lens-platform-auth-swagger
    uri: lb://lens-platform-auth
    predicates:
      - Path=/v2/lens/platform/auth/swagger-ui.html
      - Path=/v2/lens/platform/auth/swagger-ui/**
      - Path=/v2/lens/platform/auth/v3/api-docs/**
    filters:
      - StripPrefix=4
      - PreserveHostHeader
  
  # Regular API route
  - id: lens-platform-auth
    uri: lb://lens-platform-auth
    predicates:
      - Path=/v2/lens/platform/auth/**
    filters:
      - StripPrefix=4
```

Same pattern applied for System service.

**2. Updated Security Configuration**

Added wildcard patterns for proxied Swagger UI:

```java
.pathMatchers("/v2/lens/platform/*/swagger-ui.html").permitAll()
.pathMatchers("/v2/lens/platform/*/swagger-ui/**").permitAll()
.pathMatchers("/v2/lens/platform/*/v3/api-docs/**").permitAll()
```

### Documentation Reorganization

**Created `/doc/openapi/` directory:**
```
/doc/openapi/
  ├── README.md                  - OpenAPI access guide
  ├── OPENAPI_VERIFICATION.md    - Configuration verification
  └── HOW_TO_GET_TOKEN.md        - Token retrieval guide
```

**Moved files:**
- `HOW_TO_GET_TOKEN.md` → `/doc/openapi/`
- `OPENAPI_VERIFICATION.md` → `/doc/openapi/`

### Script Reorganization

**Reorganized scripts by module:**

```
/doc/
├── keycloak/scripts/          - Authentication & token management
│   ├── get-token.sh
│   ├── quick-token.sh
│   ├── configure-client.sh
│   ├── sync-realm.sh
│   └── import-realm.sh
├── testing/scripts/           - API testing
│   ├── test-auth-api.sh
│   └── quick-test-auth.sh
├── deployment/scripts/        - Service management
│   └── start-services.sh
├── nacos-backup/              - Configuration management
│   └── upload-*.sh
└── openapi/                   - API documentation guides
```

### Access URLs

**Direct Access:**
- Gateway: http://localhost:8050/swagger-ui.html
- Auth: http://localhost:8041/swagger-ui.html
- System: http://localhost:8042/swagger-ui.html

**Via Gateway (Now Working):**
- Auth: http://localhost:8050/v2/lens/platform/auth/swagger-ui.html
- System: http://localhost:8050/v2/lens/platform/system/swagger-ui.html

### Public Endpoints

All API documentation endpoints are publicly accessible (no authentication):

- ✅ `/swagger-ui.html` - Swagger UI landing page
- ✅ `/swagger-ui/**` - Swagger UI static resources
- ✅ `/v3/api-docs/**` - OpenAPI JSON specifications
- ✅ `/actuator/**` - Health and metrics
- ✅ `/v2/lens/platform/*/swagger-ui.html` - Proxied Swagger UI
- ✅ `/v2/lens/platform/*/swagger-ui/**` - Proxied static resources
- ✅ `/v2/lens/platform/*/v3/api-docs/**` - Proxied OpenAPI specs

### Using Swagger UI

**1. Browse Documentation (No Auth):**
- Open URL in browser
- View all endpoints
- See schemas and descriptions

**2. Test Protected Endpoints:**
```bash
# Get token
source doc/keycloak/scripts/quick-token.sh

# In Swagger UI:
# - Click "Authorize" button
# - Paste token
# - Test protected endpoints
```

### Files Updated

**Modified:**
- `/doc/nacos-backup/lens-platform-gateway.yaml`
  - Added dedicated routes for Swagger UI (higher priority)
  - Separate routes for each service's documentation
  - Added PreserveHostHeader filter

- `/platform/lens-platform-gateway/src/.../SecurityConfig.java`
  - Added wildcard patterns for proxied Swagger UI paths
  - Permits `/v2/lens/platform/*/swagger-ui.html`
  - Permits `/v2/lens/platform/*/swagger-ui/**`
  - Permits `/v2/lens/platform/*/v3/api-docs/**`

**Created:**
- `/doc/openapi/README.md` - Complete OpenAPI access guide
- `/doc/keycloak/README.md` - Keycloak scripts documentation
- `/doc/testing/README.md` - Testing scripts documentation
- `/doc/deployment/README.md` - Deployment scripts documentation

**Synchronized:**
- ✅ Uploaded to Nacos (namespace: lens_2026, group: DEFAULT_GROUP)

### Benefits

1. **Better Organization** - Documentation grouped by purpose
2. **Fixed Gateway Access** - Swagger UI now works through gateway
3. **Dedicated Routes** - Separate handling for documentation vs API
4. **Wildcard Support** - Easy to add new services
5. **Consistent Security** - All documentation publicly accessible
6. **Preserved Functionality** - Direct access still works

### Testing

**Restart gateway and test:**
```bash
# Restart gateway
cd platform/lens-platform-gateway
mvn spring-boot:run

# Test in browser
http://localhost:8050/v2/lens/platform/auth/swagger-ui.html
http://localhost:8050/v2/lens/platform/system/swagger-ui.html

# Test with curl
curl http://localhost:8050/v2/lens/platform/auth/v3/api-docs
```

---

## 2026-02-26: OAuth2 Client with Login Redirect to Keycloak

### Overview
Configured API Gateway as OAuth2 Client to redirect unauthenticated browser users to Keycloak login page while maintaining API token-based access.

### Configuration Added

**1. OAuth2 Client Provider (Keycloak)**
```yaml
spring:
  security:
    oauth2:
      client:
        provider:
          keycloak:
            issuer-uri: http://172.28.0.1:28080/realms/lens
            authorization-uri: .../protocol/openid-connect/auth
            token-uri: .../protocol/openid-connect/token
            user-info-uri: .../protocol/openid-connect/userinfo
            jwk-set-uri: .../protocol/openid-connect/certs
```

**2. OAuth2 Client Registration**
```yaml
        registration:
          keycloak:
            client-id: lens-client
            client-secret: x6lEH0DMcT27eop2cszIP3Brc2sDQHLb
            authorization-grant-type: authorization_code
            redirect-uri: "{baseUrl}/login/oauth2/code/{registrationId}"
            scope: [openid, profile, email]
```

**3. Security Configuration**
- Added `.oauth2Login()` for browser login redirect
- Added `/login/**` and `/oauth2/**` to public paths
- Kept `.oauth2ResourceServer()` for API token validation

### Authentication Flows

**Flow 1: Browser Access (Login Redirect)**
1. User accesses protected endpoint without authentication
2. Gateway redirects to Keycloak login page
3. User authenticates with username/password
4. Keycloak redirects back with authorization code
5. Gateway exchanges code for access token
6. Gateway creates session for user
7. User accesses protected resources

**Flow 2: API Access (Token-Based)**
1. API client obtains token from Keycloak
2. Client sends request with `Authorization: Bearer <token>`
3. Gateway validates JWT token
4. Gateway forwards request with token to backend (TokenRelay)

### Gateway Dual Role

The Gateway now acts as:
1. **OAuth2 Client** - For browser login redirect
2. **OAuth2 Resource Server** - For API token validation
3. **Reverse Proxy** - With TokenRelay to backend services

### Public Endpoints (No Authentication)
- `/actuator/**` - Health checks and metrics
- `/swagger-ui/**` - API documentation
- `/v3/api-docs/**` - OpenAPI specs
- `/login/**` - OAuth2 login endpoints
- `/oauth2/**` - OAuth2 callback endpoints

### Protected Endpoints (Require Authentication)
- `/v2/lens/platform/auth/**`
- `/v2/lens/platform/system/**`
- `/v2/lens/platform/monitor/**`

### Keycloak Client Requirements

For browser login to work, the Keycloak client must have:
- **Access Type**: confidential
- **Valid Redirect URIs**: `http://localhost:8050/login/oauth2/code/keycloak`
- **Web Origins**: `http://localhost:8050`
- **Standard Flow Enabled**: ON
- **Direct Access Grants Enabled**: ON

### Testing

**Test Browser Login:**
```bash
# Open browser and navigate to:
http://localhost:8050/v2/lens/platform/auth/echo

# Expected: Redirect to Keycloak login
# After login: Access granted to protected resource
```

**Test API Access:**
```bash
# Get token
TOKEN=$(curl -s -X POST "http://172.28.0.1:28080/realms/lens/protocol/openid-connect/token" \
  -d "client_id=lens-client" \
  -d "client_secret=x6lEH0DMcT27eop2cszIP3Brc2sDQHLb" \
  -d "grant_type=client_credentials" \
  | jq -r '.access_token')

# Call API
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8050/v2/lens/platform/auth/echo
```

### Files Updated

**Modified:**
- `/doc/nacos-backup/lens-platform-gateway.yaml`
  - Added OAuth2 client configuration
  - Added provider and registration for Keycloak
  - Kept resource server configuration

- `/platform/lens-platform-gateway/src/.../SecurityConfig.java`
  - Added `.oauth2Login()` configuration
  - Updated public paths to include `/login/**` and `/oauth2/**`
  - Kept `.oauth2ResourceServer()` for JWT validation

- `/conf/env/lens_2026.env`
  - Added `KEYCLOAK_CLIENT_ID=lens-client`
  - Added `KEYCLOAK_CLIENT_SECRET=x6lEH0DMcT27eop2cszIP3Brc2sDQHLb`

**Synchronized:**
- ✅ Uploaded to Nacos (namespace: lens_2026, group: DEFAULT_GROUP)

### Benefits

1. **Dual Authentication** - Supports both browser login and API tokens
2. **User-Friendly** - Browser users automatically redirected to login
3. **API Compatible** - API clients use Bearer tokens as before
4. **Single Sign-On** - SSO with Keycloak across applications
5. **Session Management** - Spring Security manages user sessions
6. **Centralized Auth** - All authentication at gateway level
7. **Token Forwarding** - TokenRelay forwards tokens to backends

### Dependencies

All required OAuth2 dependencies already present:
- `spring-boot-starter-oauth2-client`
- `spring-security-oauth2-resource-server`
- `spring-boot-starter-webflux`
- `spring-cloud-starter-gateway`

---

## 2026-02-26: Gateway Configured as OAuth2 Resource Server with TokenRelay

### Overview
Configured API Gateway as an OAuth2 Resource Server with JWT validation and TokenRelay filter to work with Keycloak identity server.

### Keycloak Setup

**Server Configuration:**
- URL: http://172.28.0.1:28080 (localhost:28080)
- Realm: lens
- Admin Credentials: admin/admin
- Realm Configuration: doc/keycloak/realm-lens.json

### Changes Made

**1. Updated SecurityConfig.java**
- Enabled OAuth2 Resource Server with JWT
- Configured ReactiveJwtDecoder with JWK Set URI
- Public endpoints: /actuator/**, /v3/api-docs/**, /swagger-ui/**
- All other endpoints require authentication
- Added Keycloak URLs to CORS configuration

**2. Updated Nacos Gateway Configuration**
```yaml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          jwk-set-uri: http://172.28.0.1:28080/realms/lens/protocol/openid-connect/certs
          issuer-uri: http://172.28.0.1:28080/realms/lens
  cloud:
    gateway:
      default-filters:
        - TokenRelay=  # Automatically forwards access token to downstream
```

**3. Updated Environment Configuration**
```bash
export KEYCLOAK_ADMIN_USERNAME=admin
export KEYCLOAK_ADMIN_PASSWORD=admin
```

### TokenRelay Filter

**Purpose:** Automatically forwards OAuth2 access token from gateway to downstream services

**Configuration:**
- Added as default filter in `spring.cloud.gateway.default-filters`
- Applied to all routes automatically

**Routes with TokenRelay:**
- `/v2/lens/platform/auth/**` → lens-platform-auth
- `/v2/lens/platform/system/**` → lens-platform-system
- `/v2/lens/platform/monitor/**` → lens-platform-monitor

### Authentication Flow

1. **Client → Keycloak:** Authenticate and get JWT access token
2. **Client → Gateway:** Send request with `Authorization: Bearer <token>`
3. **Gateway:** Validates JWT using JWK Set from Keycloak
4. **Gateway → Backend:** Forwards request with token (TokenRelay)
5. **Backend:** Receives request with authenticated user context

### Security Configuration

**Public Endpoints (No Authentication):**
- `/actuator/**` - Health checks and metrics
- `/v3/api-docs/**` - OpenAPI documentation
- `/swagger-ui/**` - Swagger UI
- `/swagger-ui.html` - Swagger UI landing page

**Protected Endpoints:**
- All other paths require valid JWT token

**JWT Validation:**
- Decoder: NimbusReactiveJwtDecoder
- JWK Set URI: http://172.28.0.1:28080/realms/lens/protocol/openid-connect/certs
- Lazy loading: Does not connect to Keycloak at startup

### Benefits

1. **Centralized Authentication** - Single point of OAuth2 configuration at gateway
2. **Automatic Token Forwarding** - Backend services receive authenticated user context
3. **Simplified Backend** - No need for backend services to validate JWT
4. **Security at Edge** - Authentication handled at gateway layer
5. **Flexible Access Control** - Easy to add/modify public endpoints

### Example Usage

```bash
# Get token from Keycloak
TOKEN=$(curl -X POST "http://172.28.0.1:28080/realms/lens/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=user" \
  -d "password=pass" \
  -d "grant_type=password" \
  -d "client_id=client_id" \
  | jq -r '.access_token')

# Call gateway with token
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8050/v2/lens/platform/auth/users/me

# Public endpoint (no token needed)
curl http://localhost:8050/actuator/health
```

### Files Updated

**Modified:**
- `/platform/lens-platform-gateway/src/main/java/com/lens/platform/gateway/config/security/SecurityConfig.java`
  - Added OAuth2 Resource Server configuration
  - Configured ReactiveJwtDecoder
  - Updated endpoint authorization rules
  - Added Keycloak CORS origins

- `/doc/nacos-backup/lens-platform-gateway.yaml`
  - Added OAuth2 JWT configuration
  - Added default-filters with TokenRelay
  - Added Keycloak admin credentials
  - Added OAuth2 security logging

- `/conf/env/lens_2026.env`
  - Added KEYCLOAK_ADMIN_USERNAME
  - Added KEYCLOAK_ADMIN_PASSWORD

**Synchronized:**
- ✅ Uploaded to Nacos (namespace: lens_2026, group: DEFAULT_GROUP)

### Dependencies

All required OAuth2 dependencies already present in pom.xml:
- `spring-boot-starter-oauth2-client`
- `spring-security-oauth2-resource-server`
- `spring-boot-starter-webflux`
- `spring-cloud-starter-gateway`

### Testing

**Verify Gateway as OAuth2 Resource Server:**
```bash
# Should work (public)
curl http://localhost:8050/actuator/health

# Should return 401 Unauthorized
curl http://localhost:8050/v2/lens/platform/auth/test

# Should work with valid token
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8050/v2/lens/platform/auth/test
```

---

## 2026-02-26: Documentation Consolidation

### Overview
Simplified project documentation by consolidating multiple markdown files into two main documents: README.md (root) and HISTORY.md (doc/).

### Changes Made

**Deleted Files:**
- `/doc/TROUBLESHOOTING.md` - Content merged into README.md
- `/doc/NACOS_VERIFICATION.md` - Information already in HISTORY.md
- `/doc/QUICKREF_ENV.md` - Content merged into README.md
- `/doc/env/README.md` - Content merged into README.md
- `/doc/nacos-backup/README.md` - Content merged into README.md

**Enhanced README.md:**
Added the following sections:
1. **环境配置 (Environment Configuration)**
   - Environment variable management
   - Service startup commands
   - Key environment variables table
   
2. **Nacos 配置管理 (Nacos Configuration Management)**
   - Configuration file locations
   - Upload instructions
   - Verification commands
   
3. **Gateway 路由配置 (Gateway Routes)**
   - RESTful route patterns
   - API usage examples
   
4. **故障排查 (Troubleshooting)**
   - Common issues and solutions
   - Useful commands

5. **文档 (Documentation)**
   - Reference to all documentation files

### Documentation Structure

**Before:**
```
lens_2026/
├── README.md
├── doc/
│   ├── HISTORY.md
│   ├── TROUBLESHOOTING.md
│   ├── NACOS_VERIFICATION.md
│   ├── QUICKREF_ENV.md
│   ├── env/
│   │   └── README.md
│   └── nacos-backup/
│       └── README.md
└── scripts/
```

**After:**
```
lens_2026/
├── README.md              ← Enhanced with all essential content
├── doc/
│   ├── HISTORY.md        ← Detailed change history
│   ├── env/
│   │   └── lens_2026.env
│   └── nacos-backup/
│       ├── *.yaml
│       └── upload-*.sh
└── scripts/
    └── start-services.sh
```

### Benefits

1. **Simplified Structure** - Only 2 main markdown files to maintain
2. **Better Organization** - All essential info in README.md, history in HISTORY.md
3. **Less Duplication** - Removed redundant content across files
4. **Easier Discovery** - Users find everything in main README
5. **Maintained History** - All technical changes preserved in HISTORY.md

### Content Distribution

**README.md contains:**
- Project overview and architecture
- Quick start guide
- Environment configuration
- Nacos configuration management
- Gateway routing
- Troubleshooting
- Common commands

**HISTORY.md contains:**
- All historical changes
- Technical implementation details
- Migration notes
- Configuration evolution

---

## 2026-02-25: Gateway Routes Updated to RESTful Path Pattern

### Overview
Updated gateway routing configuration to use a more RESTful and versioned path pattern: `/v2/lens/platform/{service}/**`

### Changes Made

**Updated Gateway Routes:**
- Old pattern: `/{service}/**` with `StripPrefix=1`
- New pattern: `/v2/lens/platform/{service}/**` with `StripPrefix=4`

**Route Changes:**

| Service | Old Path | New Path | StripPrefix |
|---------|----------|----------|-------------|
| Auth | `/auth/**` | `/v2/lens/platform/auth/**` | 1 → 4 |
| System | `/system/**` | `/v2/lens/platform/system/**` | 1 → 4 |
| Monitor | `/monitor/**` | `/v2/lens/platform/monitor/**` | 1 → 4 |

### How StripPrefix Works

`StripPrefix=4` removes the first 4 path segments before forwarding:

**Example:**
```
Request:  GET /v2/lens/platform/auth/users/123
Segments: [v2] [lens] [platform] [auth] [users] [123]
Strip 4:  Remove [v2] [lens] [platform] [auth]
Forward:  GET /users/123 → lens-platform-auth service
```

### API Usage Examples

**Auth Service:**
```bash
# Login
curl http://localhost:8050/v2/lens/platform/auth/login

# User info
curl http://localhost:8050/v2/lens/platform/auth/users/me
```

**System Service:**
```bash
# List users
curl http://localhost:8050/v2/lens/platform/system/users

# Get user
curl http://localhost:8050/v2/lens/platform/system/users/123
```

**Monitor Service:**
```bash
# Health check
curl http://localhost:8050/v2/lens/platform/monitor/actuator/health

# Metrics
curl http://localhost:8050/v2/lens/platform/monitor/actuator/metrics
```

### Benefits

1. **Versioning** - Path includes version (`/v2/`) for API evolution
2. **Namespace** - Clear namespace (`/lens/platform/`) for organization
3. **Consistency** - All services follow the same pattern
4. **RESTful** - More professional and standard API structure
5. **Clarity** - Path clearly indicates: version/organization/module/service

### Files Updated

**Modified:**
- `/doc/nacos-backup/lens-platform-gateway.yaml`
  - Updated all route paths to `/v2/lens/platform/{service}/**`
  - Changed `StripPrefix` from 1 to 4

**Synchronized:**
- ✅ Uploaded to Nacos (namespace: lens_2026, group: DEFAULT_GROUP)
- ✅ Verified in Nacos server

### Migration Notes

**For API Consumers:**
- Update all API calls to use new path prefix: `/v2/lens/platform/`
- Old paths (`/auth/**`, `/system/**`, `/monitor/**`) will not work

**Examples:**
```bash
# Old (deprecated)
curl http://localhost:8050/auth/login

# New (correct)
curl http://localhost:8050/v2/lens/platform/auth/login
```

---

## 2026-02-25: Environment Configuration with Dynamic Variables

### Overview
Created comprehensive environment configuration system to eliminate hardcoded IPs and ports. All configuration values are now dynamic and loaded from environment variables with sensible defaults.

### Changes Made

**Created:**
- `/conf/env/lens_2026.env` - Main environment configuration file with all variables
- `/doc/env/README.md` - Documentation for environment configuration
- `/scripts/start-services.sh` - Service startup script that loads environment

**Modified:**
- `/doc/nacos-backup/lens-platform-gateway.yaml` - Now uses environment variables
- `/doc/nacos-backup/lens-platform-auth.yaml` - Now uses environment variables
- `/doc/nacos-backup/lens-platform-system.yaml` - Now uses environment variables
- `/doc/nacos-backup/lens-platform-monitor.yaml` - Now uses environment variables

### Environment Variables

**Infrastructure Services:**
- `NACOS_HOST`, `NACOS_PORT`, `NACOS_SERVER_ADDR`, `NACOS_NAMESPACE`, `NACOS_GROUP`
- `KEYCLOAK_HOST`, `KEYCLOAK_PORT`, `KEYCLOAK_URL`, `KEYCLOAK_REALM`
- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USERNAME`, `DB_PASSWORD`, `DB_URL`
- `REDIS_HOST`, `REDIS_PORT`, `REDIS_PASSWORD`, `REDIS_DATABASE`
- `RABBITMQ_HOST`, `RABBITMQ_PORT`, `RABBITMQ_USERNAME`, `RABBITMQ_PASSWORD`

**Platform Service Ports:**
- `GATEWAY_PORT` (8050), `GATEWAY_HOST`, `GATEWAY_URL`
- `AUTH_PORT` (8041), `AUTH_HOST`, `AUTH_URL`
- `SYSTEM_PORT` (8042), `SYSTEM_HOST`, `SYSTEM_URL`
- `MONITOR_PORT` (8043), `MONITOR_HOST`, `MONITOR_URL`

**Security Configuration:**
- `JWT_JWK_SET_URI` - Derived from Keycloak URL and realm
- `JWT_ISSUER_URI` - Derived from Keycloak URL and realm

**Logging Configuration:**
- `LOG_LEVEL_ROOT`, `LOG_LEVEL_LENS`, `LOG_LEVEL_SPRING_SECURITY`, `LOG_LEVEL_SPRING_GATEWAY`

**Other:**
- `OPENAPI_VERSION`, `SPRING_PROFILES_ACTIVE`, `PROMETHEUS_URL`, `ZIPKIN_URL`

### Nacos Configuration Changes

All Nacos YAML files now use Spring Boot's property placeholder syntax:

**Before (Hardcoded):**
```yaml
server:
  port: 8050
keycloak:
  url: http://localhost:8080
```

**After (Dynamic):**
```yaml
server:
  port: ${GATEWAY_PORT:8050}
keycloak:
  url: ${KEYCLOAK_URL:http://localhost:8080}
```

**Benefits:**
- Values are read from environment variables
- Defaults provided after colon (`:`)
- No code changes needed
- Environment-specific configuration

### Usage

**Load Environment:**
```bash
source conf/env/lens_2026.env
```

**Start Services:**
```bash
# Using startup script (recommended)
./scripts/start-services.sh start

# Or manually
source conf/env/lens_2026.env
cd platform/lens-platform-gateway
mvn spring-boot:run
```

**Override Values:**
```bash
source conf/env/lens_2026.env
export GATEWAY_PORT=9050
export KEYCLOAK_URL=http://keycloak.example.com:8080
mvn spring-boot:run
```

**Display Configuration:**
```bash
source conf/env/lens_2026.env --show
```

### Service Startup Script

Created `/scripts/start-services.sh` with features:
- Automatic environment loading
- Start/stop/restart/status commands
- Individual or all services
- PID management
- Color-coded output

**Commands:**
```bash
./scripts/start-services.sh start                          # Start all
./scripts/start-services.sh start lens-platform-gateway    # Start gateway
./scripts/start-services.sh stop                           # Stop all
./scripts/start-services.sh status                         # Check status
./scripts/start-services.sh env                            # Show environment
```

### Key Benefits

1. **No Hardcoded Values** - All IPs, ports, URLs are configurable
2. **Environment Flexibility** - Easy dev/test/prod separation
3. **Centralized Configuration** - Single source of truth
4. **Override Capability** - Export variables to override defaults
5. **Default Values** - Works out of box for local development
6. **Version Control** - Track environment configuration changes
7. **Documentation** - Clear variable documentation
8. **Automation** - Scripts handle environment loading

### Migration from Hardcoded Values

| Configuration | Before | After |
|---------------|--------|-------|
| Server Ports | `8050`, `8041`, etc. | `${GATEWAY_PORT:8050}`, `${AUTH_PORT:8041}` |
| Keycloak URL | `http://localhost:8080` | `${KEYCLOAK_URL:http://localhost:8080}` |
| Keycloak Realm | `lens` | `${KEYCLOAK_REALM:lens}` |
| JWT JWK URI | hardcoded URL | `${JWT_JWK_SET_URI:...}` |
| OpenAPI Version | `2.0.0` | `${OPENAPI_VERSION:2.0.0}` |
| Log Levels | `INFO`, `DEBUG` | `${LOG_LEVEL_ROOT:INFO}`, `${LOG_LEVEL_LENS:DEBUG}` |

### Files Uploaded to Nacos

All updated configurations with environment variables uploaded:
- ✅ lens-platform-gateway.yaml
- ✅ lens-platform-auth.yaml
- ✅ lens-platform-system.yaml
- ✅ lens-platform-monitor.yaml

### Documentation

- `/doc/env/README.md` - Complete environment configuration guide
- `/conf/env/lens_2026.env` - Main environment file with all variables
- Inline comments in env file explaining each variable
- Variable defaults for local development

### Next Steps

1. **Create Production Environment:**
   ```bash
   cp conf/env/lens_2026.env doc/env/lens_2026_prod.env
   # Edit production values
   ```

2. **Create Test Environment:**
   ```bash
   cp conf/env/lens_2026.env doc/env/lens_2026_test.env
   # Edit test values
   ```

3. **Use Environment-Specific Files:**
   ```bash
   source doc/env/lens_2026_prod.env
   ./scripts/start-services.sh start
   ```

---

## 2026-02-25: Nacos Configuration Verification and Completion

### Overview
Verified and completed all Nacos configurations for the 4 platform services (gateway, auth, system, monitor), ensuring they are correct, complete, and synchronized with backup files.

### Issues Found and Fixed

1. **Missing Gateway Configuration**
   - Gateway configuration was not in Nacos
   - Created complete gateway configuration with routing rules

2. **Incomplete Service Configurations**
   - Auth, System, Monitor were missing OpenAPI and Keycloak settings
   - These settings are required by OpenAPIConfig.java in each service

3. **Upload Script Incomplete**
   - Script didn't include gateway service
   - Updated to upload all 4 platform services

### Changes Made

**Created:**
- `/doc/nacos-backup/lens-platform-gateway.yaml` - Complete gateway configuration with routes

**Modified:**
- `/doc/nacos-backup/lens-platform-auth.yaml` - Added OpenAPI and Keycloak config
- `/doc/nacos-backup/lens-platform-system.yaml` - Added OpenAPI and Keycloak config
- `/doc/nacos-backup/lens-platform-monitor.yaml` - Added OpenAPI config
- `/doc/nacos-backup/upload-all-configs.sh` - Now uploads all 4 services

**Uploaded to Nacos:**
- ✅ lens-platform-gateway.yaml (port 8050)
- ✅ lens-platform-auth.yaml (port 8041)
- ✅ lens-platform-system.yaml (port 8042)
- ✅ lens-platform-monitor.yaml (port 8043)

### Configuration Summary

| Service | Port | JWT Security | Key Features |
|---------|------|--------------|--------------|
| Gateway | 8050 | No (delegates) | Routes, load balancing, gateway actuator |
| Auth | 8041 | Yes (jwk-set-uri) | JWT validation, OpenAPI, Keycloak |
| System | 8042 | Yes (jwk-set-uri) | JWT validation, OpenAPI, Keycloak |
| Monitor | 8043 | No (public) | Spring Boot Admin, all actuator endpoints |

### Gateway Configuration Highlights

**Routes Configured:**
- `/auth/**` → lens-platform-auth (lb://lens-platform-auth)
- `/system/**` → lens-platform-system (lb://lens-platform-system)
- `/monitor/**` → lens-platform-monitor (lb://lens-platform-monitor)

**Features:**
- Load balancing with Nacos service discovery
- Path prefix stripping
- Gateway-specific actuator endpoints

### Common Configuration Elements

**All Services:**
- Logging: INFO (root), DEBUG (com.lens)
- Actuator: health, metrics, prometheus
- OpenAPI: service title, version, and URL

**Secured Services (Auth, System):**
- JWT: `spring.security.oauth2.resourceserver.jwt.jwk-set-uri`
- Keycloak: URL and realm configuration
- Security logging enabled

### Verification

All configurations verified as:
- ✅ Complete with all required properties
- ✅ Uploaded to Nacos (namespace: lens_2026, group: DEFAULT_GROUP)
- ✅ Synchronized with backup files in `/doc/nacos-backup/`
- ✅ Ready for service startup

### Upload Command

```bash
cd /home/zhenac/my/lens_2026/doc/nacos-backup
./upload-all-configs.sh
```

---

## 2026-02-25: Fixed lens-platform-system and lens-platform-monitor Startup Issues

### Overview
Fixed the JWT decoder configuration issue that prevented `lens-platform-system` and `lens-platform-monitor` from starting due to Keycloak connection attempts at startup.

### Problem
Both services were failing to start with error:
```
Unable to resolve the Configuration with the provided Issuer of "http://localhost:8080/realms/lens"
Caused by: java.net.ConnectException: 连接被拒绝
```

The issue was that `SecurityConfig` was using `NimbusJwtDecoder.withIssuerLocation()` which attempts to connect to Keycloak at application startup to fetch OIDC configuration.

### Solution
1. **Updated lens-platform-system SecurityConfig**
   - Changed from `withIssuerLocation(issuerUri)` to `withJwkSetUri(jwkSetUri)`
   - Changed property from `spring.security.oauth2.resourceserver.jwt.issuer-uri` to `spring.security.oauth2.resourceserver.jwt.jwk-set-uri`
   - This approach avoids connecting to Keycloak during startup

2. **Created Nacos Configuration Files**
   - Created `/doc/nacos-backup/lens-platform-system.yaml` with JWT configuration
   - Created `/doc/nacos-backup/lens-platform-monitor.yaml` (no security configuration needed)
   - Both configured with proper namespace `lens_2026` and group `DEFAULT_GROUP`

3. **Created Upload Automation Script**
   - Created `/doc/nacos-backup/upload-all-configs.sh` to upload all platform service configs
   - Supports lens-platform-auth, lens-platform-system, and lens-platform-monitor
   - Color-coded output for better visibility

### Changes Made

**Modified:**
- `/platform/lens-platform-system/src/main/java/com/lens/platform/system/config/security/SecurityConfig.java`
  - Changed JWT decoder to use JWK Set URI instead of issuer location

**Created:**
- `/doc/nacos-backup/lens-platform-system.yaml` - Nacos config for system service
- `/doc/nacos-backup/lens-platform-monitor.yaml` - Nacos config for monitor service  
- `/doc/nacos-backup/upload-all-configs.sh` - Script to upload all configs
- `/doc/TROUBLESHOOTING.md` - Comprehensive troubleshooting guide

### Configuration Details

**lens-platform-system.yaml:**
```yaml
server:
  port: 8042
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          jwk-set-uri: http://localhost:8080/realms/lens/protocol/openid-connect/certs
```

**lens-platform-monitor.yaml:**
```yaml
server:
  port: 8043
spring:
  boot:
    admin:
      context-path: /admin
```

### Key Differences: withIssuerLocation vs withJwkSetUri

**withIssuerLocation (OLD - causes startup issues):**
- Connects to Keycloak at startup
- Fetches `.well-known/openid-configuration`
- Fails if Keycloak is not running
- Used with property: `spring.security.oauth2.resourceserver.jwt.issuer-uri`

**withJwkSetUri (NEW - recommended):**
- Lazy loading - only connects when JWT validation is needed
- Uses JWK Set URI directly
- Application starts even if Keycloak is down
- Used with property: `spring.security.oauth2.resourceserver.jwt.jwk-set-uri`

### Upload Configurations to Nacos

```bash
cd /home/zhenac/my/lens_2026/doc/nacos-backup
./upload-all-configs.sh
```

### Verification

All configurations successfully uploaded to Nacos:
- ✅ lens-platform-auth.yaml
- ✅ lens-platform-system.yaml  
- ✅ lens-platform-monitor.yaml

Services can now start successfully without requiring Keycloak to be running.

---

## 2026-02-25: Documentation Directory Reorganization

### Overview
Created `doc/` directory to centralize project history and Nacos configuration backup files, while keeping README.md in the root directory for easy access.

### Changes Made

**Created:**
- `/doc/` - Documentation directory for history and backups

**Moved:**
- `/HISTORY.md` → `/doc/HISTORY.md`
- `/nacos-config-examples/` → `/doc/nacos-backup/`

**Kept in Root:**
- `/README.md` - Main project documentation (kept in root for visibility)

### New Project Structure

```
lens_2026/
├── README.md                           # Project overview (root level)
├── doc/
│   ├── HISTORY.md                      # Project history and technical documentation
│   └── nacos-backup/                   # Nacos configuration backup files
│       ├── lens-platform-auth.yaml     # Auth service configuration
│       └── upload-auth-config.sh       # Upload automation script
├── common/                              # Common libraries
├── platform/                            # Platform services
├── infra/                              # Infrastructure services
├── lens-blog/                          # Blog services
└── pom.xml                             # Root POM
```

### Updated Paths

- Main documentation: `/README.md` (root level)
- Project history: `/doc/HISTORY.md`
- Nacos config backups: `/doc/nacos-backup/`
- Upload script: `cd doc/nacos-backup && ./upload-auth-config.sh`

### Benefits
- ✅ README.md easily visible in project root
- ✅ Project history and backups organized in doc/
- ✅ Cleaner root directory
- ✅ Better project organization
- ✅ Follows common conventions (README in root)

---

## 2026-02-25: IDEA Run Configuration Troubleshooting

### Overview
Documented solution for Nacos configuration loading issue when running lens-platform-auth in IntelliJ IDEA.

### Problem
- ✅ Terminal: `mvn spring-boot:run` loads Nacos config correctly
- ❌ IDEA: Shows warning `[Nacos Config] config[dataId=lens-platform-auth.yaml, group=DEFAULT_GROUP] is empty`

### Root Cause
IDEA's Spring Boot run configuration doesn't properly pass the `spring.config.import` parameters from `application.yml` in the same way Maven does.

### Solution: Configure IDEA Run Configuration

**Step 1: Edit Run Configuration**
1. In IDEA: **Run** → **Edit Configurations**
2. Select `LensPlatformAuth` (or create new Spring Boot configuration)

**Step 2: Add Program Arguments**
Add to **Program arguments** field:
```
--spring.config.import=nacos:lens-platform-auth.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true
```

**Step 3: (Optional) Add VM Options for Debugging**
Add to **VM options** field:
```
-Dlogging.level.com.alibaba.cloud.nacos.client=DEBUG
-Dspring.devtools.restart.enabled=false
```

**Step 4: Set Working Directory**
Set **Working directory** to:
```
$MODULE_DIR$
```
Or manually: `/home/zhenac/my/lens_2026/platform/lens-platform-auth`

**Step 5: Apply and Run**
Click **Apply** → **OK** → **Run**

### Verification
After starting, check logs for:
```
[Nacos Config] Load config[dataId=lens-platform-auth.yaml, group=DEFAULT_GROUP] success
```

### Quick Reference: IDEA Run Configuration Template

```
Main class: com.lens.platform.auth.LensPlatformAuth
Working directory: $MODULE_DIR$
Program arguments: --spring.config.import=nacos:lens-platform-auth.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true
VM options: -Dspring.devtools.restart.enabled=false
```

### Why This Happens
- Maven properly processes `application.yml` before starting the app
- IDEA's run configuration may not parse YAML imports the same way
- Explicitly passing as program argument ensures it's loaded first

---

## 2026-02-25: Nacos Configuration Setup and YAML Format Specification

### Overview
Created comprehensive Nacos configuration for lens-platform-auth service with JWT/OAuth2 settings, upload script, and ensured proper YAML format specification to enable syntax highlighting and validation.

### Nacos Configuration Structure
- **Namespace**: `lens_2026`
- **Group**: `DEFAULT_GROUP`
- **Data ID**: `<service-name>.yaml`
- **Format**: `yaml` (IMPORTANT: Not "TEXT")

### Files Created
1. **doc/nacos-backup/lens-platform-auth.yaml** - Complete service configuration
2. **doc/nacos-backup/upload-auth-config.sh** - Automated upload script with `type=yaml`

### Key Configuration Content

```yaml
server:
  port: 8041

spring:
  application:
    name: lens-platform-auth
  security:
    oauth2:
      resourceserver:
        jwt:
          # JWK Set URI for lazy loading - only connects when validating tokens
          jwk-set-uri: http://localhost:8080/realms/lens/protocol/openid-connect/certs

logging:
  level:
    root: INFO
    com.lens: DEBUG
    org.springframework.security: DEBUG

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

### How to Upload Configuration to Nacos

**Method 1: Using Upload Script**
```bash
cd doc/nacos-backup
./upload-auth-config.sh
```

**Method 2: Using curl with YAML format**
```bash
curl -X POST "http://localhost:8848/nacos/v1/cs/configs" \
  --data-urlencode "dataId=lens-platform-auth.yaml" \
  --data-urlencode "group=DEFAULT_GROUP" \
  --data-urlencode "tenant=lens_2026" \
  --data-urlencode "type=yaml" \
  --data-urlencode "content@lens-platform-auth.yaml"
```

**Method 3: Using Nacos Web UI (RECOMMENDED)**
1. Open http://localhost:8848/nacos
2. Login (nacos/nacos)
3. Go to "Configuration Management" → "Configurations"
4. Click "+" to create new configuration
5. Fill in:
   - **Namespace**: `lens_2026`
   - **Data ID**: `lens-platform-auth.yaml`
   - **Group**: `DEFAULT_GROUP`
   - **Format**: **yaml** ⚠️ (Select "yaml" from dropdown, NOT "TEXT")
   - **Content**: Copy from `doc/nacos-backup/lens-platform-auth.yaml`
6. Click "Publish"

### CRITICAL: YAML Format Selection

**⚠️ IMPORTANT**: Always select **"yaml"** as the format type when uploading to Nacos.

**Why this matters:**
- **yaml format**: Syntax highlighting, YAML validation, better editing experience
- **TEXT format**: No syntax highlighting, no validation, harder to debug

**To verify format after upload:**
1. Open Nacos console → Configuration Management
2. Select namespace `lens_2026`
3. Click on `lens-platform-auth.yaml`
4. Verify "Format" field shows **"yaml"** (not "TEXT")

**If it shows "TEXT", fix it:**
1. Click "Edit"
2. Change Format dropdown to "yaml"
3. Click "Publish"

### Verification

After uploading, check application logs when starting lens-platform-auth:
```
[Nacos Config] Load config[dataId=lens-platform-auth.yaml, group=DEFAULT_GROUP] success
```

Or verify via API:
```bash
curl "http://localhost:8848/nacos/v1/cs/configs?dataId=lens-platform-auth.yaml&group=DEFAULT_GROUP&tenant=lens_2026"
```

### Benefits
- ✅ Centralized configuration management
- ✅ Dynamic configuration refresh without restart
- ✅ Proper YAML syntax highlighting in Nacos UI
- ✅ Built-in YAML validation
- ✅ Environment-specific settings without code changes
- ✅ Version control for configurations

---

## 2026-02-25: JWT Security Configuration Fix

### Overview
Fixed JWT decoder startup failure in lens-platform-auth where application was trying to connect to Keycloak during initialization, causing startup failures when Keycloak was not running.

### Problem
The application failed to start with error:
```
Unable to resolve the Configuration with the provided Issuer of "http://localhost:8080/realms/lens"
Caused by: java.net.ConnectException: 连接被拒绝
```

The JwtDecoder was using `NimbusJwtDecoder.withIssuerLocation(issuerUri)` which attempts to connect to Keycloak's OpenID configuration endpoint during bean initialization to validate the issuer. This caused the application to fail startup when Keycloak was not accessible.

### Solution
Changed JwtDecoder configuration to use JWK Set URI directly instead of issuer location:
- **Before**: `NimbusJwtDecoder.withIssuerLocation(issuerUri)` - Connects to Keycloak at startup
- **After**: `NimbusJwtDecoder.withJwkSetUri(jwkSetUri)` - Only connects when validating tokens

### File Changed
- `/platform/lens-platform-auth/src/main/java/com/lens/platform/auth/config/security/SecurityConfig.java`
  - Changed from `spring.security.oauth2.resourceserver.jwt.issuer-uri` 
  - To `spring.security.oauth2.resourceserver.jwt.jwk-set-uri`
  - Updated default value to point directly to the JWK endpoint

### Benefits
1. ✅ Application starts successfully without requiring Keycloak to be running
2. ✅ JWT validation still works when Keycloak is running and tokens are presented
3. ✅ Follows lazy-loading principle - only connects to external services when needed
4. ✅ Better development experience - services can start independently

### Result
```
2026-02-25T10:54:17.697+08:00  INFO 3670664 --- [lens-platform-auth] [           main] c.a.c.n.registry.NacosServiceRegistry    : nacos registry, DEFAULT_GROUP lens-platform-auth 192.168.0.5:8041 register finished
2026-02-25T10:54:17.725+08:00  INFO 3670664 --- [lens-platform-auth] [           main] c.lens.platform.auth.LensPlatformAuth    : Started LensPlatformAuth in 5.288 seconds (process running for 5.804)
```

---

## 2026-02-24: Bootstrap to Application.yml Migration & Configuration Fixes

### Overview
Migrated all platform services from legacy `bootstrap.yml` + `spring-cloud-starter-bootstrap` to modern `application.yml` + `spring.config.import` approach. Fixed critical Nacos configuration loading and JWT security issues.

---

## Change 1: Bootstrap Context Migration

### Problem
- Using deprecated `bootstrap.yml` files
- Required `spring-cloud-starter-bootstrap` dependency
- Needed separate `application.properties` to enable bootstrap context
- Not following Spring Boot 2.4+ recommended practices

### Solution
- Migrated to `spring.config.import` in `application.yml`
- Removed all `bootstrap.yml` files
- Removed `application.properties` files
- Removed `spring-cloud-starter-bootstrap` dependencies

### Services Migrated
1. ✅ lens-platform-gateway
2. ✅ lens-platform-auth
3. ✅ lens-platform-system
4. ✅ lens-platform-monitor

### Files Removed
- `/platform/lens-platform-gateway/src/main/resources/bootstrap.yml`
- `/platform/lens-platform-gateway/src/main/resources/application.properties`
- `/platform/lens-platform-auth/src/main/resources/bootstrap.yml`
- `/platform/lens-platform-system/src/main/resources/bootstrap.yml`

### Files Created/Updated
- `/platform/lens-platform-gateway/src/main/resources/application.yml` (updated)
- `/platform/lens-platform-auth/src/main/resources/application.yml` (created)
- `/platform/lens-platform-system/src/main/resources/application.yml` (updated)
- `/platform/lens-platform-monitor/src/main/resources/application.yml` (created)

### POM Changes
Removed from all three services:
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-bootstrap</artifactId>
</dependency>
```

---

## Change 2: Nacos Config Import Fix (CRITICAL)

### Problem
Services couldn't read configuration from Nacos because `spring.config.import` URL was missing required `namespace` and `group` parameters.

### Root Cause
With `spring.config.import`, the import happens EARLY in the bootstrap phase. URL parameters are parsed immediately, but `spring.cloud.nacos.config.*` properties are read TOO LATE.

### Solution
Added `namespace` and `group` as URL query parameters in the import statement.

**Before (Wrong)**:
```yaml
spring.config.import:
  - nacos:lens-platform-auth.yaml?refresh=true
```

**After (Correct)**:
```yaml
spring.config.import:
  - nacos:lens-platform-auth.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true
```

### Configuration Template
```yaml
server:
  port: 8041  # Default fallback port

spring:
  application:
    name: lens-platform-auth
  config:
    import:
      - nacos:lens-platform-auth.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true
  cloud:
    nacos:
      server-addr: ${nacos:localhost}:8848
      config:
        server-addr: ${nacos:localhost}:8848
        file-extension: yaml
        namespace: lens_2026
        group: DEFAULT_GROUP
        enabled: true
        refresh-enabled: true
      discovery:
        server-addr: ${nacos:localhost}:8848
        namespace: lens_2026
        enabled: true
```

### Key Points
- Must NOT use `optional:` prefix (ensures config loaded before server starts)
- Must include `group=DEFAULT_GROUP` in URL
- Must include `namespace=lens_2026` in URL
- Local `server.port` acts as fallback

---

## Change 3: Port Loading Order Fix

### Problem
Netty server was starting on default port 8080 BEFORE loading `server.port` from Nacos config.

### Solution
1. Removed `optional:` prefix from config import (makes Nacos config mandatory)
2. Added local `server.port` fallback in application.yml

### Configuration Loading Order (Fixed)
1. Load `application.yml` (includes local fallback port)
2. Import Nacos config (BEFORE server initialization)
3. Merge configurations (Nacos overrides local)
4. Start server with correct port from Nacos

### Service Ports
- lens-platform-gateway: 8050
- lens-platform-auth: 8041
- lens-platform-system: 8042
- lens-platform-monitor: 8043

---

## Change 4: Dockerfiles Created

### Files Created
1. `/platform/lens-platform-system/Dockerfile` - Port 8042
2. `/platform/lens-platform-monitor/Dockerfile` - Port 8043

### Dockerfile Template
```dockerfile
FROM openjdk:17.0.2-jdk
MAINTAINER lensson.zhen@gmail.com
ARG JAR_FILE
COPY ${JAR_FILE} /opt/app.jar
ENV DATAPATH /data
VOLUME $DATAPATH
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/opt/app.jar"]
EXPOSE [SERVICE_PORT]
```

---

## Change 5: POM.xml Updates - Nacos Dependencies

### Dependencies Added to All Platform Modules

```xml
<!-- Nacos Config - required to load config from Nacos -->
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
</dependency>

<!-- Nacos Discovery - service registration and discovery -->
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
</dependency>

<!-- spring boot admin client -->
<dependency>
    <groupId>de.codecentric</groupId>
    <artifactId>spring-boot-admin-starter-client</artifactId>
    <version>${spring-boot-admin-starter-client.version}</version>
</dependency>
```

### Build Plugin Updates

Added/Updated in all modules:
```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <executions>
        <execution>
            <goals>
                <goal>repackage</goal>
            </goals>
        </execution>
    </executions>
</plugin>
<plugin>
    <groupId>com.spotify</groupId>
    <artifactId>dockerfile-maven-plugin</artifactId>
    <version>${dockerfile.maven.version}</version>
    <configuration>
        <repository>${docker.image.prefix}/${project.artifactId}</repository>
        <contextDirectory>./</contextDirectory>
        <tag>${project.version}</tag>
        <buildArgs>
            <JAR_FILE>target/${project.build.finalName}.jar</JAR_FILE>
        </buildArgs>
    </configuration>
</plugin>
```

### lens-platform-monitor POM
Created complete POM with all dependencies:
- spring-boot-starter-web
- spring-cloud-starter-alibaba-nacos-config
- spring-cloud-starter-alibaba-nacos-discovery
- spring-boot-admin-starter-client
- spring-boot-starter-actuator
- springdoc-openapi-starter-webmvc-ui
- spring-boot-starter-test

---

## Change 6: JWT Security Configuration Fix

### Problem
Services failed to start with error:
```
APPLICATION FAILED TO START
Required a bean of type 'org.springframework.security.oauth2.jwt.JwtDecoder' that could not be found.
```

### Root Cause
SecurityConfig used `.oauth2ResourceServer().jwt()` but no `JwtDecoder` bean was defined.

### Solution
Added `JwtDecoder` bean to SecurityConfig in both services.

### Code Added

**lens-platform-auth** and **lens-platform-system**:
```java
@Value("${spring.security.oauth2.resourceserver.jwt.issuer-uri:http://localhost:8080/realms/lens}")
private String issuerUri;

@Bean
public JwtDecoder jwtDecoder() {
    return NimbusJwtDecoder.withIssuerLocation(issuerUri).build();
}
```

### Updated Permit List
```java
http.authorizeHttpRequests(auth -> auth
    .requestMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html", "/actuator/**").permitAll()
    .anyRequest().authenticated())
```

### Required Nacos Configuration
Add to each service's Nacos config:
```yaml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: http://localhost:8080/realms/lens
```

---

## Platform Services Matrix

| Service | Port | Nacos Config | Nacos Discovery | Admin Client | Dockerfile | application.yml | JwtDecoder |
|---------|------|:------------:|:---------------:|:------------:|:----------:|:---------------:|:----------:|
| lens-platform-gateway | 8050 | ✅ | ✅ | ✅ | ✅ | ✅ | N/A |
| lens-platform-auth | 8041 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| lens-platform-system | 8042 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| lens-platform-monitor | 8043 | ✅ | ✅ | ✅ | ✅ | ✅ | N/A |

---

## Required Nacos Configurations

In Nacos console (`http://localhost:8848/nacos`):

**Namespace**: `lens_2026`  
**Group**: `DEFAULT_GROUP`

### lens-platform-gateway.yaml
```yaml
server:
  port: 8050
```

### lens-platform-auth.yaml
```yaml
server:
  port: 8041
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: http://localhost:8080/realms/lens
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics
```

### lens-platform-system.yaml
```yaml
server:
  port: 8042
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: http://localhost:8080/realms/lens
```

### lens-platform-monitor.yaml
```yaml
server:
  port: 8043
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

---

## Build & Run Instructions

### Prerequisites
1. Nacos running on `localhost:8848`
2. Keycloak running on `localhost:8080` with realm `lens` (for auth/system services)
3. Configuration exists in Nacos (namespace: `lens_2026`, group: `DEFAULT_GROUP`)

### Build All Platform Services
```bash
cd /home/zhenac/my/lens_2026
mvn clean package -pl platform/lens-platform-gateway,platform/lens-platform-auth,platform/lens-platform-system,platform/lens-platform-monitor -am -DskipTests
```

### Run Services
```bash
# Gateway
cd platform/lens-platform-gateway
mvn spring-boot:run

# Auth (in new terminal)
cd platform/lens-platform-auth
mvn spring-boot:run

# System (in new terminal)
cd platform/lens-platform-system
mvn spring-boot:run

# Monitor (in new terminal)
cd platform/lens-platform-monitor
mvn spring-boot:run
```

### Build Docker Images
```bash
# Gateway
mvn dockerfile:build -pl platform/lens-platform-gateway

# Auth
mvn dockerfile:build -pl platform/lens-platform-auth

# System
mvn dockerfile:build -pl platform/lens-platform-system

# Monitor
mvn dockerfile:build -pl platform/lens-platform-monitor
```

---

## Testing Endpoints

### Gateway (8050)
```bash
curl http://localhost:8050/actuator/health
```

### Auth (8041)
```bash
# Health check
curl http://localhost:8041/actuator/health

# Swagger UI
curl http://localhost:8041/swagger-ui.html

# With JWT token
TOKEN=$(curl -X POST http://localhost:8080/realms/lens/protocol/openid-connect/token \
  -d "client_id=YOUR_CLIENT" \
  -d "client_secret=YOUR_SECRET" \
  -d "grant_type=client_credentials" | jq -r '.access_token')
curl http://localhost:8041/api/endpoint -H "Authorization: Bearer $TOKEN"
```

### System (8042)
```bash
curl http://localhost:8042/actuator/health
```

### Monitor (8043)
```bash
curl http://localhost:8043/actuator/health
```

---

## Troubleshooting

### Service Can't Read Nacos Config
**Symptom**: Missing log line: `Located property source: NacosPropertySource`

**Check**:
1. Verify config import URL includes `group` and `namespace`:
   ```yaml
   spring.config.import: nacos:service-name.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true
   ```
2. Verify Nacos is running: `curl http://localhost:8848/nacos`
3. Verify config exists in Nacos console

### JWT Decoder Error
**Symptom**: `Required a bean of type 'org.springframework.security.oauth2.jwt.JwtDecoder'`

**Check**:
1. Verify Keycloak is running: `curl http://localhost:8080/realms/lens/.well-known/openid-configuration`
2. Verify issuer-uri in Nacos config
3. Check dependencies include `spring-security-oauth2-resource-server` and `spring-security-oauth2-jose`

### Wrong Port Used
**Symptom**: Service starts on 8080 instead of configured port

**Check**:
1. Verify config import does NOT use `optional:` prefix
2. Verify Nacos config includes `server.port`
3. Check logs for successful config loading

---

## Key Learnings

1. **spring.config.import requires URL parameters**: Must include `group` and `namespace` in import URL, not just in `spring.cloud.nacos.config`

2. **No optional: for production**: Using `optional:` allows server to start without Nacos config, bypassing port configuration

3. **JwtDecoder must be explicit**: Even with `oauth2ResourceServer().jwt()`, you must define a `JwtDecoder` bean

4. **Bootstrap context is deprecated**: Use `spring.config.import` instead of `bootstrap.yml` in Spring Boot 2.4+

5. **Local fallbacks are important**: Always provide local `server.port` as fallback even when using Nacos

---

## Files Modified Summary

### Configuration Files
- 4 application.yml created/updated
- 4 bootstrap.yml removed
- 1 application.properties removed

### Code Files
- 2 SecurityConfig.java updated (auth, system)

### Docker Files
- 2 Dockerfile created (system, monitor)

### POM Files
- 3 pom.xml updated (auth, system, monitor)

### Documentation
- 1 HISTORY.md created (this file)

---

**Last Updated**: 2026-02-25  
**Spring Boot Version**: 3.2.0  
**Spring Cloud Version**: 2023.0.0  
**Configuration Method**: spring.config.import (modern approach)  
**Status**: ✅ All platform services configured and ready

---

## 2026-02-25: Placeholder Resolution Fix & POM Naming Refactor

### Change 7: Fixed Placeholder Resolution Errors

#### Problem
Application failed to start with error:
```
Could not resolve placeholder 'keycloak.url' in value "${keycloak.url}"
```

Also warning in logs:
```
[Nacos Config] config[dataId=lens-platform-auth.yaml, group=DEFAULT_GROUP] is empty
```

#### Root Cause
1. `@Value` annotations in `OpenAPIConfig` were trying to load properties **before** Nacos config was available
2. No configuration existed in Nacos console for `lens-platform-auth.yaml`

#### Solution
**Step 1**: Added default values to `@Value` annotations
```java
@Value("${keycloak.url:http://localhost:8080}")
String authServerUrl;
@Value("${keycloak.realm:lens}")
String realm;

@Bean
public OpenAPI openAPI(
    @Value("${openapi.service.title:Lens Platform Auth}") String serviceTitle,
    @Value("${openapi.service.version:2.0}") String serviceVersion,
    @Value("${openapi.service.url:http://localhost:8041}") String url) {
```

**Step 2**: Added local fallback properties in `application.yml`
```yaml
# Local fallback configuration (will be overridden by Nacos)
keycloak:
  url: http://localhost:8080
  realm: lens

openapi:
  service:
    title: Lens Platform Auth
    version: "2.0"
    url: http://localhost:8041
```

**Step 3**: CREATE Configuration in Nacos Console

**IMPORTANT**: You must manually create the configuration in Nacos!

### How to Create Nacos Configuration

#### Access Nacos Console
1. Open browser: `http://localhost:8848/nacos`
2. Login with username: `nacos`, password: `nacos`

#### Create Configuration for lens-platform-auth
1. Click **Configuration Management** → **Configurations**
2. Click **+** button to create new configuration
3. Fill in the form:
   - **Data ID**: `lens-platform-auth.yaml`
   - **Group**: `DEFAULT_GROUP`
   - **Configuration Format**: `YAML`
   - **Configuration Content**: (see below)
4. Click **Publish**

#### Nacos Configuration Content for lens-platform-auth.yaml

```yaml
# lens-platform-auth.yaml
# Namespace: lens_2026
# Group: DEFAULT_GROUP

server:
  port: 8041

# Keycloak Configuration
keycloak:
  url: http://localhost:8080
  realm: lens

# OpenAPI Documentation
openapi:
  service:
    title: Lens Platform Auth API
    version: "2.0"
    url: http://localhost:8041

# Spring Security OAuth2
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: http://localhost:8080/realms/lens

# Management Endpoints
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  endpoint:
    health:
      show-details: when-authorized

# Logging
logging:
  level:
    root: INFO
    com.lens: DEBUG
    org.springframework.security: DEBUG
```

#### Create Configurations for Other Services

**lens-platform-gateway.yaml**:
```yaml
server:
  port: 8050

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

**lens-platform-system.yaml**:
```yaml
server:
  port: 8042

keycloak:
  url: http://localhost:8080
  realm: lens

spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: http://localhost:8080/realms/lens

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics
```

**lens-platform-monitor.yaml**:
```yaml
server:
  port: 8043

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

### Verification Steps

After creating Nacos configuration:

1. **Restart the application**
2. **Check logs** for successful config loading:
   ```
   Located property source: NacosPropertySource{name='lens-platform-auth.yaml'}
   ```
3. **No more warnings** about empty config
4. **Application starts** successfully on port 8041

---

### Change 8: POM Naming Refactor

#### Problem
POM.xml files had inconsistent `<name>` elements - some followed directory path convention, others didn't.

#### Solution
Refactored all pom.xml files to use consistent naming: `lens_2026/{module-path}`

#### Files Updated

**Platform modules**:
- ✅ lens-platform-monitor: `lens-platform-monitor` → `lens_2026/platform/lens-platform-monitor`
- ✅ lens-platform-system: `lens_2025/platform/lens-platform-system` → `lens_2026/platform/lens-platform-system` (also fixed year)

**Common modules**:
- ✅ lens-common-base: `lens-common-base` → `lens_2026/common/lens-common-base`
- ✅ lens-common-core: `lens-common-core` → `lens_2026/common/lens-common-core`
- ✅ lens-common-web: `lens-common-web` → `lens_2026/common/lens-common-web`
- ✅ lens-common-redis: `lens-common-redis` → `lens_2026/common/lens-common-redis`
- ✅ lens-common-mariadb: `lens-common-mariadb` → `lens_2026/common/lens-common-mariadb`

**Blog modules**:
- ✅ lens-blog-persistence: `lens-blog-persistence` → `lens_2026/lens-blog/lens-blog-persistence`
- ✅ lens-blog-admin-backend: `lens-blog-admin-backend` → `lens_2026/lens-blog/lens-blog-admin-backend`
- ✅ lens-blog-search: `lens-blog-search` → `lens_2026/lens-blog/lens-blog-search`
- ✅ lens-blog-backend: `lens-blog-backend` → `lens_2026/lens-blog/lens-blog-backend`
- ✅ lens-blog-picture: `lens-blog-picture` → `lens_2026/lens-blog/lens-blog-picture`
- ✅ lens-blog-frontend: `lens-blog-frontend` → `lens_2026/lens-blog/lens-blog-frontend`

#### Naming Convention
All modules now follow the pattern:
```xml
<name>lens_2026/{parent-module}/{module-name}</name>
```

Examples:
- Root: `lens_2026`
- Parent: `lens_2026/platform`
- Module: `lens_2026/platform/lens-platform-auth`

---

## Quick Reference: Starting Services

### Prerequisites Checklist
- [ ] Nacos running on `localhost:8848`
- [ ] Keycloak running on `localhost:8080` with realm `lens`
- [ ] **All configurations created in Nacos** (namespace: `lens_2026`, group: `DEFAULT_GROUP`)

### Start Services
```bash
# Terminal 1 - Gateway
cd /home/zhenac/my/lens_2026/platform/lens-platform-gateway
mvn spring-boot:run

# Terminal 2 - Auth
cd /home/zhenac/my/lens_2026/platform/lens-platform-auth
mvn spring-boot:run

# Terminal 3 - System
cd /home/zhenac/my/lens_2026/platform/lens-platform-system
mvn spring-boot:run

# Terminal 4 - Monitor
cd /home/zhenac/my/lens_2026/platform/lens-platform-monitor
mvn spring-boot:run
```

### Success Indicators
Each service should show:
```
Located property source: NacosPropertySource{name='[service-name].yaml'}
Started [ServiceClass] in X.XXX seconds
Tomcat started on port(s): [PORT] (http)
```

### Common Issues

**Issue**: `config[dataId=xxx.yaml, group=DEFAULT_GROUP] is empty`  
**Fix**: Create the configuration in Nacos console (see "How to Create Nacos Configuration" above)

**Issue**: `Could not resolve placeholder 'xxx' in value "${xxx}"`  
**Fix**: Either add default value in `@Value("${xxx:default}")` or add property to local `application.yml`

**Issue**: Service starts on wrong port  
**Fix**: Verify `server.port` is set in Nacos configuration

**Issue**: IDEA doesn't load Nacos config
**Fix**: 
1. Ensure configuration exists in Nacos (namespace: `lens_2026`, Data ID: `lens-platform-auth.yaml`)
2. Add VM options in IDEA Run Configuration for debug logging (see `IDEA_VM_OPTIONS.txt`)
3. Verify local fallback properties exist in `application.yml`
4. See detailed guide: `/platform/lens-platform-auth/IDEA_SETUP.md`

---

## Files Created for IDEA Support

### lens-platform-auth Module
- `/platform/lens-platform-auth/IDEA_VM_OPTIONS.txt` - VM options for IDEA Run Configuration
- `/platform/lens-platform-auth/IDEA_SETUP.md` - Complete IDEA setup and troubleshooting guide

### Key Points for IDEA
1. **Nacos config must exist** before starting application in IDEA
2. **Add debug logging** via VM options to see what's happening
3. **Local fallback properties** in `application.yml` prevent startup failures
4. **Namespace must match**: Use `lens_2026` (check namespace ID in Nacos console)

---

## 2026-02-25: IDEA-Specific Nacos Config Loading Fix

### Change 9: Fixed IDEA Spring Boot Run Configuration Issue

#### Problem Identified
- ✅ **Terminal works**: `mvn spring-boot:run` loads Nacos config successfully
  ```
  [Nacos Config] Load config[dataId=lens-platform-auth.yaml, group=DEFAULT_GROUP] success
  ```
- ❌ **IDEA fails**: Shows "config is empty" warning with same application.yml

#### Root Cause
IntelliJ IDEA's Spring Boot run configuration handles `spring.config.import` differently than Maven due to:
1. Different classpath construction
2. IDEA's Spring Boot DevTools may interfere
3. Configuration property resolution order
4. Working directory differences

#### Solution: Add Program Arguments in IDEA

**Step-by-Step Fix:**

1. **Open Run Configuration**:
   - Run → Edit Configurations
   - Select `LensPlatformAuth` (or create new Spring Boot configuration)

2. **Add Program Arguments**:
   ```
   --spring.config.import=nacos:lens-platform-auth.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true
   ```

3. **Optional: Add VM Options for Debug Logging**:
   ```
   -Dlogging.level.com.alibaba.cloud.nacos.client=DEBUG
   -Dspring.devtools.restart.enabled=false
   ```

4. **Set Working Directory**:
   - Working directory: `$MODULE_DIR$`

5. **Apply and Restart**

#### Alternative: Use Maven Goal in IDEA

Create a Maven run configuration instead:
1. Run → Edit Configurations → + → Maven
2. Working directory: `/home/zhenac/my/lens_2026/platform/lens-platform-auth`
3. Command line: `spring-boot:run`
4. This runs exactly like terminal

#### Recommended IDEA Run Configuration

```
Configuration Name: LensPlatformAuth
Type: Spring Boot
Main class: com.lens.platform.auth.LensPlatformAuth
Module: lens-platform-auth
Working directory: $MODULE_DIR$

Program arguments:
--spring.config.import=nacos:lens-platform-auth.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true

VM options:
-Dlogging.level.com.alibaba.cloud.nacos.client=DEBUG
-Dspring.devtools.restart.enabled=false

Environment variables: (empty or nacos=localhost if needed)
```

#### Verification

After applying fix, IDEA logs should match terminal:
```
✅ [Nacos Config] Load config[dataId=lens-platform-auth.yaml, group=DEFAULT_GROUP] success
✅ Located property source: NacosPropertySource{name='lens-platform-auth.yaml'}
✅ Started LensPlatformAuth
```

#### Why This Works

Adding `--spring.config.import` as a program argument ensures it's processed at the highest priority level, before IDEA's internal configuration handling. This bypasses IDEA's classpath differences.

#### Apply to All Services

Use the same fix for other platform services:
- lens-platform-gateway: `--spring.config.import=nacos:lens-platform-gateway.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true`
- lens-platform-system: `--spring.config.import=nacos:lens-platform-system.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true`
- lens-platform-monitor: `--spring.config.import=nacos:lens-platform-monitor.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true`

---

**Last Updated**: 2026-02-25  
**Total Changes**: 9 major refactorings  
**Status**: ✅ All services ready, IDEA configuration issue resolved
