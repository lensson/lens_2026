#!/usr/bin/env bash
# Add a redirect URI to the 'lens-client' client in Keycloak via Admin REST API
# Usage: ./add_redirect_uri.sh [KEYCLOAK_URL] [ADMIN_USER] [ADMIN_PASS] [REALM] [CLIENT_ID] [NEW_REDIRECT_URI]
# Defaults:
#   KEYCLOAK_URL=http://localhost:28080
#   ADMIN_USER=admin
#   ADMIN_PASS=admin
#   REALM=lens
#   CLIENT_ID=lens-client
#   NEW_REDIRECT_URI=http://localhost:8060/

set -euo pipefail
IFS=$'\n\t'

KEYCLOAK_URL=${1:-http://localhost:28080}
ADMIN_USER=${2:-admin}
ADMIN_PASS=${3:-admin}
REALM=${4:-lens}
CLIENT_CLIENTID=${5:-lens-client}
NEW_REDIRECT_URI=${6:-http://localhost:8060/}

echo "Keycloak URL: $KEYCLOAK_URL"
echo "Realm: $REALM"
echo "Target client (clientId): $CLIENT_CLIENTID"
echo "New redirect URI: $NEW_REDIRECT_URI"

command -v jq >/dev/null 2>&1 || {
  echo "Error: jq is required but not installed. Please install jq and re-run." >&2
  exit 2
}

TMPDIR=$(mktemp -d)
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

TOKEN_URL="${KEYCLOAK_URL%/}/realms/master/protocol/openid-connect/token"
ADMIN_API_BASE="${KEYCLOAK_URL%/}/admin/realms/${REALM}"

echo "Obtaining admin token..."
TOKEN_RESPONSE=$(curl -sS -X POST "$TOKEN_URL" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password&client_id=admin-cli&username=${ADMIN_USER}&password=${ADMIN_PASS}")

ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r .access_token // empty)
if [ -z "$ACCESS_TOKEN" ]; then
  echo "Failed to obtain admin token. Response:" >&2
  echo "$TOKEN_RESPONSE" >&2
  exit 3
fi
echo "Got admin token (truncated): ${ACCESS_TOKEN:0:20}..."

echo "Finding client UUID for clientId='${CLIENT_CLIENTID}'..."
CLIENT_SEARCH=$(curl -sS -H "Authorization: Bearer $ACCESS_TOKEN" "$ADMIN_API_BASE/clients?clientId=${CLIENT_CLIENTID}")
CLIENT_UUID=$(echo "$CLIENT_SEARCH" | jq -r '.[0].id // empty')
if [ -z "$CLIENT_UUID" ]; then
  echo "Cannot find client with clientId='${CLIENT_CLIENTID}' in realm '${REALM}'. Response:" >&2
  echo "$CLIENT_SEARCH" >&2
  exit 4
fi
echo "Client UUID: $CLIENT_UUID"

CLIENT_URL="$ADMIN_API_BASE/clients/$CLIENT_UUID"
echo "Fetching existing client representation..."
curl -sS -H "Authorization: Bearer $ACCESS_TOKEN" "$CLIENT_URL" -o "$TMPDIR/client.json"

echo "Updating redirectUris (avoiding duplicates)..."
jq --arg uri "$NEW_REDIRECT_URI" '
  if has("redirectUris") then
    if (.redirectUris | index($uri)) then . else .redirectUris += [$uri] end
  else
    . + {redirectUris: [$uri]}
  end' "$TMPDIR/client.json" > "$TMPDIR/client_updated.json"

echo "Sending updated client representation (HTTP PUT)..."
HTTP_STATUS=$(curl -sS -o /dev/null -w "%{http_code}" -X PUT -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" --data-binary @"$TMPDIR/client_updated.json" "$CLIENT_URL")

if [ "$HTTP_STATUS" = "204" ] || [ "$HTTP_STATUS" = "200" ]; then
  echo "Success: redirect URI added (or already present): $NEW_REDIRECT_URI"
  echo "Verifying..."
  curl -sS -H "Authorization: Bearer $ACCESS_TOKEN" "$CLIENT_URL" | jq .redirectUris
  exit 0
else
  echo "Failed to update client. HTTP status: $HTTP_STATUS" >&2
  echo "Response body:" >&2
  curl -sS -H "Authorization: Bearer $ACCESS_TOKEN" "$CLIENT_URL" >&2 || true
  exit 5
fi

