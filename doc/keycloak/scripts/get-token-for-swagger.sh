#!/bin/bash
# Get JWT Token from Keycloak for Swagger UI Testing

echo "=========================================="
echo "Get JWT Token for Swagger UI"
echo "=========================================="
echo ""

# Keycloak configuration
KEYCLOAK_URL="http://localhost:28080"
REALM="lens"
CLIENT_ID="lens-client"
CLIENT_SECRET="x6lEH0DMcT27eop2cszIP3Brc2sDQHLb"
USERNAME="${1:-lens}"
PASSWORD="${2}"

if [ -z "$PASSWORD" ]; then
    echo "Usage: $0 <username> <password>"
    echo ""
    echo "Example:"
    echo "  $0 lens mypassword"
    echo ""
    echo "Or with default username 'lens':"
    echo "  $0 lens <your-password>"
    exit 1
fi

echo "🔑 Requesting token from Keycloak..."
echo "   URL: $KEYCLOAK_URL"
echo "   Realm: $REALM"
echo "   Client: $CLIENT_ID"
echo "   Username: $USERNAME"
echo ""

# Get token
RESPONSE=$(curl -s -X POST "$KEYCLOAK_URL/realms/$REALM/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "username=$USERNAME" \
  -d "password=$PASSWORD" \
  -d "scope=openid profile email")

# Check for errors
if echo "$RESPONSE" | grep -q "error"; then
    echo "❌ Error getting token:"
    echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"
    exit 1
fi

# Extract tokens
ACCESS_TOKEN=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin).get('access_token', ''))" 2>/dev/null)
REFRESH_TOKEN=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin).get('refresh_token', ''))" 2>/dev/null)
EXPIRES_IN=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin).get('expires_in', ''))" 2>/dev/null)

if [ -z "$ACCESS_TOKEN" ]; then
    echo "❌ Failed to extract access token from response"
    echo "$RESPONSE"
    exit 1
fi

echo "✅ Token obtained successfully!"
echo ""
echo "=========================================="
echo "Access Token (JWT):"
echo "=========================================="
echo ""
echo "$ACCESS_TOKEN"
echo ""
echo "=========================================="
echo "Token expires in: $EXPIRES_IN seconds ($(($EXPIRES_IN / 60)) minutes)"
echo "=========================================="
echo ""
echo "📋 How to use in Swagger UI:"
echo "-----------------------------------"
echo ""
echo "1. Open Swagger UI:"
echo "   http://localhost:8050/v2/lens/platform/auth/swagger-ui.html"
echo ""
echo "2. Click the 'Authorize' button (🔒 lock icon)"
echo ""
echo "3. You'll see TWO authentication options:"
echo ""
echo "   Option 1: bearer_auth (HTTP, Bearer) ✅ RECOMMENDED"
echo "   ----------------------------------------"
echo "   - Select this option"
echo "   - In the 'Value' field, paste the token above"
echo "   - Click 'Authorize'"
echo "   - Click 'Close'"
echo ""
echo "   Option 2: keycloak_oAuth_security_schema (OAuth2)"
echo "   ----------------------------------------"
echo "   - This will redirect to Keycloak login"
echo "   - Use if you want full OAuth2 flow"
echo ""
echo "4. Test an endpoint (e.g., GET /echo)"
echo "   - Click 'Try it out'"
echo "   - Click 'Execute'"
echo "   - The token will be automatically included!"
echo ""
echo "=========================================="
echo ""
echo "💡 Save this token for testing (valid for $(($EXPIRES_IN / 60)) minutes)"
echo ""

# Save to file for easy access
TOKEN_FILE="/tmp/keycloak_token.txt"
echo "$ACCESS_TOKEN" > "$TOKEN_FILE"
echo "✅ Token saved to: $TOKEN_FILE"
echo ""
