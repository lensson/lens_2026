# CORS Fix - Quick Reference

## Problem

When testing endpoints from Swagger UI at `http://localhost:8050/v2/lens/platform/auth/swagger-ui.html`:
- Swagger UI loads ✓
- Clicking "Execute" on endpoints fails with CORS error ❌
- Error: "Failed to fetch. Possible Reasons: CORS"

## Root Cause

Backend services were configured with direct backend URL (`http://localhost:8041`) as the OpenAPI server URL. When Swagger UI tries to call APIs, it uses this URL directly, causing a cross-origin request:
- Swagger UI origin: `http://localhost:8050`
- API call target: `http://localhost:8041`
- Result: Browser blocks (CORS error)

## Solution Applied

✅ Changed OpenAPI server URL to use gateway URL:
- **Before:** `http://localhost:8041`
- **After:** `http://localhost:8050/v2/lens/platform/auth`

## Files Modified

1. **Nacos Configurations (Already Uploaded)**
   - `lens-platform-auth.yaml`: Changed `openapi.service.url`
   - `lens-platform-system.yaml`: Changed `openapi.service.url`

2. **Environment Variables**
   - `conf/env/lens_2026.env`: Updated `AUTH_URL` and `SYSTEM_URL`

## Next Steps - YOU NEED TO RESTART SERVICES

**Restart Auth Service:**
```bash
# Stop current auth service in IDEA
# Then restart it

# OR via terminal:
cd /home/zhenac/my/lens_2026/platform/lens-platform-auth
mvn spring-boot:run
```

**Restart System Service:**
```bash
# Stop current system service in IDEA
# Then restart it

# OR via terminal:
cd /home/zhenac/my/lens_2026/platform/lens-platform-system
mvn spring-boot:run
```

## How to Test

1. Wait for services to restart and register with Nacos (30 seconds)

2. Open Swagger UI:
   ```
   http://localhost:8050/v2/lens/platform/auth/swagger-ui.html
   ```

3. Click on `GET /echo` endpoint

4. Click "Try it out"

5. Click "Execute"

6. **Expected Result:** Response from server (200 OK)
   ```json
   {
     "message": "Echo from auth service",
     "timestamp": "..."
   }
   ```

## Verification

Check that the OpenAPI spec uses gateway URL:

```bash
curl http://localhost:8050/v2/lens/platform/auth/v3/api-docs | jq '.servers'
```

Expected output:
```json
[
  {
    "url": "http://localhost:8050/v2/lens/platform/auth"
  }
]
```

If you see `http://localhost:8041`, the service hasn't picked up the new config yet.

## Why This Works

**Before (CORS Error):**
```
Browser loads:     http://localhost:8050/v2/.../swagger-ui.html
Swagger UI calls:  http://localhost:8041/echo          ← Different origin!
Browser blocks:    CORS error ❌
```

**After (No CORS):**
```
Browser loads:     http://localhost:8050/v2/.../swagger-ui.html
Swagger UI calls:  http://localhost:8050/v2/.../echo  ← Same origin!
Gateway routes:    → http://localhost:8041/echo
Returns response:  Success! ✓
```

## Quick Checklist

- [ ] Configuration uploaded to Nacos (✓ Already done)
- [ ] Auth service restarted
- [ ] System service restarted
- [ ] Services registered with Nacos
- [ ] Swagger UI loads without redirect issues
- [ ] API calls work without CORS errors
- [ ] Can test endpoints successfully

## If Still Getting CORS Error

1. **Check service logs** - Look for:
   ```
   [Nacos Config] Load config[dataId=lens-platform-auth.yaml, group=DEFAULT_GROUP] success
   ```

2. **Verify OpenAPI spec server URL**:
   ```bash
   curl http://localhost:8050/v2/lens/platform/auth/v3/api-docs | jq '.servers[0].url'
   ```
   Should output: `"http://localhost:8050/v2/lens/platform/auth"`

3. **Clear browser cache** - Sometimes browser caches old OpenAPI spec

4. **Check Network tab in browser DevTools**:
   - Click Execute on an endpoint
   - Look at the request URL
   - Should be: `http://localhost:8050/v2/lens/platform/auth/...`
   - NOT: `http://localhost:8041/...`

## If Getting "Failed to load remote configuration"

**Symptoms:**
- Swagger UI page loads
- Shows error: "Failed to load remote configuration"
- Swagger UI doesn't display API endpoints

**Root Cause:**
Springdoc was reading `X-Forwarded-Prefix` header and doubling the paths in swagger-config.json, resulting in URLs like:
- `/v2/lens/platform/auth/v2/lens/platform/auth/v3/api-docs` ❌ (doubled path)

**Solution Applied:**
Removed `X-Forwarded-Prefix` header from Swagger UI routes in gateway configuration:

```yaml
# Gateway routes - X-Forwarded-Prefix only on API routes, not Swagger routes
routes:
  # Swagger routes - NO X-Forwarded-Prefix
  - id: lens-platform-auth-swagger
    predicates:
      - Path=/v2/lens/platform/auth/swagger-ui/**
    filters:
      - StripPrefix=4
      - PreserveHostHeader

  # API routes - WITH X-Forwarded-Prefix  
  - id: lens-platform-auth
    predicates:
      - Path=/v2/lens/platform/auth/**
    filters:
      - StripPrefix=4
      - AddRequestHeader=X-Forwarded-Prefix, /v2/lens/platform/auth
```

**Verification:**
```bash
# Check swagger-config paths (should NOT be doubled)
curl http://localhost:8050/v2/lens/platform/auth/v3/api-docs/swagger-config | jq '.url'

# Expected: "/v3/api-docs" or "/v2/lens/platform/auth/v3/api-docs"
# NOT: "/v2/lens/platform/auth/v2/lens/platform/auth/v3/api-docs"
```

**Status:** ✅ Fixed - Configuration uploaded to Nacos  
**Action Required:** Restart gateway, auth, and system services

## If Gateway Shows Its Own Swagger UI

**Symptoms:**
- Accessing `http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html`
- Shows gateway's Swagger UI instead of auth service's Swagger UI
- Gateway's API endpoints displayed instead of auth service endpoints

**Root Cause:**
1. Gateway has Springdoc dependency (`springdoc-openapi-starter-webflux-ui`)
2. Gateway's security configuration had pattern `/swagger-ui/**` that matched ALL swagger-ui paths
3. This pattern caught `/v2/lens/platform/auth/swagger-ui/**` before the backend service route

**Solution Applied:**

**1. Disabled Springdoc in Gateway (Nacos config):**
```yaml
# lens-platform-gateway.yaml
spring:
  springdoc:
    swagger-ui:
      enabled: false
    api-docs:
      enabled: false
```

**2. Fixed Security Configuration (Java code):**
```java
// SecurityConfig.java - Removed gateway's own swagger-ui pattern
.authorizeExchange(auth -> auth
    // Proxied swagger UI (specific pattern first)
    .pathMatchers("/v2/lens/platform/*/swagger-ui.html", 
                  "/v2/lens/platform/*/swagger-ui/**", 
                  "/v2/lens/platform/*/v3/api-docs/**").permitAll()
    // Gateway endpoints (no /swagger-ui/**)
    .pathMatchers("/actuator/**", "/v3/api-docs/**").permitAll()
    // ...
)
```

**Why This Works:**
- Gateway no longer serves its own Swagger UI
- Security patterns are ordered: specific paths before general paths
- Backend service routes can properly handle swagger-ui requests

**Files Modified:**
- ✅ `platform/lens-platform-gateway/src/main/java/.../SecurityConfig.java` (removed `/swagger-ui/**`)
- ✅ `doc/nacos-backup/lens-platform-gateway.yaml` (disabled springdoc)

**Action Required:**
```bash
# 1. Restart Gateway (code change)
cd /home/zhenac/my/lens_2026/platform/lens-platform-gateway
mvn spring-boot:run

# 2. Wait for gateway to start and register with Nacos (30 seconds)

# 3. Test - should show auth service Swagger UI, not gateway
http://localhost:8050/v2/lens/platform/auth/swagger-ui.html
```

---

**Status:** ✅ All fixes implemented and uploaded to Nacos  
**Action Required:** Restart gateway (code change), auth, and system services (config changes)

## Documentation

Full documentation available at:
- `doc/openapi/README.md` - Complete OpenAPI guide
- `doc/openapi/SWAGGER_REDIRECT_FIX.md` - Detailed fixes guide
- `doc/HISTORY.md` - Complete history with all fixes

---

**Status:** ✅ Fix implemented and uploaded to Nacos  
**Action Required:** Restart auth and system services  
**Last Updated:** 2026-02-27
