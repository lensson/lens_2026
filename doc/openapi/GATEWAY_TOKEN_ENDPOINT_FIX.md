## Gateway /token Endpoint - Fixed

### Issue

The `/token` endpoint was raising a 500 error when invoked.

### Root Cause

The original code used `@RegisteredOAuth2AuthorizedClient` which requires OAuth2 **client** configuration (for logging in users):

```java
// OLD CODE - BROKEN
@GetMapping(value = "/token")
public Mono<String> getHome(@RegisteredOAuth2AuthorizedClient OAuth2AuthorizedClient authorizedClient) {
    return Mono.just(authorizedClient.getAccessToken().getTokenValue());
}
```

**Problem:** The gateway is configured as an OAuth2 **resource server** (validates JWT tokens), NOT an OAuth2 **client** (logs in users). We disabled `oauth2Login()` in the security configuration to allow public Swagger UI access.

**Result:** The annotation fails because there's no OAuth2 client configuration, causing a 500 error.

### Solution

Updated the controller to use `@AuthenticationPrincipal Jwt` instead, which works with the resource server configuration:

```java
// NEW CODE - FIXED
@GetMapping(value = "/token")
public Mono<TokenInfo> getTokenInfo(@AuthenticationPrincipal Jwt jwt) {
    if (jwt == null) {
        return Mono.just(new TokenInfo(
            false, 
            null, 
            "No JWT token found. Please authenticate first.",
            null,
            null
        ));
    }
    
    return Mono.just(new TokenInfo(
        true,
        jwt.getTokenValue(),
        "Token retrieved successfully",
        jwt.getClaims(),
        jwt.getExpiresAt()
    ));
}
```

### How to Use the /token Endpoint

#### 1. Get a JWT Token First

Use the Keycloak token endpoint or get-token script:

```bash
cd /home/zhenac/my/lens_2026/doc/keycloak/scripts
./get-token-for-swagger.sh lens <your-password>
```

Copy the JWT token from the output.

#### 2. Call the /token Endpoint

```bash
# Replace <YOUR_JWT_TOKEN> with actual token
curl -H "Authorization: Bearer <YOUR_JWT_TOKEN>" \
  http://localhost:8050/token
```

**Example:**
```bash
curl -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..." \
  http://localhost:8050/token
```

#### 3. Expected Response

```json
{
  "authenticated": true,
  "token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "message": "Token retrieved successfully",
  "claims": {
    "sub": "lens",
    "email": "lens@example.com",
    "preferred_username": "lens",
    "exp": 1709036400,
    "iat": 1709032800,
    ...
  },
  "expiresAt": "2026-02-27T12:00:00Z"
}
```

#### 4. If No Token Provided

```bash
curl http://localhost:8050/token
# Returns: 401 Unauthorized
```

### Other Useful Endpoints

#### /token/raw - Get Raw JWT Token String

```bash
curl -H "Authorization: Bearer <YOUR_JWT_TOKEN>" \
  http://localhost:8050/token/raw
```

**Response:** Just the raw token string (useful for copying)
```
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### / - Get Session ID

```bash
curl http://localhost:8050/
```

**Response:**
```
Gateway Session ID: 1234567890
```

#### /health - Health Check

```bash
curl http://localhost:8050/health
```

**Response:**
```
Gateway is running
```

### Use Cases

**1. Debugging JWT Tokens**
- Check what claims are in your token
- Verify token expiration
- Inspect token structure

**2. Testing Authentication**
- Verify that JWT tokens are being passed correctly
- Test token validation

**3. Token Inspection for Development**
- See decoded token contents
- Check user information
- Verify scopes and permissions

### Integration with Swagger UI

You can also test the `/token` endpoint in Swagger UI:

1. Open: `http://localhost:8050/swagger-ui.html`
2. Click "Authorize" and login via Keycloak
3. Find the `/token` endpoint
4. Click "Try it out" → "Execute"
5. See your token information

### File Modified

✅ `/home/zhenac/my/lens_2026/platform/lens-platform-gateway/src/main/java/com/lens/platform/gateway/controller/GateController.java`
- Removed `@RegisteredOAuth2AuthorizedClient` (OAuth2 client - doesn't work)
- Added `@AuthenticationPrincipal Jwt` (resource server - works)
- Added proper error handling for missing tokens
- Added detailed TokenInfo response object

### Summary

**Before:** `/token` endpoint raised 500 error (OAuth2 client not configured)  
**After:** `/token` endpoint works with JWT tokens from Authorization header  
**Usage:** `curl -H "Authorization: Bearer <token>" http://localhost:8050/token`  
**Response:** Token information including claims and expiration  

---

**Status:** ✅ Fixed - Controller updated to work with resource server configuration  
**No restart needed** - Just recompile the gateway class  
**Expected Result:** `/token` endpoint returns JWT token information

**Last Updated:** 2026-02-27
