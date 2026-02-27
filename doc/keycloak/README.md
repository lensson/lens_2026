# Keycloak Authentication Scripts

This directory contains scripts for obtaining OAuth2 tokens from Keycloak.

## Files

### Scripts (`scripts/`)

- **`get-token.sh`** - Advanced token retrieval script
  - Supports both password and client_credentials grants
  - Interactive prompts for credentials
  - Detailed output and error handling
  - Usage: `./scripts/get-token.sh [client_id] [username]`
  - Client credentials: `./scripts/get-token.sh lens-client --client-credentials`

- **`quick-token.sh`** - Quick token retrieval (client_credentials)
  - Fast, non-interactive token retrieval
  - Uses client_credentials grant
  - Exports TOKEN variable
  - Usage: `source scripts/get-token.sh` or `./scripts/quick-token.sh`

- **`configure-client.sh`** - Configure Keycloak client for OAuth2 login
  - Sets redirect URIs for gateway
  - Enables Standard Flow and Direct Access Grants
  - Fixes "Invalid redirect_uri" errors
  - Usage: `./scripts/configure-client.sh`

- **`sync-realm.sh`** - Export realm configuration from Keycloak
  - Downloads current realm config from Keycloak
  - Saves to realm-lens.json
  - Creates backup of existing file
  - Usage: `./scripts/sync-realm.sh`

- **`import-realm.sh`** - Import realm configuration to Keycloak
  - Uploads realm-lens.json to Keycloak
  - Updates existing realm configuration
  - Requires confirmation before import
  - Usage: `./scripts/import-realm.sh`

### Documentation

- **`TOKEN_EXAMPLES.md`** - Comprehensive token examples
  - Copy-paste ready commands
  - All grant types covered
  - Testing examples
  - Troubleshooting guide

- **`realm-lens.json`** - Keycloak realm configuration
  - Complete realm export
  - Client configurations
  - User configurations

## Quick Start

### Get Token Using Client Credentials

```bash
# Interactive (exports $TOKEN)
source doc/keycloak/scripts/quick-token.sh

# Non-interactive
TOKEN=$(cd doc/keycloak/scripts && ./quick-token.sh | grep "export TOKEN" | cut -d"'" -f2)
```

### Get Token Using Password Grant

```bash
cd doc/keycloak/scripts
./get-token.sh lens-client your-username
# Enter password when prompted
```

## Configuration

All scripts use these default values (can be overridden with environment variables):

- **Keycloak URL**: `http://172.28.0.1:28080`
- **Realm**: `lens`
- **Client ID**: `lens-client`
- **Client Secret**: `x6lEH0DMcT27eop2cszIP3Brc2sDQHLb`

## Realm Synchronization

### Keep realm-lens.json synchronized with Keycloak

**Export from Keycloak (recommended workflow):**
```bash
cd scripts
./sync-realm.sh
```

This will:
- Export current realm configuration from Keycloak
- Save to `realm-lens.json`
- Create backup of existing file (`.backup.TIMESTAMP`)
- Show summary of clients, users, and roles

**Import to Keycloak (use with caution):**
```bash
cd scripts
./import-realm.sh
```

This will:
- Upload `realm-lens.json` to Keycloak
- Update the existing realm configuration
- Require confirmation before proceeding

**When to sync:**
- After making changes in Keycloak admin console
- After configuring clients via script
- Before committing changes to version control
- After adding/modifying users or roles

**Best Practice:**
1. Make changes in Keycloak UI or via scripts
2. Run `./sync-realm.sh` to export
3. Commit `realm-lens.json` to version control
4. Team members can import with `./import-realm.sh`

## Configuration

All scripts use these default values (can be overridden with environment variables):

- **Keycloak URL**: `http://172.28.0.1:28080`
- **Realm**: `lens`
- **Client ID**: `lens-client`
- **Client Secret**: `x6lEH0DMcT27eop2cszIP3Brc2sDQHLb`

## Usage with Gateway

Once you have a token:

```bash
# Test via gateway
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8050/v2/lens/platform/auth/echo

# Test direct
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8041/echo
```

## See Also

- `/doc/HOW_TO_GET_TOKEN.md` - Detailed token retrieval guide
- `/doc/testing/` - API testing scripts
- `/conf/env/lens_2026.env` - Environment configuration
