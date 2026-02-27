# Swagger UI Authentication - OAuth2 Only

## Overview

Swagger UI uses **OAuth2 Authorization Code flow** with pre-configured client credentials for authentication.

### How It Works
- **Client credentials pre-configured** - no need to enter them!
- Click "Authorize" → redirects to Keycloak login
- Login with username/password
- Automatically redirected back with token
- Perfect for interactive testing

## Quick Start: OAuth2 Authentication

### Step 1: Open Swagger UI
```
http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html
```

### Step 2: Click "Authorize" Button
Look for the 🔒 lock icon at the top right.

### Step 3: Authorize with OAuth2
You'll see the authentication dialog:

**keycloak_oAuth_security_schema (OAuth2, authorizationCode)**
```
Available authorizations
  keycloak_oAuth_security_schema (OAuth2, authorizationCode)
  
  Scopes:
  ☑ openid - OpenID Connect scope
  ☑ profile - Profile information  
  ☑ email - Email address
  
  [Authorize] [Close]
```

**Important:** Client ID and secret are **already configured**! You don't need to enter them.

### Step 4: Click "Authorize"
- Select the scopes you want (all are pre-selected)
- Click **"Authorize"**
- You'll be redirected to Keycloak login page

### Step 5: Login to Keycloak
- Enter your username: `lens` (or your Keycloak user)
- Enter your password
- Click "Sign In"

### Step 6: Automatic Redirect Back
- After successful login, you'll automatically return to Swagger UI
- Dialog shows: **"Authorized"** ✅
- Click **"Close"**

### Step 7: Test Any Endpoint
- Find any endpoint (e.g., `GET /echo`)
- Click **"Try it out"**
- Click **"Execute"**
- ✅ It works! Token is automatically included!

## What Changed

### OAuth2 Flow Configuration
- **Flow Type:** Authorization Code with PKCE
- **Client Credentials:** Pre-configured in Springdoc
- **Scopes:** openid, profile, email

### Configuration Details

**Nacos Configuration:**
```yaml
springdoc:
  swagger-ui:
    oauth:
      client-id: lens-client
      client-secret: x6lEH0DMcT27eop2cszIP3Brc2sDQHLb
      use-pkce-with-authorization-code-grant: true
      scopes:
        - openid
        - profile
        - email
```

**OpenAPI Configuration (Java):**
```java
// Authorization Code flow for proper OAuth2
return new OAuthFlows().authorizationCode(flow);

// Token URL for token exchange
.tokenUrl(authServerUrl + "/realms/" + realm + "/protocol/openid-connect/token")

// Scopes matching Keycloak
.scopes(new Scopes()
    .addString("openid", "OpenID Connect scope")
    .addString("profile", "Profile information")
    .addString("email", "Email address"));
```


## Files Modified

**Java Code:**
- `platform/lens-platform-auth/src/main/java/.../OpenAPIConfig.java`
  - OAuth2 Authorization Code flow configured
  - Token URL added for token exchange
  - Scopes updated (openid, profile, email)
  - Bearer token scheme removed (OAuth2 only)

- `platform/lens-platform-system/src/main/java/.../OpenAPIConfig.java`
  - Same OAuth2 configuration as auth service

**Nacos Configuration:**
- `doc/nacos-backup/lens-platform-auth.yaml`
  - Pre-configured client-id and client-secret
  - Enabled PKCE for security
  - Added scopes configuration

- `doc/nacos-backup/lens-platform-system.yaml`
  - Same OAuth2 configuration as auth

## Troubleshooting

### "Unauthorized" Error After Login

**Symptoms:**
- Click "Authorize" in OAuth2 section
- Redirects to Keycloak
- Login successful
- Redirects back but shows "Unauthorized"

**Solution 1: Check Keycloak Client Configuration**
```bash
# 1. Open Keycloak admin: http://localhost:28080/admin
# 2. Login: admin/admin
# 3. Select realm: lens
# 4. Go to: Clients → lens-client
# 5. Verify:
#    - Access Type: confidential
#    - Valid Redirect URIs: 
#      http://localhost:8050/v2/lens/platform/auth/swagger-ui/oauth2-redirect.html
#      http://localhost:8050/v2/lens/platform/system/swagger-ui/oauth2-redirect.html
#    - Web Origins: http://localhost:8050
```

**Solution 2: Check Client Secret**
1. In Keycloak client → Credentials tab
2. Client Secret should be: `x6lEH0DMcT27eop2cszIP3Brc2sDQHLb`
3. If different, update Nacos config with correct secret

### Redirect Loop

**Symptoms:**
- Click "Authorize"
- Redirects to Keycloak
- Redirects back to Swagger UI
- Immediately redirects to Keycloak again (loop)

**Solution:**
- Clear browser cookies for localhost:8050
- Try in incognito/private browsing mode
- Verify PKCE is enabled in configuration


## Action Required

**RESTART AUTH AND SYSTEM SERVICES** to apply the configuration changes:

```bash
# Terminal 1: Auth Service
cd /home/zhenac/my/lens_2026/platform/lens-platform-auth
mvn spring-boot:run

# Terminal 2: System Service
cd /home/zhenac/my/lens_2026/platform/lens-platform-system
mvn spring-boot:run
```

**Wait ~30 seconds** for services to start and register with Nacos.

## Verification After Restart

### Check OAuth2 Configuration

1. Open: `http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html`
2. Click "Authorize" button
3. **Expected:** You should see:
   ```
   keycloak_oAuth_security_schema (OAuth2, authorizationCode)
   
   Scopes:
   ☑ openid
   ☑ profile
   ☑ email
   
   Client credentials location: Authorization URL
   
   [Authorize] [Close]
   ```
4. Click "Authorize" - should redirect to Keycloak login
5. Login with `lens` / your password
6. Should redirect back to Swagger UI
7. Dialog shows "Authorized" ✅

### Test an Endpoint

1. Find `GET /echo` endpoint
2. Click "Try it out"
3. Click "Execute"
4. **Expected:** HTTP 200 OK with response
5. Check request headers - should include `Authorization: Bearer <token>`

## Benefits of OAuth2 Authorization Code Flow

✅ **One-click authentication** - just click Authorize  
✅ **Client credentials pre-configured** - no manual entry needed  
✅ **Standard OAuth2 flow** - industry best practice  
✅ **PKCE enabled** - enhanced security  
✅ **Automatic token handling** - managed by Swagger UI  
✅ **User-friendly** - familiar Keycloak login page  
✅ **Token refresh** - handled automatically by browser  
✅ **Secure** - credentials never exposed to end users  

## Scripts Available

**Token Helper Script (for automation/testing):**
- `doc/keycloak/scripts/get-token-for-swagger.sh`
- Can be used for CI/CD or testing scripts
- Gets JWT token directly without browser

**Usage:**
```bash
./get-token-for-swagger.sh <username> <password>
```

## Summary

✅ **OAuth2 Only:** Simplified to single authentication method  
✅ **Client Credentials:** Pre-configured in Springdoc  
✅ **PKCE Enabled:** Enhanced security  
✅ **Bearer Auth Removed:** OAuth2 flow only  
✅ **Action:** Restart auth and system services  

---

**Status:** ✅ Configured - OAuth2 Authorization Code flow only  
**Action Required:** Restart auth and system services  
**Expected Result:** Click "Authorize" → login to Keycloak → test APIs

**Last Updated:** 2026-02-27
