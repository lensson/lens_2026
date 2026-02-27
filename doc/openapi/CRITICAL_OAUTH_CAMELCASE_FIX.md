## 🔴 CRITICAL FIX: OAuth2 Property Names Must Be camelCase!

### The Problem

You reported:
1. `http://localhost:8050/swagger-ui/index.html` returns 404
2. Client ID and secret still require manual input (not pre-configured)

### Root Cause Discovered

**Springdoc requires camelCase property names in YAML!**

We were using kebab-case (Spring Boot convention):
```yaml
oauth:
  client-id: lens-client          # ❌ WRONG!
  client-secret: x6lEH0...        # ❌ WRONG!
  use-pkce-with-authorization-code-grant: true  # ❌ WRONG!
```

But Springdoc's `SwaggerUiConfigProperties.OAuth` class uses camelCase:
```yaml
oauth:
  clientId: lens-client           # ✅ CORRECT!
  clientSecret: x6lEH0...         # ✅ CORRECT!
  usePkceWithAuthorizationCodeGrant: true  # ✅ CORRECT!
```

**This is why client credentials weren't pre-configured!** The properties were being ignored.

### The Fix Applied

Changed ALL OAuth2 properties to camelCase in:

✅ **lens-platform-gateway.yaml**
✅ **lens-platform-auth.yaml**
✅ **lens-platform-system.yaml**

**Example of the fix:**
```yaml
springdoc:
  swagger-ui:
    oauth:
      clientId: lens-client                    # Changed from client-id
      clientSecret: x6lEH0DMcT27eop2cszIP3Brc2sDQHLb  # Changed from client-secret
      usePkceWithAuthorizationCodeGrant: true  # Changed from use-pkce-with-authorization-code-grant
      scopes:
        - openid
        - profile
        - email
```

### Files Updated

✅ `doc/nacos-backup/lens-platform-gateway.yaml` - OAuth2 properties → camelCase (RE-FIXED 2026-02-27)
✅ `doc/nacos-backup/lens-platform-auth.yaml` - OAuth2 properties → camelCase
✅ `doc/nacos-backup/lens-platform-system.yaml` - OAuth2 properties → camelCase
✅ All configurations uploaded to Nacos

**UPDATE 2026-02-27:** Gateway configuration required a second fix - the initial camelCase conversion didn't save correctly. Gateway config has been re-corrected and uploaded.

### 🚀 CRITICAL: Restart ALL Services

**You MUST restart all three services to reload the Nacos configuration:**

```bash
# Terminal 1: Restart Gateway
cd /home/zhenac/my/lens_2026/platform/lens-platform-gateway
# Stop if running, then:
mvn spring-boot:run

# Terminal 2: Restart Auth
cd /home/zhenac/my/lens_2026/platform/lens-platform-auth
# Stop if running, then:
mvn spring-boot:run

# Terminal 3: Restart System
cd /home/zhenac/my/lens_2026/platform/lens-platform-system
# Stop if running, then:
mvn spring-boot:run
```

**Wait ~30-60 seconds** after each service starts for:
- Nacos config to be loaded
- Service to register
- Configuration to be applied

### How to Verify the Fix

#### 1. Gateway Swagger UI

**Access URL:**
```
http://localhost:8050/swagger-ui.html
```

Click "Authorize" button and check:

**BEFORE (broken):**
```
client_id: [empty field - you have to type it]  ❌
client_secret: [empty field - you have to type it]  ❌
```

**AFTER (fixed):**
```
client_id: lens-client         ✅ Already filled!
client_secret: x6lEH0DMcT...   ✅ Already filled!
```

#### 2. Auth Service Swagger UI

**Access URL:**
```
http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html
```

Click "Authorize" and verify:
- ✅ client_id field is pre-filled with `lens-client`
- ✅ client_secret field is pre-filled with `x6lEH0DMcT27eop2cszIP3Brc2sDQHLb`

#### 3. System Service Swagger UI

**Access URL:**
```
http://localhost:8050/v2/lens/platform/system/swagger-ui/index.html
```

Same verification - both fields should be pre-filled.

### About the 404 Issue

**Gateway Swagger UI - Use the correct URL!**

❌ **WRONG:** `http://localhost:8050/swagger-ui/index.html` → **404 Error**
- This URL pattern is for backend services (MVC), not for the gateway (WebFlux)

✅ **CORRECT:** `http://localhost:8050/swagger-ui.html`
- This is the proper gateway Swagger UI URL
- Works because it redirects to `/webjars/swagger-ui/index.html`

✅ **ALTERNATIVE:** `http://localhost:8050/webjars/swagger-ui/index.html`
- Direct path to Swagger UI in WebFlux
- Also works but longer

**Why the difference?**
- **Gateway (WebFlux):** Different static resource structure
- **Backend services (MVC):** Different path conventions

**Backend services via gateway (these use /index.html):**
- ✅ `http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html`
- ✅ `http://localhost:8050/v2/lens/platform/system/swagger-ui/index.html`

**Remember:** 
- Gateway: `/swagger-ui.html` (no /index.html)
- Backend services: `/swagger-ui/index.html` (with /index.html)

### Summary of Changes

| Property | Before | After | Status |
|----------|--------|-------|--------|
| client-id | ❌ kebab-case | clientId ✅ camelCase | Fixed |
| client-secret | ❌ kebab-case | clientSecret ✅ camelCase | Fixed |
| use-pkce-with-authorization-code-grant | ❌ kebab-case | usePkceWithAuthorizationCodeGrant ✅ camelCase | Fixed |

### Why This Matters

Springdoc's `SwaggerUiConfigProperties` class:
```java
public static class OAuth {
    private String clientId;      // ← camelCase in Java
    private String clientSecret;  // ← camelCase in Java
    private Boolean usePkceWithAuthorizationCodeGrant; // ← camelCase in Java
}
```

YAML property binding in Spring:
- `client-id` → doesn't match `clientId` → **ignored!** ❌
- `clientId` → matches `clientId` → **works!** ✅

### Expected Result After Restart

**All Swagger UIs will show:**
1. ✅ Client ID pre-filled
2. ✅ Client Secret pre-filled
3. ✅ Just click "Authorize" → login → done!
4. ✅ No manual typing of credentials needed

---

**Status:** ✅ Fixed - camelCase properties in all configs  
**Uploaded:** ✅ All configurations uploaded to Nacos  
**Critical Action:** ⚠️ **RESTART ALL 3 SERVICES NOW!**  
**Expected Result:** Client credentials pre-filled in Swagger UI

**Last Updated:** 2026-02-27
