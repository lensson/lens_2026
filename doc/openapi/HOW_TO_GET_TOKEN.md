# How to Get Token from Keycloak

## Keycloak Configuration

- **Server URL:** http://172.28.0.1:28080 (or http://localhost:28080)
- **Realm:** lens
- **Admin User:** admin
- **Admin Password:** admin

## Prerequisites

Before getting a token, you need:
1. A Keycloak client configured in the `lens` realm
2. A user account in the `lens` realm
3. The client must allow the desired grant type (password, client_credentials, authorization_code, etc.)

## Method 1: Password Grant (Direct Access)

This is the simplest method for testing. The user provides username and password directly.

### Using curl:

```bash
# Get token
TOKEN=$(curl -X POST "http://172.28.0.1:28080/realms/lens/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=YOUR_CLIENT_ID" \
  -d "client_secret=YOUR_CLIENT_SECRET" \
  -d "username=YOUR_USERNAME" \
  -d "password=YOUR_PASSWORD" \
  -d "grant_type=password" \
  | jq -r '.access_token')

# Use the token
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8050/v2/lens/platform/auth/users/me
```

### Full response example:

```bash
curl -X POST "http://172.28.0.1:28080/realms/lens/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=YOUR_CLIENT_ID" \
  -d "client_secret=YOUR_CLIENT_SECRET" \
  -d "username=YOUR_USERNAME" \
  -d "password=YOUR_PASSWORD" \
  -d "grant_type=password"
```

Response:
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 300,
  "refresh_expires_in": 1800,
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "not-before-policy": 0,
  "session_state": "...",
  "scope": "profile email"
}
```

## Method 2: Client Credentials Grant (Service-to-Service)

For backend services authenticating as themselves (no user context).

```bash
TOKEN=$(curl -X POST "http://172.28.0.1:28080/realms/lens/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=YOUR_CLIENT_ID" \
  -d "client_secret=YOUR_CLIENT_SECRET" \
  -d "grant_type=client_credentials" \
  | jq -r '.access_token')
```

## Method 3: Using Admin User (Keycloak Admin API)

To get an admin token for Keycloak management operations:

```bash
ADMIN_TOKEN=$(curl -X POST "http://172.28.0.1:28080/realms/master/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=admin-cli" \
  -d "username=admin" \
  -d "password=admin" \
  -d "grant_type=password" \
  | jq -r '.access_token')
```

## Method 4: Refresh Token

To get a new access token using a refresh token:

```bash
NEW_TOKEN=$(curl -X POST "http://172.28.0.1:28080/realms/lens/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=YOUR_CLIENT_ID" \
  -d "client_secret=YOUR_CLIENT_SECRET" \
  -d "grant_type=refresh_token" \
  -d "refresh_token=$REFRESH_TOKEN" \
  | jq -r '.access_token')
```

## Complete Example Script

Save this as `get-token.sh`:

```bash
#!/bin/bash

# Configuration
KEYCLOAK_URL="http://172.28.0.1:28080"
REALM="lens"
CLIENT_ID="your-client-id"
CLIENT_SECRET="your-client-secret"
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

# Extract tokens
ACCESS_TOKEN=$(echo $RESPONSE | jq -r '.access_token')
REFRESH_TOKEN=$(echo $RESPONSE | jq -r '.refresh_token')
EXPIRES_IN=$(echo $RESPONSE | jq -r '.expires_in')

if [ "$ACCESS_TOKEN" = "null" ]; then
  echo "Failed to get token!"
  echo "Response: $RESPONSE"
  exit 1
fi

echo "✅ Token obtained successfully!"
echo "Access Token: ${ACCESS_TOKEN:0:50}..."
echo "Expires in: $EXPIRES_IN seconds"
echo ""
echo "Full Access Token:"
echo "$ACCESS_TOKEN"
echo ""
echo "To use the token:"
echo "export TOKEN='$ACCESS_TOKEN'"
echo "curl -H 'Authorization: Bearer \$TOKEN' http://localhost:8050/v2/lens/platform/auth/test"
```

Make it executable:
```bash
chmod +x get-token.sh
./get-token.sh
```

## Testing the Token with Gateway

Once you have the token:

```bash
# Set the token
export TOKEN="your-access-token-here"

# Test public endpoint (no token needed)
curl http://localhost:8050/actuator/health

# Test protected endpoint (requires token)
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8050/v2/lens/platform/auth/users/me

# Test with verbose output
curl -v -H "Authorization: Bearer $TOKEN" \
  http://localhost:8050/v2/lens/platform/system/test
```

## Decode JWT Token (Inspect Claims)

To see what's inside your JWT token:

```bash
# Using jwt-cli (install: cargo install jwt-cli)
jwt decode $TOKEN

# Or using jq and base64
echo $TOKEN | cut -d'.' -f2 | base64 -d 2>/dev/null | jq .

# Online: https://jwt.io (paste your token)
```

## Common Issues

### 1. Invalid Client

**Error:** `{"error":"invalid_client"}`

**Solution:** 
- Check client_id is correct
- Check client_secret is correct (if confidential client)
- Ensure client exists in the realm

### 2. Invalid Grant

**Error:** `{"error":"invalid_grant","error_description":"Invalid user credentials"}`

**Solution:**
- Check username and password are correct
- Ensure user exists in the realm
- Check user is enabled

### 3. Unauthorized Client

**Error:** `{"error":"unauthorized_client"}`

**Solution:**
- Enable "Direct Access Grants" in client settings
- Check client has proper grant types enabled

### 4. CORS Issues

**Error:** CORS policy blocked

**Solution:**
- Add your origin to Keycloak client's Web Origins
- Gateway already has CORS configured for common origins

## Using Postman

1. Create a new POST request to: `http://172.28.0.1:28080/realms/lens/protocol/openid-connect/token`

2. Set Headers:
   - Content-Type: `application/x-www-form-urlencoded`

3. Set Body (x-www-form-urlencoded):
   - client_id: `your-client-id`
   - client_secret: `your-client-secret`
   - username: `your-username`
   - password: `your-password`
   - grant_type: `password`

4. Send request

5. Copy `access_token` from response

6. Use in subsequent requests:
   - Authorization tab
   - Type: Bearer Token
   - Token: (paste access_token)

## Environment Variables

Add to your shell profile for convenience:

```bash
# ~/.bashrc or ~/.zshrc
export KEYCLOAK_URL="http://172.28.0.1:28080"
export KEYCLOAK_REALM="lens"
export GATEWAY_URL="http://localhost:8050"

# Function to get token
get-token() {
  local CLIENT_ID="${1:-your-default-client}"
  local USERNAME="${2:-your-default-user}"
  local PASSWORD="${3}"
  
  if [ -z "$PASSWORD" ]; then
    read -sp "Password: " PASSWORD
    echo
  fi
  
  TOKEN=$(curl -s -X POST "$KEYCLOAK_URL/realms/$KEYCLOAK_REALM/protocol/openid-connect/token" \
    -d "client_id=$CLIENT_ID" \
    -d "username=$USERNAME" \
    -d "password=$PASSWORD" \
    -d "grant_type=password" \
    | jq -r '.access_token')
  
  if [ "$TOKEN" = "null" ]; then
    echo "Failed to get token!"
    return 1
  fi
  
  export TOKEN
  echo "✅ Token set! Use: curl -H 'Authorization: Bearer \$TOKEN' ..."
}

# Usage: get-token <client-id> <username> [password]
```

## Next Steps

1. **Create a client in Keycloak:**
   - Login to Keycloak Admin Console: http://172.28.0.1:28080
   - Select realm: lens
   - Go to Clients → Create client
   - Set client_id and configure access settings

2. **Create a user:**
   - Go to Users → Add user
   - Set username and save
   - Go to Credentials tab → Set password

3. **Test the flow:**
   ```bash
   # Get token
   TOKEN=$(curl -s -X POST "http://172.28.0.1:28080/realms/lens/protocol/openid-connect/token" \
     -d "client_id=YOUR_CLIENT" \
     -d "username=YOUR_USER" \
     -d "password=YOUR_PASS" \
     -d "grant_type=password" \
     | jq -r '.access_token')
   
   # Test gateway
   curl -H "Authorization: Bearer $TOKEN" \
     http://localhost:8050/v2/lens/platform/auth/test
   ```

## Reference

- Keycloak Admin Console: http://172.28.0.1:28080/admin
- Realm: lens
- Token Endpoint: http://172.28.0.1:28080/realms/lens/protocol/openid-connect/token
- JWK Set: http://172.28.0.1:28080/realms/lens/protocol/openid-connect/certs
- OpenID Configuration: http://172.28.0.1:28080/realms/lens/.well-known/openid-configuration
