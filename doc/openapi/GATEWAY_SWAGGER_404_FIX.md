# Swagger UI with OAuth2 Authorization

## Overview

All Swagger UI pages are now accessible, including the gateway's own. Users can test **authenticated** APIs by clicking the "Authorize" button in Swagger UI to login via Keycloak OAuth2.

## Available Swagger UI Endpoints

✅ **Gateway's own Swagger UI:**
```
http://localhost:8050/swagger-ui.html
```

✅ **Auth Service via Gateway:**
```
http://localhost:8050/v2/lens/platform/auth/swagger-ui.html
```

✅ **System Service via Gateway:**
```
http://localhost:8050/v2/lens/platform/system/swagger-ui.html
```

## How to Use OAuth2 Authorization in Swagger UI

### Step 1: Open Swagger UI

Navigate to any Swagger UI page, for example:
```
http://localhost:8050/v2/lens/platform/auth/swagger-ui.html
```

### Step 2: Click "Authorize" Button

1. Look for the **"Authorize"** button at the top right of the Swagger UI page
2. Click it to open the authorization dialog

### Step 3: Configure OAuth2

In the authorization dialog:
1. You'll see **"keycloak_oAuth_security_schema"** section
2. Select the scopes you need:
   - ✅ `openid`
   - ✅ `profile`  
   - ✅ `email`
   - ✅ `VIEW` (read data)
   - ✅ `ADMIN` (modify data)
3. Click **"Authorize"**

### Step 4: Login via Keycloak

1. You'll be redirected to Keycloak login page
2. Login with your credentials:
   - **Username:** `lens` (or your Keycloak user)
   - **Password:** (your password)
3. After successful login, you'll be redirected back to Swagger UI
4. The dialog will show: **"Authorized"** with a ✅

### Step 5: Test APIs

Now you can test any endpoint:
1. Find an endpoint (e.g., `GET /echo`)
2. Click **"Try it out"**
3. Click **"Execute"**
4. The request will include your JWT token automatically
5. You'll get a successful response (no CORS or auth errors!)

## OAuth2 Configuration

### Backend Services (Auth, System)

```yaml
# In lens-platform-auth.yaml & lens-platform-system.yaml
springdoc:
  swagger-ui:
    oauth2-redirect-url: http://localhost:8050/v2/lens/platform/auth/swagger-ui/oauth2-redirect.html
    oauth:
      client-id: lens-client
      client-secret: x6lEH0DMcT27eop2cszIP3Brc2sDQHLb
      use-pkce-with-authorization-code-grant: false
```

### Gateway

```yaml
# In lens-platform-gateway.yaml
springdoc:
  swagger-ui:
    enabled: true
    oauth2-redirect-url: http://localhost:8050/swagger-ui/oauth2-redirect.html
    oauth:
      client-id: lens-client
      client-secret: x6lEH0DMcT27eop2cszIP3Brc2sDQHLb
      use-pkce-with-authorization-code-grant: true
```

## Security Configuration

### Public Endpoints (No Auth Required)

- `/v3/api-docs/**` - OpenAPI specification
- `/swagger-ui/**` - Swagger UI static resources
- `/swagger-ui.html` - Swagger UI landing page
- `/actuator/**` - Health checks and metrics
- `/login/**`, `/oauth2/**` - OAuth2 authentication endpoints

### Protected Endpoints (JWT Required)

- **All API endpoints** (like `/echo`, `/api/users`, etc.)
- Must authenticate via Swagger UI "Authorize" button
- JWT token automatically included in requests

## Files Modified

### Nacos Configurations (Uploaded)

✅ **lens-platform-gateway.yaml**
- Re-enabled Springdoc Swagger UI
- Added OAuth2 configuration

✅ **lens-platform-auth.yaml**
- Added OAuth2 configuration to springdoc
- Removed `/echo` from public endpoints

✅ **lens-platform-system.yaml**
- Added OAuth2 configuration to springdoc

### Java Code

✅ **platform/lens-platform-gateway/.../SecurityConfig.java**
- Re-enabled gateway's own Swagger UI in security config

✅ **platform/lens-platform-auth/.../SecurityConfig.java**
- Removed `/echo` from permitAll (requires auth now)

## Action Required

**RESTART ALL SERVICES** to apply the changes:

```bash
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

## Testing

### Test 1: Gateway Swagger UI

```
http://localhost:8050/swagger-ui.html
```

**Expected:** Gateway's Swagger UI loads, showing gateway's own API endpoints

### Test 2: Auth Service Swagger UI

```
http://localhost:8050/v2/lens/platform/auth/swagger-ui.html
```

**Expected:** Auth service Swagger UI loads

### Test 3: Authorize and Test Echo Endpoint

1. Open: `http://localhost:8050/v2/lens/platform/auth/swagger-ui.html`
2. Click **"Authorize"** button
3. Select all scopes, click **"Authorize"**
4. Login via Keycloak (username: `lens`)
5. After redirect, click **"Close"** in authorization dialog
6. Find `GET /echo` endpoint
7. Click **"Try it out"** → **"Execute"**
8. **Expected:** 
   - ✅ Response: `lens-platform-auth run on 8041`
   - ✅ HTTP 200 OK
   - ✅ No CORS errors
   - ✅ Request includes `Authorization: Bearer <token>` header

### Test 4: Verify JWT Token

After authorizing in Swagger UI:
1. Open browser DevTools → Network tab
2. Execute any endpoint
3. Look at the request headers
4. You should see:
   ```
   Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

## Troubleshooting

### Issue: "Authorize" button does nothing

**Solution:** Check that Keycloak is running:
```bash
curl http://localhost:28080
```

### Issue: After login, redirects to wrong URL

**Check:** OAuth2 redirect URL in configuration matches the Swagger UI path

**Auth service:** `http://localhost:8050/v2/lens/platform/auth/swagger-ui/oauth2-redirect.html`
**Gateway:** `http://localhost:8050/swagger-ui/oauth2-redirect.html`

### Issue: "Failed to fetch" after authorization

**Possible causes:**
1. Backend service not running
2. JWT token invalid or expired
3. Service not registered with Nacos

**Solution:** Restart services and try again

## Benefits of OAuth2 Approach

✅ **Secure:** All endpoints require proper authentication
✅ **Realistic:** Mirrors production authentication flow  
✅ **Convenient:** One-click authorization in Swagger UI
✅ **Flexible:** Can test all endpoints, not just public ones
✅ **Standard:** Uses industry-standard OAuth2/OIDC
✅ **Complete:** Gateway's own Swagger UI is also available

## Production Recommendations

1. **Disable Swagger UI in production** - set `springdoc.swagger-ui.enabled: false`
2. **Use API documentation portal** - separate from runtime services
3. **Rotate client secrets** - don't expose in configuration
4. **Use HTTPS** - all OAuth2 URLs should use HTTPS in production
5. **Limit scopes** - only grant necessary permissions

---

**Status:** ✅ Configured - OAuth2 authorization enabled  
**Action Required:** Restart all services (gateway, auth, system)  
**Expected Result:** All Swagger UIs accessible with "Authorize" button for testing

**Last Updated:** 2026-02-27
