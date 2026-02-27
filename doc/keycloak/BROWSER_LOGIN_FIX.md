# Browser OAuth2 Login Setup - SOLVED

## Problem
When accessing `http://localhost:8050/v2/lens/platform/auth/echo` in browser:
```
We are sorry...
Invalid parameter: redirect_uri
```

## Root Cause
The Keycloak client `lens-client` did not have the gateway's OAuth2 callback URLs configured in its allowed redirect URIs.

## Solution Applied

✅ **Configured Keycloak client with proper redirect URIs**

Run this script to fix:
```bash
cd doc/keycloak/scripts
./configure-client.sh
```

The script automatically configures:

**Redirect URIs:**
- `http://localhost:8050/*`
- `http://localhost:8050/login/oauth2/code/*`
- `http://localhost:8050/login/oauth2/code/keycloak`
- `http://172.28.0.1:8050/*` (if accessing via IP)

**Web Origins:**
- `http://localhost:8050`
- `http://172.28.0.1:8050`
- `+` (allow all origins from redirect URIs)

**Flow Settings:**
- Standard Flow: ✅ Enabled (for browser login)
- Direct Access Grants: ✅ Enabled (for API token access)

## Test Browser Login

1. **Start the gateway** (if not already running):
   ```bash
   cd /home/zhenac/my/lens_2026/platform/lens-platform-gateway
   mvn spring-boot:run
   ```

2. **Open browser and access**:
   ```
   http://localhost:8050/v2/lens/platform/auth/echo
   ```

3. **Expected flow**:
   - Browser redirects to Keycloak login page
   - Enter credentials:
     - Username: `lens` (or your configured user)
     - Password: (set in Keycloak)
   - After successful login, redirect back to gateway
   - Access granted to protected resource
   - Response: `lens-platform-auth run on 8041`

## Manual Configuration (Alternative)

If you prefer to configure manually via Keycloak Admin Console:

1. Access: http://172.28.0.1:28080/admin/master/console/
2. Login: admin/admin
3. Switch to realm: `lens`
4. Go to: Clients → lens-client
5. Settings tab:
   - **Valid Redirect URIs**: Add `http://localhost:8050/login/oauth2/code/keycloak`
   - **Web Origins**: Add `http://localhost:8050`
   - **Standard Flow Enabled**: ON
   - **Direct Access Grants Enabled**: ON
6. Save

## Verify Configuration

Check if the client is properly configured:

```bash
# Get admin token
ADMIN_TOKEN=$(curl -s -X POST "http://172.28.0.1:28080/realms/master/protocol/openid-connect/token" \
  -d "client_id=admin-cli" \
  -d "username=admin" \
  -d "password=admin" \
  -d "grant_type=password" | jq -r '.access_token')

# Get client config
curl -s "http://172.28.0.1:28080/admin/realms/lens/clients" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  | jq '.[] | select(.clientId=="lens-client") | {redirectUris, webOrigins, standardFlowEnabled}'
```

## Troubleshooting

### Still getting "Invalid redirect_uri"?

**Check 1: Verify the redirect URI in error message**
The error page should show what redirect_uri was attempted. Make sure it matches one in the allowed list.

**Check 2: Clear browser cache and cookies**
```bash
# Or use incognito/private mode
```

**Check 3: Verify gateway configuration**
```bash
curl -s "http://localhost:8848/nacos/v1/cs/configs?dataId=lens-platform-gateway.yaml&group=DEFAULT_GROUP&tenant=lens_2026" | grep -A 5 "redirect-uri"
```

Should show:
```yaml
redirect-uri: "{baseUrl}/login/oauth2/code/{registrationId}"
```

**Check 4: Check gateway logs**
```bash
# Look for OAuth2 redirect URL in logs
tail -f platform/lens-platform-gateway/logs/gateway.log
```

### User not found?

Create a test user in Keycloak:
1. Go to: Users → Add user
2. Username: `testuser`
3. Save
4. Go to: Credentials tab
5. Set password
6. Temporary: OFF
7. Save

## API Access (Still Works)

API clients using Bearer tokens are unaffected:

```bash
# Get token
source doc/keycloak/scripts/quick-token.sh

# Call API
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8050/v2/lens/platform/auth/echo
```

## Summary

✅ **Problem**: Browser OAuth2 login redirect failed with "Invalid redirect_uri"  
✅ **Cause**: Missing redirect URIs in Keycloak client configuration  
✅ **Solution**: Configured redirect URIs via `configure-client.sh` script  
✅ **Result**: Browser users can now login via Keycloak and access protected resources  

The gateway now supports both:
- 🌐 **Browser login** - OAuth2 authorization code flow with redirect
- 🔑 **API access** - Direct Bearer token authentication
