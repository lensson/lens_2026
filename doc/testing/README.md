# API Testing Scripts

This directory contains scripts for testing REST APIs in the Lens platform.

## Files

### Scripts (`scripts/`)

- **`test-auth-api.sh`** - Comprehensive auth service API test suite
  - Automatically retrieves OAuth2 token
  - Tests all available endpoints
  - Detailed output with color coding
  - Supports both gateway and direct access
  - Usage: `./scripts/test-auth-api.sh`
  - Direct access: `USE_GATEWAY=false ./scripts/test-auth-api.sh`

- **`quick-test-auth.sh`** - Quick auth API tests
  - Fast, minimal output
  - Tests main endpoints
  - Gets token automatically
  - Usage: `./scripts/quick-test-auth.sh`

## Available Auth Endpoints

The auth service provides these endpoints:

1. `GET /echo` - Returns application name and port
2. `GET /caller/ping` - Calls system service (requires TEST scope)
3. `GET /actuator/health` - Health check (public)
4. `GET /actuator/info` - Application info (public)

## Quick Start

### Run Full Test Suite

```bash
cd doc/testing
./scripts/test-auth-api.sh
```

### Quick Test

```bash
cd doc/testing
./scripts/quick-test-auth.sh
```

### Manual Testing

```bash
# Get token first
source ../keycloak/scripts/quick-token.sh

# Test endpoints
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8050/v2/lens/platform/auth/echo

curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8050/v2/lens/platform/auth/caller/ping
```

## Gateway vs Direct Access

**Via Gateway (default):**
- URL: `http://localhost:8050/v2/lens/platform/auth`
- JWT validation at gateway
- TokenRelay forwards token to backend

**Direct to Service:**
```bash
USE_GATEWAY=false ./scripts/test-auth-api.sh
```
- URL: `http://localhost:8041`
- Bypasses gateway

## Test Output Example

```
Testing Auth Endpoints:

1. GET /echo
lens-platform-auth run on 8041

2. GET /caller/ping
Callme scopes: pong

3. GET /actuator/health (public)
UP
```

## Authentication

All protected endpoints require OAuth2 JWT token:
- Token obtained from Keycloak
- Grant type: client_credentials (default) or password
- Client: lens-client
- Secret: x6lEH0DMcT27eop2cszIP3Brc2sDQHLb

## See Also

- `/doc/keycloak/` - Token retrieval scripts
- `/doc/HOW_TO_GET_TOKEN.md` - Token guide
- `/platform/lens-platform-auth/` - Auth service source code
