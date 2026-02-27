# Token Examples with Actual Configuration
## Keycloak Configuration
Based on your realm-lens.json:
- **Server:** http://172.28.0.1:28080
- **Realm:** lens
- **Client ID:** lens-client (or other configured client)
- **Client Secret:** x6lEH0DMcT27eop2cszIP3Brc2sDQHLb
- **Admin User:** admin
- **Admin Password:** admin
## Quick Start
### Using the Helper Script (Recommended)
```bash
./scripts/get-token.sh lens-client your-username
```
The script will:
- Prompt for password
- Automatically use the client secret (x6lEH0DMcT27eop2cszIP3Brc2sDQHLb)
- Get token from Keycloak
- Export $TOKEN variable
- Show usage examples
### Using curl Directly
```bash
# Get token with client secret
TOKEN=$(curl -s -X POST "http://172.28.0.1:28080/realms/lens/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=lens-client" \
  -d "client_secret=x6lEH0DMcT27eop2cszIP3Brc2sDQHLb" \
  -d "username=YOUR_USERNAME" \
  -d "password=YOUR_PASSWORD" \
  -d "grant_type=password" \
  | jq -r '.access_token')
# Verify token
echo $TOKEN
# Use with gateway
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8050/v2/lens/platform/auth/test
```
## Full Example with Real Values
```bash
#!/bin/bash
# Configuration from realm-lens.json
KEYCLOAK_URL="http://172.28.0.1:28080"
REALM="lens"
CLIENT_ID="lens-client"
CLIENT_SECRET="x6lEH0DMcT27eop2cszIP3Brc2sDQHLb"
USERNAME="your-username"
PASSWORD="your-password"
# Get token
echo "Getting token from Keycloak..."
RESPONSE=$(curl -s -X POST "$KEYCLOAK_URL/realms/$REALM/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "username=$USERNAME" \
  -d "password=$PASSWORD" \
  -d "grant_type=password")
# Extract access token
ACCESS_TOKEN=$(echo $RESPONSE | jq -r '.access_token')
if [ "$ACCESS_TOKEN" = "null" ] || [ -z "$ACCESS_TOKEN" ]; then
  echo "Failed to get token!"
  echo "Response: $RESPONSE"
  exit 1
fi
echo "✅ Token obtained!"
echo "Token: ${ACCESS_TOKEN:0:50}..."
# Test with gateway
echo ""
echo "Testing gateway endpoints..."
# Public endpoint
echo "1. Public endpoint (no auth):"
curl -s http://localhost:8050/actuator/health | jq .
# Protected endpoint
echo ""
echo "2. Protected endpoint (with token):"
curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  http://localhost:8050/v2/lens/platform/auth/test
# Export for later use
export TOKEN="$ACCESS_TOKEN"
echo ""
echo "Token exported to \$TOKEN variable"
```
## Testing Different Grant Types
### 1. Password Grant (User Login)
```bash
curl -X POST "http://172.28.0.1:28080/realms/lens/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=lens-client" \
  -d "client_secret=x6lEH0DMcT27eop2cszIP3Brc2sDQHLb" \
  -d "username=testuser" \
  -d "password=testpass" \
  -d "grant_type=password"
```
### 2. Client Credentials Grant (Service-to-Service)
```bash
curl -X POST "http://172.28.0.1:28080/realms/lens/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=lens-client" \
  -d "client_secret=x6lEH0DMcT27eop2cszIP3Brc2sDQHLb" \
  -d "grant_type=client_credentials"
```
### 3. Refresh Token
```bash
curl -X POST "http://172.28.0.1:28080/realms/lens/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=lens-client" \
  -d "client_secret=x6lEH0DMcT27eop2cszIP3Brc2sDQHLb" \
  -d "grant_type=refresh_token" \
  -d "refresh_token=YOUR_REFRESH_TOKEN"
```
## Complete Test Flow
```bash
# 1. Get token using helper script
./scripts/get-token.sh lens-client myuser
# (Enter password when prompted)
# 2. Token is now in $TOKEN variable
# 3. Test public endpoint
curl http://localhost:8050/actuator/health
# 4. Test protected endpoint
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8050/v2/lens/platform/auth/users/me
# 5. Test backend service (token is relayed)
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8050/v2/lens/platform/system/info
# 6. Decode token to see claims
echo $TOKEN | cut -d'.' -f2 | base64 -d 2>/dev/null | jq .
```
## Troubleshooting
### Invalid Client Error
```json
{"error":"invalid_client"}
```
**Solution:** Check that client_id and client_secret match your Keycloak configuration.
### Invalid Grant Error
```json
{"error":"invalid_grant","error_description":"Invalid user credentials"}
```
**Solution:** 
- Check username and password are correct
- Ensure user exists in the `lens` realm
- Verify user is enabled
### Unauthorized Client Error
```json
{"error":"unauthorized_client"}
```
**Solution:** 
- Go to Keycloak Admin Console
- Navigate to Clients → [your-client]
- Enable "Direct Access Grants Enabled"
- Save
## Environment Variables
You can set these in your shell:
```bash
export KEYCLOAK_URL="http://172.28.0.1:28080"
export KEYCLOAK_REALM="lens"
export KEYCLOAK_CLIENT_ID="lens-client"
export KEYCLOAK_CLIENT_SECRET="x6lEH0DMcT27eop2cszIP3Brc2sDQHLb"
# Then use in scripts
TOKEN=$(curl -s -X POST "$KEYCLOAK_URL/realms/$KEYCLOAK_REALM/protocol/openid-connect/token" \
  -d "client_id=$KEYCLOAK_CLIENT_ID" \
  -d "client_secret=$KEYCLOAK_CLIENT_SECRET" \
  -d "username=$1" \
  -d "password=$2" \
  -d "grant_type=password" \
  | jq -r '.access_token')
```
## Security Note
⚠️ **Important:** The client secret is sensitive information. In production:
- Store it in secure vaults (HashiCorp Vault, AWS Secrets Manager, etc.)
- Never commit it to version control
- Use environment variables or secure configuration management
- Rotate secrets regularly
