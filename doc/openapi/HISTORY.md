# OpenAPI/Swagger UI Configuration History

## 2026-02-27: Complete Gateway OAuth2 and Swagger UI Configuration

### Summary

Completed full OAuth2 Authorization Code flow configuration with pre-configured client credentials for all platform services (Gateway, Auth, System). Fixed multiple issues related to Swagger UI access, OAuth2 authentication, CORS, and URL routing.

---

## Major Fixes and Features

### 1. OAuth2 Pre-configured Client Credentials ✅

**Issue:** Users had to manually enter clientId and clientSecret in Swagger UI "Authorize" dialog.

**Root Cause:** Springdoc requires **camelCase** property names in YAML configuration, but we were using kebab-case (Spring Boot convention).

**Solution:**
Changed all OAuth2 properties from kebab-case to camelCase in Nacos configurations:

```yaml
# WRONG (kebab-case - ignored by Springdoc)
oauth:
  client-id: lens-client
  client-secret: x6lEH0DMcT27eop2cszIP3Brc2sDQHLb
  use-pkce-with-authorization-code-grant: true

# CORRECT (camelCase - recognized by Springdoc)
oauth:
  clientId: lens-client
  clientSecret: x6lEH0DMcT27eop2cszIP3Brc2sDQHLb
  usePkceWithAuthorizationCodeGrant: true
```

**Files Updated:**
- `doc/nacos-backup/lens-platform-gateway.yaml`
- `doc/nacos-backup/lens-platform-auth.yaml`
- `doc/nacos-backup/lens-platform-system.yaml`

**Result:** All Swagger UIs now show pre-filled clientId and clientSecret. Users just click "Authorize" → login → done!

---

### 2. Gateway Swagger UI URLs Clarified ✅

**Issue:** `http://localhost:8050/swagger-ui/index.html` returns 404 for gateway.

**Root Cause:** Gateway (Spring WebFlux) uses different URL structure than backend services (Spring MVC).

**Solution:** Documentation updated to reflect correct URLs:

**Gateway (WebFlux):**
- ✅ `http://localhost:8050/swagger-ui.html`
- ✅ `http://localhost:8050/webjars/swagger-ui/index.html`
- ❌ `http://localhost:8050/swagger-ui/index.html` (doesn't exist)

**Backend Services (MVC via Gateway):**
- ✅ `http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html`
- ✅ `http://localhost:8050/v2/lens/platform/system/swagger-ui/index.html`

**Files Updated:**
- `doc/openapi/CORRECT_URLS.md`
- `doc/openapi/README.md`

---

### 3. Gateway /token Endpoint Fixed ✅

**Issue:** `/token` endpoint raised 500 error when invoked.

**Root Cause:** Controller used `@RegisteredOAuth2AuthorizedClient` which requires OAuth2 **client** configuration (for logging in users). Gateway is configured as OAuth2 **resource server** (validates JWT tokens), not as a client.

**Solution:** Updated controller to use `@AuthenticationPrincipal Jwt` instead:

```java
// OLD (causing 500 errors)
@GetMapping("/token")
public Mono<String> getHome(@RegisteredOAuth2AuthorizedClient OAuth2AuthorizedClient authorizedClient) {
    return Mono.just(authorizedClient.getAccessToken().getTokenValue());
}

// NEW (works with resource server)
@GetMapping("/token")
public Mono<TokenInfo> getTokenInfo(@AuthenticationPrincipal Jwt jwt) {
    return Mono.just(new TokenInfo(true, jwt.getTokenValue(), ...));
}
```

**Files Updated:**
- `platform/lens-platform-gateway/src/main/java/.../GateController.java`

**New Endpoints:**
- `/token` - Get JWT token information with claims and expiration
- `/token/raw` - Get raw JWT token string
- `/health` - Health check endpoint

**Usage:**
```bash
curl -H "Authorization: Bearer <JWT_TOKEN>" http://localhost:8050/token
```

---

### 4. OpenAPI Configuration Standardized ✅

**Issue:** Gateway OpenAPIConfig used old annotation-based approach with wrong scopes (VIEW, ADMIN).

**Solution:** Rewrote gateway OpenAPIConfig to match auth/system services:

**Changes:**
- Removed `@SecurityScheme` annotation approach
- Added programmatic OAuth2 configuration
- Changed to Authorization Code flow (not implicit)
- Added token URL for proper OAuth2 token exchange
- Fixed scopes: `openid`, `profile`, `email` (not VIEW, ADMIN)
- Removed bearer_auth option (OAuth2 only)

**Files Updated:**
- `platform/lens-platform-gateway/src/main/java/.../OpenAPIConfig.java`
- `platform/lens-platform-auth/src/main/java/.../OpenAPIConfig.java`
- `platform/lens-platform-system/src/main/java/.../OpenAPIConfig.java`

**Result:** All services now have identical OAuth2 configuration with Authorization Code flow + PKCE.

---

### 5. Security Configuration Refined ✅

**Issue:** Gateway was redirecting to Keycloak for Swagger UI access.

**Solution:** Disabled `oauth2Login()` in gateway security configuration:

```java
// BEFORE (forced redirect)
.oauth2Login(oauth2 -> oauth2.authenticationSuccessHandler(...))

// AFTER (allow public Swagger UI)
// .oauth2Login() - COMMENTED OUT

// But keep resource server for JWT validation
.oauth2ResourceServer(oauth2 -> oauth2.jwt(...))
```

**Files Updated:**
- `platform/lens-platform-gateway/src/main/java/.../SecurityConfig.java`
- `platform/lens-platform-auth/src/main/java/.../SecurityConfig.java`
- `platform/lens-platform-system/src/main/java/.../SecurityConfig.java`

**Security Configuration:**
- Swagger UI paths: Public (permitAll)
- API endpoints: Protected (require JWT)
- `/webjars/**`: Public (for Swagger UI static resources)
- OAuth2 resource server: Enabled (validates JWT tokens)

---

### 6. CORS Issues Resolved ✅

**Issue:** Swagger UI showing CORS errors when testing endpoints.

**Root Cause:** Backend services' OpenAPI configuration pointed to direct backend URLs (e.g., `http://localhost:8041`), causing browser to see cross-origin requests.

**Solution:** Updated OpenAPI server URLs to use gateway URLs:

```yaml
# WRONG (causes CORS)
openapi:
  service:
    url: http://localhost:8041

# CORRECT (no CORS)
openapi:
  service:
    url: http://localhost:8050/v2/lens/platform/auth
```

**Files Updated:**
- Nacos configurations for all services
- Environment variables in `conf/env/lens_2026.env`

---

## Configuration Requirements

### Nacos Configuration

**Critical:** OAuth2 properties MUST use camelCase (not kebab-case):

```yaml
springdoc:
  swagger-ui:
    oauth:
      clientId: lens-client                    # NOT client-id
      clientSecret: x6lEH0DMcT27eop2cszIP3Brc2sDQHLb  # NOT client-secret
      usePkceWithAuthorizationCodeGrant: true  # NOT use-pkce-with-authorization-code-grant
      scopes:
        - openid
        - profile
        - email
```

### Keycloak Configuration

**Realm:** lens  
**Client ID:** lens-client  
**Client Secret:** x6lEH0DMcT27eop2cszIP3Brc2sDQHLb  
**Access Type:** confidential

**Valid Redirect URIs:**
- `http://localhost:8050/swagger-ui/oauth2-redirect.html`
- `http://localhost:8050/v2/lens/platform/auth/swagger-ui/oauth2-redirect.html`
- `http://localhost:8050/v2/lens/platform/system/swagger-ui/oauth2-redirect.html`

**Web Origins:**
- `http://localhost:8050`

---

## Testing Guide

### Test OAuth2 Authorization

1. **Open Swagger UI:**
   - Gateway: `http://localhost:8050/swagger-ui.html`
   - Auth: `http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html`
   - System: `http://localhost:8050/v2/lens/platform/system/swagger-ui/index.html`

2. **Click "Authorize" button**

3. **Verify pre-filled credentials:**
   ```
   client_id: lens-client         ✅ Pre-filled!
   client_secret: x6lEH0DMcT...   ✅ Pre-filled!
   
   Scopes:
   ☑ openid
   ☑ profile
   ☑ email
   ```

4. **Click "Authorize"** → Redirects to Keycloak login

5. **Login** with Keycloak credentials

6. **Automatic redirect back** → Shows "Authorized" ✅

7. **Test endpoint** → Works with JWT token automatically included

### Test Token Endpoints

```bash
# Get token
cd /home/zhenac/my/lens_2026/doc/keycloak/scripts
./get-token-for-swagger.sh lens <password>

# Test /token endpoint
curl -H "Authorization: Bearer <TOKEN>" http://localhost:8050/token

# Test /token/raw endpoint
curl -H "Authorization: Bearer <TOKEN>" http://localhost:8050/token/raw

# Test health endpoint
curl http://localhost:8050/health
```

---

## Key Lessons Learned

### 1. Springdoc Property Naming

**Springdoc uses Java camelCase naming, NOT Spring Boot kebab-case:**
- Java class: `SwaggerUiConfigProperties.OAuth`
- Properties: `clientId`, `clientSecret`, `usePkceWithAuthorizationCodeGrant`
- YAML must match Java naming exactly

### 2. WebFlux vs MVC URL Patterns

**Different frameworks = different Swagger UI URL patterns:**
- WebFlux (Gateway): `/swagger-ui.html`
- MVC (Backend): `/swagger-ui/index.html`

### 3. OAuth2 Client vs Resource Server

**Gateway is configured as BOTH but for different purposes:**
- Resource Server: Validates JWT tokens from authenticated requests
- NOT a Client: Doesn't log in users directly (that's Keycloak's job)

### 4. CORS Configuration

**OpenAPI server URL must match the actual access URL:**
- If accessed via gateway → server URL should be gateway URL
- If accessed directly → server URL should be direct URL
- Otherwise → CORS errors

---

## Files Modified

### Java Code
- `platform/lens-platform-gateway/.../OpenAPIConfig.java`
- `platform/lens-platform-gateway/.../SecurityConfig.java`
- `platform/lens-platform-gateway/.../GateController.java`
- `platform/lens-platform-auth/.../OpenAPIConfig.java`
- `platform/lens-platform-auth/.../SecurityConfig.java`
- `platform/lens-platform-system/.../OpenAPIConfig.java`
- `platform/lens-platform-system/.../SecurityConfig.java`

### Nacos Configuration
- `doc/nacos-backup/lens-platform-gateway.yaml`
- `doc/nacos-backup/lens-platform-auth.yaml`
- `doc/nacos-backup/lens-platform-system.yaml`

### Documentation
- `doc/openapi/README.md` (this file)
- `doc/openapi/HISTORY.md` (consolidated history)
- `doc/openapi/CORRECT_URLS.md` (URL reference)
- Multiple fix documentation files consolidated

---

## Summary of Current State

✅ **OAuth2 Authorization Code Flow** - Working with PKCE  
✅ **Pre-configured Credentials** - All services have clientId/secret pre-filled  
✅ **Swagger UI Access** - All services accessible without forced redirects  
✅ **JWT Token Validation** - Gateway validates tokens correctly  
✅ **CORS Configuration** - No cross-origin errors  
✅ **Token Endpoints** - Gateway provides token inspection endpoints  
✅ **Consistent Configuration** - All services follow same pattern  

---

**Last Updated:** 2026-02-27
