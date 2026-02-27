# Swagger UI Fixes - Complete Guide

## Quick Summary

**Problems Fixed:**
1. ✅ **Redirect Issue:** Accessing `http://localhost:8050/v2/lens/platform/auth/swagger-ui.html` redirected to wrong URL (404 error)
2. ✅ **CORS Error:** Testing endpoints from Swagger UI caused CORS errors

**Solutions:**
1. Implemented forward headers strategy to preserve gateway path prefix in redirects
2. Configured OpenAPI server URL to use gateway URL instead of backend URL

**Status:** ✅ Both fixes applied - Configuration uploaded to Nacos, services need restart

## What Changed

### 1. Backend Services Configuration

Added to `lens-platform-auth.yaml` and `lens-platform-system.yaml`:

```yaml
server:
  forward-headers-strategy: framework
  tomcat:
    redirect-context-root: false
    use-relative-redirects: true

# OpenAPI Configuration - IMPORTANT: Use gateway URL to avoid CORS
openapi:
  service:
    title: Lens Platform Auth API
    version: ${OPENAPI_VERSION:2.0.0}
    # Use gateway URL, not backend direct URL
    url: ${AUTH_URL:http://localhost:8050/v2/lens/platform/auth}

springdoc:
  api-docs:
    path: /v3/api-docs
  swagger-ui:
    path: /swagger-ui.html
    use-root-path: false
  use-management-port: false
  show-actuator: true
```

### 2. Gateway Configuration

Updated all routes in `lens-platform-gateway.yaml` to add `X-Forwarded-Prefix` header:

```yaml
routes:
  - id: lens-platform-auth-swagger
    uri: lb://lens-platform-auth
    predicates:
      - Path=/v2/lens/platform/auth/swagger-ui.html, /v2/lens/platform/auth/swagger-ui/**, /v2/lens/platform/auth/v3/api-docs/**
    filters:
      - StripPrefix=4
      - AddRequestHeader=X-Forwarded-Prefix, /v2/lens/platform/auth
      - PreserveHostHeader
```

### 3. Environment Variables

Updated `conf/env/lens_2026.env`:

```bash
# Use gateway URLs for OpenAPI server configuration
export AUTH_URL=http://localhost:8050/v2/lens/platform/auth
export SYSTEM_URL=http://localhost:8050/v2/lens/platform/system
```

## How to Apply the Fix

### Step 1: Verify Nacos Configuration

The configuration has already been uploaded to Nacos. Verify in Nacos UI:

1. Open: http://localhost:8848/nacos
2. Login: nacos/nacos
3. Navigate to: Configuration Management → Configurations
4. Check namespace: `lens_2026`, group: `DEFAULT_GROUP`
5. Verify these configurations exist:
   - `lens-platform-gateway.yaml`
   - `lens-platform-auth.yaml`
   - `lens-platform-system.yaml`

### Step 2: Restart Services

**Option A: Restart via IDE**

1. Stop all running platform services in IDEA
2. Start gateway: Right-click `LensPlatformGateway` → Run
3. Start auth: Right-click `LensPlatformAuth` → Run
4. Start system: Right-click `LensPlatformSystem` → Run
5. Wait for all services to register with Nacos (check Nacos service list)

**Option B: Restart via Terminal**

```bash
# Stop any running services first
# Then start each service:

# Terminal 1: Gateway
cd /home/zhenac/my/lens_2026/platform/lens-platform-gateway
mvn spring-boot:run

# Terminal 2: Auth Service
cd /home/zhenac/my/lens_2026/platform/lens-platform-auth
mvn spring-boot:run

# Terminal 3: System Service
cd /home/zhenac/my/lens_2026/platform/lens-platform-system
mvn spring-boot:run
```

### Step 3: Test the Fix

Run the test script:

```bash
bash /tmp/test_forward_headers.sh
```

Expected output:
```
======================================
Testing Swagger UI Access via Gateway
======================================

Test 1: Checking redirect for auth service swagger-ui.html
URL: http://localhost:8050/v2/lens/platform/auth/swagger-ui.html
Redirect Location: /v2/lens/platform/auth/swagger-ui/index.html
✅ PASS: Redirect includes gateway prefix

Test 2: Checking swagger-ui static resources
URL: http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html
HTTP Status: 200
✅ PASS: Swagger UI resources accessible

Test 3: Checking redirect for system service swagger-ui.html
URL: http://localhost:8050/v2/lens/platform/system/swagger-ui.html
Redirect Location: /v2/lens/platform/system/swagger-ui/index.html
✅ PASS: System service redirect includes gateway prefix
```

### Step 4: Browser Test

Open in your browser:

**Auth Service:**
```
http://localhost:8050/v2/lens/platform/auth/swagger-ui.html
```

**System Service:**
```
http://localhost:8050/v2/lens/platform/system/swagger-ui.html
```

Both should:
- Load without 404 errors
- Display full Swagger UI with styling
- Show API documentation
- Allow testing endpoints (with OAuth2 token)

## Troubleshooting

### Issue: Still getting 404 after restart

**Check 1: Services registered with Nacos**
```bash
curl http://localhost:8848/nacos/v1/ns/instance/list?serviceName=lens-platform-auth
curl http://localhost:8848/nacos/v1/ns/instance/list?serviceName=lens-platform-gateway
```

**Check 2: Configuration loaded from Nacos**

Look for this log in service startup:
```
[Nacos Config] Load config[dataId=lens-platform-auth.yaml, group=DEFAULT_GROUP] success
```

**Check 3: Forward headers configured**

Test direct service access:
```bash
# Should return 302 with Location header
curl -I http://localhost:8041/swagger-ui.html

# If X-Forwarded-Prefix is set, redirect should include it
curl -I -H "X-Forwarded-Prefix: /v2/lens/platform/auth" http://localhost:8041/swagger-ui.html
```

### Issue: Gateway returns 503 Service Unavailable

**Cause:** Backend service not registered with Nacos

**Solution:**
1. Check Nacos service list: http://localhost:8848/nacos/#/serviceManagement
2. Ensure services show as healthy
3. Wait 30 seconds for registration to complete
4. Check service logs for errors

### Issue: CSS/JS not loading

**Check:** Gateway routes include `/swagger-ui/**` pattern

```bash
# Should return 200
curl -I http://localhost:8050/v2/lens/platform/auth/swagger-ui/swagger-ui.css
```

If returns 404, check gateway logs for routing errors.

### Issue: CORS Error When Testing Endpoints

**Symptoms:**
- Swagger UI loads correctly
- When clicking "Execute" on an endpoint, get error:
  ```
  Failed to fetch.
  Possible Reasons: CORS
  ```
- Browser console shows CORS error

**Cause:** OpenAPI server URL is set to backend direct URL instead of gateway URL

**Check:**
```bash
# Check OpenAPI spec server URL
curl http://localhost:8050/v2/lens/platform/auth/v3/api-docs | jq '.servers'

# Should return:
# [{"url": "http://localhost:8050/v2/lens/platform/auth"}]

# NOT:
# [{"url": "http://localhost:8041"}]
```

**Solution:**
1. Verify `AUTH_URL` environment variable is set to gateway URL:
   ```bash
   echo $AUTH_URL
   # Should be: http://localhost:8050/v2/lens/platform/auth
   ```

2. Check Nacos configuration for `openapi.service.url`:
   - Open: http://localhost:8848/nacos
   - Find: `lens-platform-auth.yaml`
   - Verify: `url: ${AUTH_URL:http://localhost:8050/v2/lens/platform/auth}`

3. Restart auth service to pick up new configuration

**Why This Happens:**
- Swagger UI is loaded from: `http://localhost:8050/...`
- If server URL is `http://localhost:8041`, API calls go directly to backend
- Browser sees different ports (8050 vs 8041) = different origins
- Browser blocks cross-origin requests without CORS headers = CORS error

**Solution:**
- Set server URL to gateway URL with path
- All API calls go through gateway (same origin as Swagger UI)
- No CORS issues!

## Technical Details

### Why Forward Headers?

When a backend service sits behind a reverse proxy/gateway:
- The service receives proxied requests, not the original
- The service doesn't know the original URL path
- Redirects and links are generated based on proxied path
- Result: Broken redirects when path prefix is stripped

Forward headers solve this by:
- Gateway adds `X-Forwarded-*` headers with original request info
- Backend reads these headers
- Backend reconstructs original URL
- Backend generates correct redirects/links

### Standard Headers

- `X-Forwarded-Proto`: Original protocol (http/https)
- `X-Forwarded-Host`: Original host
- `X-Forwarded-Port`: Original port
- `X-Forwarded-Prefix`: Path prefix stripped by gateway
- `X-Forwarded-For`: Client IP addresses

### Spring Boot Support

Spring Boot's `ForwardedHeaderFilter` (enabled by `forward-headers-strategy: framework`) automatically:
- Reads all `X-Forwarded-*` headers
- Updates request URL information
- Makes `HttpServletRequest.getRequestURL()` return original URL
- Ensures redirects include forwarded prefix

## References

- Spring Boot Forward Headers: https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto.webserver.use-behind-a-proxy-server
- Spring Cloud Gateway Filters: https://docs.spring.io/spring-cloud-gateway/reference/spring-cloud-gateway/gatewayfilter-factories.html
- Springdoc OpenAPI: https://springdoc.org/
- RFC 7239 (Forwarded HTTP Extension): https://www.rfc-editor.org/rfc/rfc7239

## Verification Checklist

- [ ] Configuration uploaded to Nacos
- [ ] Gateway service restarted
- [ ] Auth service restarted
- [ ] System service restarted
- [ ] All services registered with Nacos
- [ ] Test script passes all checks
- [ ] Browser can access Swagger UI via gateway
- [ ] CSS and JavaScript load correctly
- [ ] API documentation displays properly
- [ ] Can test endpoints with OAuth2 token

## Next Steps

After verifying the fix works:

1. **Document in README**: Update main README.md with correct Swagger UI URLs
2. **Update CI/CD**: Ensure deployment scripts restart services after Nacos config changes
3. **Monitor Service**: Add monitoring for 404 errors on swagger-ui paths
4. **Consider Monitor Service**: Apply same fix to lens-platform-monitor if it has Swagger UI

---

**Last Updated:** 2026-02-27  
**Status:** Ready for testing
