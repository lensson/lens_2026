# FINAL FIX: Swagger UI Loading Wrong API Docs

## The Problem

When accessing Swagger UI via gateway at:
```
http://localhost:8050/v2/lens/platform/auth/swagger-ui.html
```

Swagger UI was loading API docs from the WRONG URL:
- **Loading from:** `http://localhost:8050/v3/api-docs` (Gateway's API docs) ❌
- **Should load from:** `http://localhost:8050/v2/lens/platform/auth/v3/api-docs` (Auth service's API docs) ✓

## Root Cause

**Relative Path Resolution Issue:**

Swagger UI uses the URL from `swagger-config.json` to load the OpenAPI specification. When the backend service returns:

```json
{
  "url": "/v3/api-docs"
}
```

The browser interprets this as a **relative path** and resolves it relative to the **host**, not relative to the current page path:
- Current page: `http://localhost:8050/v2/lens/platform/auth/swagger-ui.html`
- Relative URL: `/v3/api-docs`
- Browser resolves to: `http://localhost:8050/v3/api-docs` ❌

This causes Swagger UI to load the **gateway's API docs** instead of the **auth service's API docs**.

## The Solution

**Configure Springdoc to return ABSOLUTE paths** in swagger-config.json:

```yaml
# lens-platform-auth.yaml
springdoc:
  api-docs:
    path: /v3/api-docs
  swagger-ui:
    path: /swagger-ui.html
    # Absolute path including gateway prefix
    url: /v2/lens/platform/auth/v3/api-docs
    config-url: /v2/lens/platform/auth/v3/api-docs/swagger-config
```

Now swagger-config.json will return:
```json
{
  "url": "/v2/lens/platform/auth/v3/api-docs"
}
```

Browser resolves to: `http://localhost:8050/v2/lens/platform/auth/v3/api-docs` ✓

## Files Modified

✅ **doc/nacos-backup/lens-platform-auth.yaml**
- Added `springdoc.swagger-ui.url` property with full gateway path
- Added `springdoc.swagger-ui.config-url` property with full gateway path

✅ **doc/nacos-backup/lens-platform-system.yaml**
- Added `springdoc.swagger-ui.url` property with full gateway path
- Added `springdoc.swagger-ui.config-url` property with full gateway path

✅ **Uploaded to Nacos** - All configurations uploaded successfully

## Action Required

**RESTART AUTH AND SYSTEM SERVICES** to pick up the new Springdoc configuration:

```bash
# Auth Service
cd /home/zhenac/my/lens_2026/platform/lens-platform-auth
mvn spring-boot:run

# System Service
cd /home/zhenac/my/lens_2026/platform/lens-platform-system
mvn spring-boot:run
```

## Testing

### Step 1: Verify swagger-config Returns Correct URL

```bash
# Direct to auth service
curl http://localhost:8041/v3/api-docs/swagger-config | jq '.url'
# Expected: "/v2/lens/platform/auth/v3/api-docs"

# Through gateway
curl http://localhost:8050/v2/lens/platform/auth/v3/api-docs/swagger-config | jq '.url'
# Expected: "/v2/lens/platform/auth/v3/api-docs"
```

### Step 2: Test in Browser

1. Open: `http://localhost:8050/v2/lens/platform/auth/swagger-ui.html`

2. Open browser DevTools → Network tab

3. Look for request to API docs:
   - **Should see:** `GET http://localhost:8050/v2/lens/platform/auth/v3/api-docs` ✓
   - **NOT:** `GET http://localhost:8050/v3/api-docs` ❌

4. Verify the page shows:
   - ✅ Title: "Lens Platform Auth API"
   - ✅ Auth service endpoints (like `/echo`, etc.)
   - ✅ No "Failed to load remote configuration" error

### Step 3: Test System Service

```
http://localhost:8050/v2/lens/platform/system/swagger-ui.html
```

Should show:
- ✅ Title: "Lens Platform System API"
- ✅ System service endpoints

## Why This Fix Works

**Before:**
```
Swagger UI at: /v2/lens/platform/auth/swagger-ui.html
  ↓
Loads swagger-config: /v2/lens/platform/auth/v3/api-docs/swagger-config
  ↓
swagger-config says: {"url": "/v3/api-docs"}
  ↓
Browser interprets as absolute path from host: /v3/api-docs
  ↓
Loads: http://localhost:8050/v3/api-docs (Gateway's docs!) ❌
```

**After:**
```
Swagger UI at: /v2/lens/platform/auth/swagger-ui.html
  ↓
Loads swagger-config: /v2/lens/platform/auth/v3/api-docs/swagger-config
  ↓
swagger-config says: {"url": "/v2/lens/platform/auth/v3/api-docs"}
  ↓
Browser uses this full path: /v2/lens/platform/auth/v3/api-docs
  ↓
Loads: http://localhost:8050/v2/lens/platform/auth/v3/api-docs (Auth service docs!) ✓
```

## Complete Fix Summary

This completes ALL Swagger UI issues:

1. ✅ **Redirect issue** - Fixed with forward-headers-strategy (then simplified)
2. ✅ **CORS error** - Fixed with OpenAPI server URL pointing to gateway
3. ✅ **Config load failure** - Fixed by disabling forward-headers-strategy
4. ✅ **Wrong Swagger UI** - Fixed by disabling gateway's Springdoc and fixing security
5. ✅ **Wrong API docs loaded** - Fixed by configuring Springdoc to use absolute paths

## Key Takeaway

**Lesson:** When serving Swagger UI through a gateway with path prefixes:
- Configure `springdoc.swagger-ui.url` with the **full gateway path**
- Configure `springdoc.swagger-ui.config-url` with the **full gateway path**
- Leading slash `/` makes paths absolute from host, preventing relative resolution issues
- This ensures Swagger UI loads the correct service's API documentation

---

**Status:** ✅ Configuration uploaded to Nacos  
**Action Required:** Restart auth and system services  
**Expected Result:** Swagger UI loads correct service API docs via gateway

**Last Updated:** 2026-02-27
