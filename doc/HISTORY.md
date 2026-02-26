# lens_2026 Project History

## 2026-02-26: Documentation Consolidation

### Overview
Simplified project documentation by consolidating multiple markdown files into two main documents: README.md (root) and HISTORY.md (doc/).

### Changes Made

**Deleted Files:**
- `/doc/TROUBLESHOOTING.md` - Content merged into README.md
- `/doc/NACOS_VERIFICATION.md` - Information already in HISTORY.md
- `/doc/QUICKREF_ENV.md` - Content merged into README.md
- `/doc/env/README.md` - Content merged into README.md
- `/doc/nacos-backup/README.md` - Content merged into README.md

**Enhanced README.md:**
Added the following sections:
1. **环境配置 (Environment Configuration)**
   - Environment variable management
   - Service startup commands
   - Key environment variables table
   
2. **Nacos 配置管理 (Nacos Configuration Management)**
   - Configuration file locations
   - Upload instructions
   - Verification commands
   
3. **Gateway 路由配置 (Gateway Routes)**
   - RESTful route patterns
   - API usage examples
   
4. **故障排查 (Troubleshooting)**
   - Common issues and solutions
   - Useful commands

5. **文档 (Documentation)**
   - Reference to all documentation files

### Documentation Structure

**Before:**
```
lens_2026/
├── README.md
├── doc/
│   ├── HISTORY.md
│   ├── TROUBLESHOOTING.md
│   ├── NACOS_VERIFICATION.md
│   ├── QUICKREF_ENV.md
│   ├── env/
│   │   └── README.md
│   └── nacos-backup/
│       └── README.md
└── scripts/
```

**After:**
```
lens_2026/
├── README.md              ← Enhanced with all essential content
├── doc/
│   ├── HISTORY.md        ← Detailed change history
│   ├── env/
│   │   └── lens_2026.env
│   └── nacos-backup/
│       ├── *.yaml
│       └── upload-*.sh
└── scripts/
    └── start-services.sh
```

### Benefits

1. **Simplified Structure** - Only 2 main markdown files to maintain
2. **Better Organization** - All essential info in README.md, history in HISTORY.md
3. **Less Duplication** - Removed redundant content across files
4. **Easier Discovery** - Users find everything in main README
5. **Maintained History** - All technical changes preserved in HISTORY.md

### Content Distribution

**README.md contains:**
- Project overview and architecture
- Quick start guide
- Environment configuration
- Nacos configuration management
- Gateway routing
- Troubleshooting
- Common commands

**HISTORY.md contains:**
- All historical changes
- Technical implementation details
- Migration notes
- Configuration evolution

---

## 2026-02-25: Gateway Routes Updated to RESTful Path Pattern

### Overview
Updated gateway routing configuration to use a more RESTful and versioned path pattern: `/v2/lens/platform/{service}/**`

### Changes Made

**Updated Gateway Routes:**
- Old pattern: `/{service}/**` with `StripPrefix=1`
- New pattern: `/v2/lens/platform/{service}/**` with `StripPrefix=4`

**Route Changes:**

| Service | Old Path | New Path | StripPrefix |
|---------|----------|----------|-------------|
| Auth | `/auth/**` | `/v2/lens/platform/auth/**` | 1 → 4 |
| System | `/system/**` | `/v2/lens/platform/system/**` | 1 → 4 |
| Monitor | `/monitor/**` | `/v2/lens/platform/monitor/**` | 1 → 4 |

### How StripPrefix Works

`StripPrefix=4` removes the first 4 path segments before forwarding:

**Example:**
```
Request:  GET /v2/lens/platform/auth/users/123
Segments: [v2] [lens] [platform] [auth] [users] [123]
Strip 4:  Remove [v2] [lens] [platform] [auth]
Forward:  GET /users/123 → lens-platform-auth service
```

### API Usage Examples

**Auth Service:**
```bash
# Login
curl http://localhost:8050/v2/lens/platform/auth/login

# User info
curl http://localhost:8050/v2/lens/platform/auth/users/me
```

**System Service:**
```bash
# List users
curl http://localhost:8050/v2/lens/platform/system/users

# Get user
curl http://localhost:8050/v2/lens/platform/system/users/123
```

**Monitor Service:**
```bash
# Health check
curl http://localhost:8050/v2/lens/platform/monitor/actuator/health

# Metrics
curl http://localhost:8050/v2/lens/platform/monitor/actuator/metrics
```

### Benefits

1. **Versioning** - Path includes version (`/v2/`) for API evolution
2. **Namespace** - Clear namespace (`/lens/platform/`) for organization
3. **Consistency** - All services follow the same pattern
4. **RESTful** - More professional and standard API structure
5. **Clarity** - Path clearly indicates: version/organization/module/service

### Files Updated

**Modified:**
- `/doc/nacos-backup/lens-platform-gateway.yaml`
  - Updated all route paths to `/v2/lens/platform/{service}/**`
  - Changed `StripPrefix` from 1 to 4

**Synchronized:**
- ✅ Uploaded to Nacos (namespace: lens_2026, group: DEFAULT_GROUP)
- ✅ Verified in Nacos server

### Migration Notes

**For API Consumers:**
- Update all API calls to use new path prefix: `/v2/lens/platform/`
- Old paths (`/auth/**`, `/system/**`, `/monitor/**`) will not work

**Examples:**
```bash
# Old (deprecated)
curl http://localhost:8050/auth/login

# New (correct)
curl http://localhost:8050/v2/lens/platform/auth/login
```

---

## 2026-02-25: Environment Configuration with Dynamic Variables

### Overview
Created comprehensive environment configuration system to eliminate hardcoded IPs and ports. All configuration values are now dynamic and loaded from environment variables with sensible defaults.

### Changes Made

**Created:**
- `/doc/env/lens_2026.env` - Main environment configuration file with all variables
- `/doc/env/README.md` - Documentation for environment configuration
- `/scripts/start-services.sh` - Service startup script that loads environment

**Modified:**
- `/doc/nacos-backup/lens-platform-gateway.yaml` - Now uses environment variables
- `/doc/nacos-backup/lens-platform-auth.yaml` - Now uses environment variables
- `/doc/nacos-backup/lens-platform-system.yaml` - Now uses environment variables
- `/doc/nacos-backup/lens-platform-monitor.yaml` - Now uses environment variables

### Environment Variables

**Infrastructure Services:**
- `NACOS_HOST`, `NACOS_PORT`, `NACOS_SERVER_ADDR`, `NACOS_NAMESPACE`, `NACOS_GROUP`
- `KEYCLOAK_HOST`, `KEYCLOAK_PORT`, `KEYCLOAK_URL`, `KEYCLOAK_REALM`
- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USERNAME`, `DB_PASSWORD`, `DB_URL`
- `REDIS_HOST`, `REDIS_PORT`, `REDIS_PASSWORD`, `REDIS_DATABASE`
- `RABBITMQ_HOST`, `RABBITMQ_PORT`, `RABBITMQ_USERNAME`, `RABBITMQ_PASSWORD`

**Platform Service Ports:**
- `GATEWAY_PORT` (8050), `GATEWAY_HOST`, `GATEWAY_URL`
- `AUTH_PORT` (8041), `AUTH_HOST`, `AUTH_URL`
- `SYSTEM_PORT` (8042), `SYSTEM_HOST`, `SYSTEM_URL`
- `MONITOR_PORT` (8043), `MONITOR_HOST`, `MONITOR_URL`

**Security Configuration:**
- `JWT_JWK_SET_URI` - Derived from Keycloak URL and realm
- `JWT_ISSUER_URI` - Derived from Keycloak URL and realm

**Logging Configuration:**
- `LOG_LEVEL_ROOT`, `LOG_LEVEL_LENS`, `LOG_LEVEL_SPRING_SECURITY`, `LOG_LEVEL_SPRING_GATEWAY`

**Other:**
- `OPENAPI_VERSION`, `SPRING_PROFILES_ACTIVE`, `PROMETHEUS_URL`, `ZIPKIN_URL`

### Nacos Configuration Changes

All Nacos YAML files now use Spring Boot's property placeholder syntax:

**Before (Hardcoded):**
```yaml
server:
  port: 8050
keycloak:
  url: http://localhost:8080
```

**After (Dynamic):**
```yaml
server:
  port: ${GATEWAY_PORT:8050}
keycloak:
  url: ${KEYCLOAK_URL:http://localhost:8080}
```

**Benefits:**
- Values are read from environment variables
- Defaults provided after colon (`:`)
- No code changes needed
- Environment-specific configuration

### Usage

**Load Environment:**
```bash
source doc/env/lens_2026.env
```

**Start Services:**
```bash
# Using startup script (recommended)
./scripts/start-services.sh start

# Or manually
source doc/env/lens_2026.env
cd platform/lens-platform-gateway
mvn spring-boot:run
```

**Override Values:**
```bash
source doc/env/lens_2026.env
export GATEWAY_PORT=9050
export KEYCLOAK_URL=http://keycloak.example.com:8080
mvn spring-boot:run
```

**Display Configuration:**
```bash
source doc/env/lens_2026.env --show
```

### Service Startup Script

Created `/scripts/start-services.sh` with features:
- Automatic environment loading
- Start/stop/restart/status commands
- Individual or all services
- PID management
- Color-coded output

**Commands:**
```bash
./scripts/start-services.sh start                          # Start all
./scripts/start-services.sh start lens-platform-gateway    # Start gateway
./scripts/start-services.sh stop                           # Stop all
./scripts/start-services.sh status                         # Check status
./scripts/start-services.sh env                            # Show environment
```

### Key Benefits

1. **No Hardcoded Values** - All IPs, ports, URLs are configurable
2. **Environment Flexibility** - Easy dev/test/prod separation
3. **Centralized Configuration** - Single source of truth
4. **Override Capability** - Export variables to override defaults
5. **Default Values** - Works out of box for local development
6. **Version Control** - Track environment configuration changes
7. **Documentation** - Clear variable documentation
8. **Automation** - Scripts handle environment loading

### Migration from Hardcoded Values

| Configuration | Before | After |
|---------------|--------|-------|
| Server Ports | `8050`, `8041`, etc. | `${GATEWAY_PORT:8050}`, `${AUTH_PORT:8041}` |
| Keycloak URL | `http://localhost:8080` | `${KEYCLOAK_URL:http://localhost:8080}` |
| Keycloak Realm | `lens` | `${KEYCLOAK_REALM:lens}` |
| JWT JWK URI | hardcoded URL | `${JWT_JWK_SET_URI:...}` |
| OpenAPI Version | `2.0.0` | `${OPENAPI_VERSION:2.0.0}` |
| Log Levels | `INFO`, `DEBUG` | `${LOG_LEVEL_ROOT:INFO}`, `${LOG_LEVEL_LENS:DEBUG}` |

### Files Uploaded to Nacos

All updated configurations with environment variables uploaded:
- ✅ lens-platform-gateway.yaml
- ✅ lens-platform-auth.yaml
- ✅ lens-platform-system.yaml
- ✅ lens-platform-monitor.yaml

### Documentation

- `/doc/env/README.md` - Complete environment configuration guide
- `/doc/env/lens_2026.env` - Main environment file with all variables
- Inline comments in env file explaining each variable
- Variable defaults for local development

### Next Steps

1. **Create Production Environment:**
   ```bash
   cp doc/env/lens_2026.env doc/env/lens_2026_prod.env
   # Edit production values
   ```

2. **Create Test Environment:**
   ```bash
   cp doc/env/lens_2026.env doc/env/lens_2026_test.env
   # Edit test values
   ```

3. **Use Environment-Specific Files:**
   ```bash
   source doc/env/lens_2026_prod.env
   ./scripts/start-services.sh start
   ```

---

## 2026-02-25: Nacos Configuration Verification and Completion

### Overview
Verified and completed all Nacos configurations for the 4 platform services (gateway, auth, system, monitor), ensuring they are correct, complete, and synchronized with backup files.

### Issues Found and Fixed

1. **Missing Gateway Configuration**
   - Gateway configuration was not in Nacos
   - Created complete gateway configuration with routing rules

2. **Incomplete Service Configurations**
   - Auth, System, Monitor were missing OpenAPI and Keycloak settings
   - These settings are required by OpenAPIConfig.java in each service

3. **Upload Script Incomplete**
   - Script didn't include gateway service
   - Updated to upload all 4 platform services

### Changes Made

**Created:**
- `/doc/nacos-backup/lens-platform-gateway.yaml` - Complete gateway configuration with routes

**Modified:**
- `/doc/nacos-backup/lens-platform-auth.yaml` - Added OpenAPI and Keycloak config
- `/doc/nacos-backup/lens-platform-system.yaml` - Added OpenAPI and Keycloak config
- `/doc/nacos-backup/lens-platform-monitor.yaml` - Added OpenAPI config
- `/doc/nacos-backup/upload-all-configs.sh` - Now uploads all 4 services

**Uploaded to Nacos:**
- ✅ lens-platform-gateway.yaml (port 8050)
- ✅ lens-platform-auth.yaml (port 8041)
- ✅ lens-platform-system.yaml (port 8042)
- ✅ lens-platform-monitor.yaml (port 8043)

### Configuration Summary

| Service | Port | JWT Security | Key Features |
|---------|------|--------------|--------------|
| Gateway | 8050 | No (delegates) | Routes, load balancing, gateway actuator |
| Auth | 8041 | Yes (jwk-set-uri) | JWT validation, OpenAPI, Keycloak |
| System | 8042 | Yes (jwk-set-uri) | JWT validation, OpenAPI, Keycloak |
| Monitor | 8043 | No (public) | Spring Boot Admin, all actuator endpoints |

### Gateway Configuration Highlights

**Routes Configured:**
- `/auth/**` → lens-platform-auth (lb://lens-platform-auth)
- `/system/**` → lens-platform-system (lb://lens-platform-system)
- `/monitor/**` → lens-platform-monitor (lb://lens-platform-monitor)

**Features:**
- Load balancing with Nacos service discovery
- Path prefix stripping
- Gateway-specific actuator endpoints

### Common Configuration Elements

**All Services:**
- Logging: INFO (root), DEBUG (com.lens)
- Actuator: health, metrics, prometheus
- OpenAPI: service title, version, and URL

**Secured Services (Auth, System):**
- JWT: `spring.security.oauth2.resourceserver.jwt.jwk-set-uri`
- Keycloak: URL and realm configuration
- Security logging enabled

### Verification

All configurations verified as:
- ✅ Complete with all required properties
- ✅ Uploaded to Nacos (namespace: lens_2026, group: DEFAULT_GROUP)
- ✅ Synchronized with backup files in `/doc/nacos-backup/`
- ✅ Ready for service startup

### Upload Command

```bash
cd /home/zhenac/my/lens_2026/doc/nacos-backup
./upload-all-configs.sh
```

---

## 2026-02-25: Fixed lens-platform-system and lens-platform-monitor Startup Issues

### Overview
Fixed the JWT decoder configuration issue that prevented `lens-platform-system` and `lens-platform-monitor` from starting due to Keycloak connection attempts at startup.

### Problem
Both services were failing to start with error:
```
Unable to resolve the Configuration with the provided Issuer of "http://localhost:8080/realms/lens"
Caused by: java.net.ConnectException: 连接被拒绝
```

The issue was that `SecurityConfig` was using `NimbusJwtDecoder.withIssuerLocation()` which attempts to connect to Keycloak at application startup to fetch OIDC configuration.

### Solution
1. **Updated lens-platform-system SecurityConfig**
   - Changed from `withIssuerLocation(issuerUri)` to `withJwkSetUri(jwkSetUri)`
   - Changed property from `spring.security.oauth2.resourceserver.jwt.issuer-uri` to `spring.security.oauth2.resourceserver.jwt.jwk-set-uri`
   - This approach avoids connecting to Keycloak during startup

2. **Created Nacos Configuration Files**
   - Created `/doc/nacos-backup/lens-platform-system.yaml` with JWT configuration
   - Created `/doc/nacos-backup/lens-platform-monitor.yaml` (no security configuration needed)
   - Both configured with proper namespace `lens_2026` and group `DEFAULT_GROUP`

3. **Created Upload Automation Script**
   - Created `/doc/nacos-backup/upload-all-configs.sh` to upload all platform service configs
   - Supports lens-platform-auth, lens-platform-system, and lens-platform-monitor
   - Color-coded output for better visibility

### Changes Made

**Modified:**
- `/platform/lens-platform-system/src/main/java/com/lens/platform/system/config/security/SecurityConfig.java`
  - Changed JWT decoder to use JWK Set URI instead of issuer location

**Created:**
- `/doc/nacos-backup/lens-platform-system.yaml` - Nacos config for system service
- `/doc/nacos-backup/lens-platform-monitor.yaml` - Nacos config for monitor service  
- `/doc/nacos-backup/upload-all-configs.sh` - Script to upload all configs
- `/doc/TROUBLESHOOTING.md` - Comprehensive troubleshooting guide

### Configuration Details

**lens-platform-system.yaml:**
```yaml
server:
  port: 8042
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          jwk-set-uri: http://localhost:8080/realms/lens/protocol/openid-connect/certs
```

**lens-platform-monitor.yaml:**
```yaml
server:
  port: 8043
spring:
  boot:
    admin:
      context-path: /admin
```

### Key Differences: withIssuerLocation vs withJwkSetUri

**withIssuerLocation (OLD - causes startup issues):**
- Connects to Keycloak at startup
- Fetches `.well-known/openid-configuration`
- Fails if Keycloak is not running
- Used with property: `spring.security.oauth2.resourceserver.jwt.issuer-uri`

**withJwkSetUri (NEW - recommended):**
- Lazy loading - only connects when JWT validation is needed
- Uses JWK Set URI directly
- Application starts even if Keycloak is down
- Used with property: `spring.security.oauth2.resourceserver.jwt.jwk-set-uri`

### Upload Configurations to Nacos

```bash
cd /home/zhenac/my/lens_2026/doc/nacos-backup
./upload-all-configs.sh
```

### Verification

All configurations successfully uploaded to Nacos:
- ✅ lens-platform-auth.yaml
- ✅ lens-platform-system.yaml  
- ✅ lens-platform-monitor.yaml

Services can now start successfully without requiring Keycloak to be running.

---

## 2026-02-25: Documentation Directory Reorganization

### Overview
Created `doc/` directory to centralize project history and Nacos configuration backup files, while keeping README.md in the root directory for easy access.

### Changes Made

**Created:**
- `/doc/` - Documentation directory for history and backups

**Moved:**
- `/HISTORY.md` → `/doc/HISTORY.md`
- `/nacos-config-examples/` → `/doc/nacos-backup/`

**Kept in Root:**
- `/README.md` - Main project documentation (kept in root for visibility)

### New Project Structure

```
lens_2026/
├── README.md                           # Project overview (root level)
├── doc/
│   ├── HISTORY.md                      # Project history and technical documentation
│   └── nacos-backup/                   # Nacos configuration backup files
│       ├── lens-platform-auth.yaml     # Auth service configuration
│       └── upload-auth-config.sh       # Upload automation script
├── common/                              # Common libraries
├── platform/                            # Platform services
├── infra/                              # Infrastructure services
├── lens-blog/                          # Blog services
└── pom.xml                             # Root POM
```

### Updated Paths

- Main documentation: `/README.md` (root level)
- Project history: `/doc/HISTORY.md`
- Nacos config backups: `/doc/nacos-backup/`
- Upload script: `cd doc/nacos-backup && ./upload-auth-config.sh`

### Benefits
- ✅ README.md easily visible in project root
- ✅ Project history and backups organized in doc/
- ✅ Cleaner root directory
- ✅ Better project organization
- ✅ Follows common conventions (README in root)

---

## 2026-02-25: IDEA Run Configuration Troubleshooting

### Overview
Documented solution for Nacos configuration loading issue when running lens-platform-auth in IntelliJ IDEA.

### Problem
- ✅ Terminal: `mvn spring-boot:run` loads Nacos config correctly
- ❌ IDEA: Shows warning `[Nacos Config] config[dataId=lens-platform-auth.yaml, group=DEFAULT_GROUP] is empty`

### Root Cause
IDEA's Spring Boot run configuration doesn't properly pass the `spring.config.import` parameters from `application.yml` in the same way Maven does.

### Solution: Configure IDEA Run Configuration

**Step 1: Edit Run Configuration**
1. In IDEA: **Run** → **Edit Configurations**
2. Select `LensPlatformAuth` (or create new Spring Boot configuration)

**Step 2: Add Program Arguments**
Add to **Program arguments** field:
```
--spring.config.import=nacos:lens-platform-auth.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true
```

**Step 3: (Optional) Add VM Options for Debugging**
Add to **VM options** field:
```
-Dlogging.level.com.alibaba.cloud.nacos.client=DEBUG
-Dspring.devtools.restart.enabled=false
```

**Step 4: Set Working Directory**
Set **Working directory** to:
```
$MODULE_DIR$
```
Or manually: `/home/zhenac/my/lens_2026/platform/lens-platform-auth`

**Step 5: Apply and Run**
Click **Apply** → **OK** → **Run**

### Verification
After starting, check logs for:
```
[Nacos Config] Load config[dataId=lens-platform-auth.yaml, group=DEFAULT_GROUP] success
```

### Quick Reference: IDEA Run Configuration Template

```
Main class: com.lens.platform.auth.LensPlatformAuth
Working directory: $MODULE_DIR$
Program arguments: --spring.config.import=nacos:lens-platform-auth.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true
VM options: -Dspring.devtools.restart.enabled=false
```

### Why This Happens
- Maven properly processes `application.yml` before starting the app
- IDEA's run configuration may not parse YAML imports the same way
- Explicitly passing as program argument ensures it's loaded first

---

## 2026-02-25: Nacos Configuration Setup and YAML Format Specification

### Overview
Created comprehensive Nacos configuration for lens-platform-auth service with JWT/OAuth2 settings, upload script, and ensured proper YAML format specification to enable syntax highlighting and validation.

### Nacos Configuration Structure
- **Namespace**: `lens_2026`
- **Group**: `DEFAULT_GROUP`
- **Data ID**: `<service-name>.yaml`
- **Format**: `yaml` (IMPORTANT: Not "TEXT")

### Files Created
1. **doc/nacos-backup/lens-platform-auth.yaml** - Complete service configuration
2. **doc/nacos-backup/upload-auth-config.sh** - Automated upload script with `type=yaml`

### Key Configuration Content

```yaml
server:
  port: 8041

spring:
  application:
    name: lens-platform-auth
  security:
    oauth2:
      resourceserver:
        jwt:
          # JWK Set URI for lazy loading - only connects when validating tokens
          jwk-set-uri: http://localhost:8080/realms/lens/protocol/openid-connect/certs

logging:
  level:
    root: INFO
    com.lens: DEBUG
    org.springframework.security: DEBUG

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

### How to Upload Configuration to Nacos

**Method 1: Using Upload Script**
```bash
cd doc/nacos-backup
./upload-auth-config.sh
```

**Method 2: Using curl with YAML format**
```bash
curl -X POST "http://localhost:8848/nacos/v1/cs/configs" \
  --data-urlencode "dataId=lens-platform-auth.yaml" \
  --data-urlencode "group=DEFAULT_GROUP" \
  --data-urlencode "tenant=lens_2026" \
  --data-urlencode "type=yaml" \
  --data-urlencode "content@lens-platform-auth.yaml"
```

**Method 3: Using Nacos Web UI (RECOMMENDED)**
1. Open http://localhost:8848/nacos
2. Login (nacos/nacos)
3. Go to "Configuration Management" → "Configurations"
4. Click "+" to create new configuration
5. Fill in:
   - **Namespace**: `lens_2026`
   - **Data ID**: `lens-platform-auth.yaml`
   - **Group**: `DEFAULT_GROUP`
   - **Format**: **yaml** ⚠️ (Select "yaml" from dropdown, NOT "TEXT")
   - **Content**: Copy from `doc/nacos-backup/lens-platform-auth.yaml`
6. Click "Publish"

### CRITICAL: YAML Format Selection

**⚠️ IMPORTANT**: Always select **"yaml"** as the format type when uploading to Nacos.

**Why this matters:**
- **yaml format**: Syntax highlighting, YAML validation, better editing experience
- **TEXT format**: No syntax highlighting, no validation, harder to debug

**To verify format after upload:**
1. Open Nacos console → Configuration Management
2. Select namespace `lens_2026`
3. Click on `lens-platform-auth.yaml`
4. Verify "Format" field shows **"yaml"** (not "TEXT")

**If it shows "TEXT", fix it:**
1. Click "Edit"
2. Change Format dropdown to "yaml"
3. Click "Publish"

### Verification

After uploading, check application logs when starting lens-platform-auth:
```
[Nacos Config] Load config[dataId=lens-platform-auth.yaml, group=DEFAULT_GROUP] success
```

Or verify via API:
```bash
curl "http://localhost:8848/nacos/v1/cs/configs?dataId=lens-platform-auth.yaml&group=DEFAULT_GROUP&tenant=lens_2026"
```

### Benefits
- ✅ Centralized configuration management
- ✅ Dynamic configuration refresh without restart
- ✅ Proper YAML syntax highlighting in Nacos UI
- ✅ Built-in YAML validation
- ✅ Environment-specific settings without code changes
- ✅ Version control for configurations

---

## 2026-02-25: JWT Security Configuration Fix

### Overview
Fixed JWT decoder startup failure in lens-platform-auth where application was trying to connect to Keycloak during initialization, causing startup failures when Keycloak was not running.

### Problem
The application failed to start with error:
```
Unable to resolve the Configuration with the provided Issuer of "http://localhost:8080/realms/lens"
Caused by: java.net.ConnectException: 连接被拒绝
```

The JwtDecoder was using `NimbusJwtDecoder.withIssuerLocation(issuerUri)` which attempts to connect to Keycloak's OpenID configuration endpoint during bean initialization to validate the issuer. This caused the application to fail startup when Keycloak was not accessible.

### Solution
Changed JwtDecoder configuration to use JWK Set URI directly instead of issuer location:
- **Before**: `NimbusJwtDecoder.withIssuerLocation(issuerUri)` - Connects to Keycloak at startup
- **After**: `NimbusJwtDecoder.withJwkSetUri(jwkSetUri)` - Only connects when validating tokens

### File Changed
- `/platform/lens-platform-auth/src/main/java/com/lens/platform/auth/config/security/SecurityConfig.java`
  - Changed from `spring.security.oauth2.resourceserver.jwt.issuer-uri` 
  - To `spring.security.oauth2.resourceserver.jwt.jwk-set-uri`
  - Updated default value to point directly to the JWK endpoint

### Benefits
1. ✅ Application starts successfully without requiring Keycloak to be running
2. ✅ JWT validation still works when Keycloak is running and tokens are presented
3. ✅ Follows lazy-loading principle - only connects to external services when needed
4. ✅ Better development experience - services can start independently

### Result
```
2026-02-25T10:54:17.697+08:00  INFO 3670664 --- [lens-platform-auth] [           main] c.a.c.n.registry.NacosServiceRegistry    : nacos registry, DEFAULT_GROUP lens-platform-auth 192.168.0.5:8041 register finished
2026-02-25T10:54:17.725+08:00  INFO 3670664 --- [lens-platform-auth] [           main] c.lens.platform.auth.LensPlatformAuth    : Started LensPlatformAuth in 5.288 seconds (process running for 5.804)
```

---

## 2026-02-24: Bootstrap to Application.yml Migration & Configuration Fixes

### Overview
Migrated all platform services from legacy `bootstrap.yml` + `spring-cloud-starter-bootstrap` to modern `application.yml` + `spring.config.import` approach. Fixed critical Nacos configuration loading and JWT security issues.

---

## Change 1: Bootstrap Context Migration

### Problem
- Using deprecated `bootstrap.yml` files
- Required `spring-cloud-starter-bootstrap` dependency
- Needed separate `application.properties` to enable bootstrap context
- Not following Spring Boot 2.4+ recommended practices

### Solution
- Migrated to `spring.config.import` in `application.yml`
- Removed all `bootstrap.yml` files
- Removed `application.properties` files
- Removed `spring-cloud-starter-bootstrap` dependencies

### Services Migrated
1. ✅ lens-platform-gateway
2. ✅ lens-platform-auth
3. ✅ lens-platform-system
4. ✅ lens-platform-monitor

### Files Removed
- `/platform/lens-platform-gateway/src/main/resources/bootstrap.yml`
- `/platform/lens-platform-gateway/src/main/resources/application.properties`
- `/platform/lens-platform-auth/src/main/resources/bootstrap.yml`
- `/platform/lens-platform-system/src/main/resources/bootstrap.yml`

### Files Created/Updated
- `/platform/lens-platform-gateway/src/main/resources/application.yml` (updated)
- `/platform/lens-platform-auth/src/main/resources/application.yml` (created)
- `/platform/lens-platform-system/src/main/resources/application.yml` (updated)
- `/platform/lens-platform-monitor/src/main/resources/application.yml` (created)

### POM Changes
Removed from all three services:
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-bootstrap</artifactId>
</dependency>
```

---

## Change 2: Nacos Config Import Fix (CRITICAL)

### Problem
Services couldn't read configuration from Nacos because `spring.config.import` URL was missing required `namespace` and `group` parameters.

### Root Cause
With `spring.config.import`, the import happens EARLY in the bootstrap phase. URL parameters are parsed immediately, but `spring.cloud.nacos.config.*` properties are read TOO LATE.

### Solution
Added `namespace` and `group` as URL query parameters in the import statement.

**Before (Wrong)**:
```yaml
spring.config.import:
  - nacos:lens-platform-auth.yaml?refresh=true
```

**After (Correct)**:
```yaml
spring.config.import:
  - nacos:lens-platform-auth.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true
```

### Configuration Template
```yaml
server:
  port: 8041  # Default fallback port

spring:
  application:
    name: lens-platform-auth
  config:
    import:
      - nacos:lens-platform-auth.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true
  cloud:
    nacos:
      server-addr: ${nacos:localhost}:8848
      config:
        server-addr: ${nacos:localhost}:8848
        file-extension: yaml
        namespace: lens_2026
        group: DEFAULT_GROUP
        enabled: true
        refresh-enabled: true
      discovery:
        server-addr: ${nacos:localhost}:8848
        namespace: lens_2026
        enabled: true
```

### Key Points
- Must NOT use `optional:` prefix (ensures config loaded before server starts)
- Must include `group=DEFAULT_GROUP` in URL
- Must include `namespace=lens_2026` in URL
- Local `server.port` acts as fallback

---

## Change 3: Port Loading Order Fix

### Problem
Netty server was starting on default port 8080 BEFORE loading `server.port` from Nacos config.

### Solution
1. Removed `optional:` prefix from config import (makes Nacos config mandatory)
2. Added local `server.port` fallback in application.yml

### Configuration Loading Order (Fixed)
1. Load `application.yml` (includes local fallback port)
2. Import Nacos config (BEFORE server initialization)
3. Merge configurations (Nacos overrides local)
4. Start server with correct port from Nacos

### Service Ports
- lens-platform-gateway: 8050
- lens-platform-auth: 8041
- lens-platform-system: 8042
- lens-platform-monitor: 8043

---

## Change 4: Dockerfiles Created

### Files Created
1. `/platform/lens-platform-system/Dockerfile` - Port 8042
2. `/platform/lens-platform-monitor/Dockerfile` - Port 8043

### Dockerfile Template
```dockerfile
FROM openjdk:17.0.2-jdk
MAINTAINER lensson.zhen@gmail.com
ARG JAR_FILE
COPY ${JAR_FILE} /opt/app.jar
ENV DATAPATH /data
VOLUME $DATAPATH
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/opt/app.jar"]
EXPOSE [SERVICE_PORT]
```

---

## Change 5: POM.xml Updates - Nacos Dependencies

### Dependencies Added to All Platform Modules

```xml
<!-- Nacos Config - required to load config from Nacos -->
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
</dependency>

<!-- Nacos Discovery - service registration and discovery -->
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
</dependency>

<!-- spring boot admin client -->
<dependency>
    <groupId>de.codecentric</groupId>
    <artifactId>spring-boot-admin-starter-client</artifactId>
    <version>${spring-boot-admin-starter-client.version}</version>
</dependency>
```

### Build Plugin Updates

Added/Updated in all modules:
```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <executions>
        <execution>
            <goals>
                <goal>repackage</goal>
            </goals>
        </execution>
    </executions>
</plugin>
<plugin>
    <groupId>com.spotify</groupId>
    <artifactId>dockerfile-maven-plugin</artifactId>
    <version>${dockerfile.maven.version}</version>
    <configuration>
        <repository>${docker.image.prefix}/${project.artifactId}</repository>
        <contextDirectory>./</contextDirectory>
        <tag>${project.version}</tag>
        <buildArgs>
            <JAR_FILE>target/${project.build.finalName}.jar</JAR_FILE>
        </buildArgs>
    </configuration>
</plugin>
```

### lens-platform-monitor POM
Created complete POM with all dependencies:
- spring-boot-starter-web
- spring-cloud-starter-alibaba-nacos-config
- spring-cloud-starter-alibaba-nacos-discovery
- spring-boot-admin-starter-client
- spring-boot-starter-actuator
- springdoc-openapi-starter-webmvc-ui
- spring-boot-starter-test

---

## Change 6: JWT Security Configuration Fix

### Problem
Services failed to start with error:
```
APPLICATION FAILED TO START
Required a bean of type 'org.springframework.security.oauth2.jwt.JwtDecoder' that could not be found.
```

### Root Cause
SecurityConfig used `.oauth2ResourceServer().jwt()` but no `JwtDecoder` bean was defined.

### Solution
Added `JwtDecoder` bean to SecurityConfig in both services.

### Code Added

**lens-platform-auth** and **lens-platform-system**:
```java
@Value("${spring.security.oauth2.resourceserver.jwt.issuer-uri:http://localhost:8080/realms/lens}")
private String issuerUri;

@Bean
public JwtDecoder jwtDecoder() {
    return NimbusJwtDecoder.withIssuerLocation(issuerUri).build();
}
```

### Updated Permit List
```java
http.authorizeHttpRequests(auth -> auth
    .requestMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html", "/actuator/**").permitAll()
    .anyRequest().authenticated())
```

### Required Nacos Configuration
Add to each service's Nacos config:
```yaml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: http://localhost:8080/realms/lens
```

---

## Platform Services Matrix

| Service | Port | Nacos Config | Nacos Discovery | Admin Client | Dockerfile | application.yml | JwtDecoder |
|---------|------|:------------:|:---------------:|:------------:|:----------:|:---------------:|:----------:|
| lens-platform-gateway | 8050 | ✅ | ✅ | ✅ | ✅ | ✅ | N/A |
| lens-platform-auth | 8041 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| lens-platform-system | 8042 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| lens-platform-monitor | 8043 | ✅ | ✅ | ✅ | ✅ | ✅ | N/A |

---

## Required Nacos Configurations

In Nacos console (`http://localhost:8848/nacos`):

**Namespace**: `lens_2026`  
**Group**: `DEFAULT_GROUP`

### lens-platform-gateway.yaml
```yaml
server:
  port: 8050
```

### lens-platform-auth.yaml
```yaml
server:
  port: 8041
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: http://localhost:8080/realms/lens
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics
```

### lens-platform-system.yaml
```yaml
server:
  port: 8042
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: http://localhost:8080/realms/lens
```

### lens-platform-monitor.yaml
```yaml
server:
  port: 8043
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

---

## Build & Run Instructions

### Prerequisites
1. Nacos running on `localhost:8848`
2. Keycloak running on `localhost:8080` with realm `lens` (for auth/system services)
3. Configuration exists in Nacos (namespace: `lens_2026`, group: `DEFAULT_GROUP`)

### Build All Platform Services
```bash
cd /home/zhenac/my/lens_2026
mvn clean package -pl platform/lens-platform-gateway,platform/lens-platform-auth,platform/lens-platform-system,platform/lens-platform-monitor -am -DskipTests
```

### Run Services
```bash
# Gateway
cd platform/lens-platform-gateway
mvn spring-boot:run

# Auth (in new terminal)
cd platform/lens-platform-auth
mvn spring-boot:run

# System (in new terminal)
cd platform/lens-platform-system
mvn spring-boot:run

# Monitor (in new terminal)
cd platform/lens-platform-monitor
mvn spring-boot:run
```

### Build Docker Images
```bash
# Gateway
mvn dockerfile:build -pl platform/lens-platform-gateway

# Auth
mvn dockerfile:build -pl platform/lens-platform-auth

# System
mvn dockerfile:build -pl platform/lens-platform-system

# Monitor
mvn dockerfile:build -pl platform/lens-platform-monitor
```

---

## Testing Endpoints

### Gateway (8050)
```bash
curl http://localhost:8050/actuator/health
```

### Auth (8041)
```bash
# Health check
curl http://localhost:8041/actuator/health

# Swagger UI
curl http://localhost:8041/swagger-ui.html

# With JWT token
TOKEN=$(curl -X POST http://localhost:8080/realms/lens/protocol/openid-connect/token \
  -d "client_id=YOUR_CLIENT" \
  -d "client_secret=YOUR_SECRET" \
  -d "grant_type=client_credentials" | jq -r '.access_token')
curl http://localhost:8041/api/endpoint -H "Authorization: Bearer $TOKEN"
```

### System (8042)
```bash
curl http://localhost:8042/actuator/health
```

### Monitor (8043)
```bash
curl http://localhost:8043/actuator/health
```

---

## Troubleshooting

### Service Can't Read Nacos Config
**Symptom**: Missing log line: `Located property source: NacosPropertySource`

**Check**:
1. Verify config import URL includes `group` and `namespace`:
   ```yaml
   spring.config.import: nacos:service-name.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true
   ```
2. Verify Nacos is running: `curl http://localhost:8848/nacos`
3. Verify config exists in Nacos console

### JWT Decoder Error
**Symptom**: `Required a bean of type 'org.springframework.security.oauth2.jwt.JwtDecoder'`

**Check**:
1. Verify Keycloak is running: `curl http://localhost:8080/realms/lens/.well-known/openid-configuration`
2. Verify issuer-uri in Nacos config
3. Check dependencies include `spring-security-oauth2-resource-server` and `spring-security-oauth2-jose`

### Wrong Port Used
**Symptom**: Service starts on 8080 instead of configured port

**Check**:
1. Verify config import does NOT use `optional:` prefix
2. Verify Nacos config includes `server.port`
3. Check logs for successful config loading

---

## Key Learnings

1. **spring.config.import requires URL parameters**: Must include `group` and `namespace` in import URL, not just in `spring.cloud.nacos.config`

2. **No optional: for production**: Using `optional:` allows server to start without Nacos config, bypassing port configuration

3. **JwtDecoder must be explicit**: Even with `oauth2ResourceServer().jwt()`, you must define a `JwtDecoder` bean

4. **Bootstrap context is deprecated**: Use `spring.config.import` instead of `bootstrap.yml` in Spring Boot 2.4+

5. **Local fallbacks are important**: Always provide local `server.port` as fallback even when using Nacos

---

## Files Modified Summary

### Configuration Files
- 4 application.yml created/updated
- 4 bootstrap.yml removed
- 1 application.properties removed

### Code Files
- 2 SecurityConfig.java updated (auth, system)

### Docker Files
- 2 Dockerfile created (system, monitor)

### POM Files
- 3 pom.xml updated (auth, system, monitor)

### Documentation
- 1 HISTORY.md created (this file)

---

**Last Updated**: 2026-02-25  
**Spring Boot Version**: 3.2.0  
**Spring Cloud Version**: 2023.0.0  
**Configuration Method**: spring.config.import (modern approach)  
**Status**: ✅ All platform services configured and ready

---

## 2026-02-25: Placeholder Resolution Fix & POM Naming Refactor

### Change 7: Fixed Placeholder Resolution Errors

#### Problem
Application failed to start with error:
```
Could not resolve placeholder 'keycloak.url' in value "${keycloak.url}"
```

Also warning in logs:
```
[Nacos Config] config[dataId=lens-platform-auth.yaml, group=DEFAULT_GROUP] is empty
```

#### Root Cause
1. `@Value` annotations in `OpenAPIConfig` were trying to load properties **before** Nacos config was available
2. No configuration existed in Nacos console for `lens-platform-auth.yaml`

#### Solution
**Step 1**: Added default values to `@Value` annotations
```java
@Value("${keycloak.url:http://localhost:8080}")
String authServerUrl;
@Value("${keycloak.realm:lens}")
String realm;

@Bean
public OpenAPI openAPI(
    @Value("${openapi.service.title:Lens Platform Auth}") String serviceTitle,
    @Value("${openapi.service.version:2.0}") String serviceVersion,
    @Value("${openapi.service.url:http://localhost:8041}") String url) {
```

**Step 2**: Added local fallback properties in `application.yml`
```yaml
# Local fallback configuration (will be overridden by Nacos)
keycloak:
  url: http://localhost:8080
  realm: lens

openapi:
  service:
    title: Lens Platform Auth
    version: "2.0"
    url: http://localhost:8041
```

**Step 3**: CREATE Configuration in Nacos Console

**IMPORTANT**: You must manually create the configuration in Nacos!

### How to Create Nacos Configuration

#### Access Nacos Console
1. Open browser: `http://localhost:8848/nacos`
2. Login with username: `nacos`, password: `nacos`

#### Create Configuration for lens-platform-auth
1. Click **Configuration Management** → **Configurations**
2. Click **+** button to create new configuration
3. Fill in the form:
   - **Data ID**: `lens-platform-auth.yaml`
   - **Group**: `DEFAULT_GROUP`
   - **Configuration Format**: `YAML`
   - **Configuration Content**: (see below)
4. Click **Publish**

#### Nacos Configuration Content for lens-platform-auth.yaml

```yaml
# lens-platform-auth.yaml
# Namespace: lens_2026
# Group: DEFAULT_GROUP

server:
  port: 8041

# Keycloak Configuration
keycloak:
  url: http://localhost:8080
  realm: lens

# OpenAPI Documentation
openapi:
  service:
    title: Lens Platform Auth API
    version: "2.0"
    url: http://localhost:8041

# Spring Security OAuth2
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: http://localhost:8080/realms/lens

# Management Endpoints
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  endpoint:
    health:
      show-details: when-authorized

# Logging
logging:
  level:
    root: INFO
    com.lens: DEBUG
    org.springframework.security: DEBUG
```

#### Create Configurations for Other Services

**lens-platform-gateway.yaml**:
```yaml
server:
  port: 8050

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

**lens-platform-system.yaml**:
```yaml
server:
  port: 8042

keycloak:
  url: http://localhost:8080
  realm: lens

spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: http://localhost:8080/realms/lens

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics
```

**lens-platform-monitor.yaml**:
```yaml
server:
  port: 8043

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

### Verification Steps

After creating Nacos configuration:

1. **Restart the application**
2. **Check logs** for successful config loading:
   ```
   Located property source: NacosPropertySource{name='lens-platform-auth.yaml'}
   ```
3. **No more warnings** about empty config
4. **Application starts** successfully on port 8041

---

### Change 8: POM Naming Refactor

#### Problem
POM.xml files had inconsistent `<name>` elements - some followed directory path convention, others didn't.

#### Solution
Refactored all pom.xml files to use consistent naming: `lens_2026/{module-path}`

#### Files Updated

**Platform modules**:
- ✅ lens-platform-monitor: `lens-platform-monitor` → `lens_2026/platform/lens-platform-monitor`
- ✅ lens-platform-system: `lens_2025/platform/lens-platform-system` → `lens_2026/platform/lens-platform-system` (also fixed year)

**Common modules**:
- ✅ lens-common-base: `lens-common-base` → `lens_2026/common/lens-common-base`
- ✅ lens-common-core: `lens-common-core` → `lens_2026/common/lens-common-core`
- ✅ lens-common-web: `lens-common-web` → `lens_2026/common/lens-common-web`
- ✅ lens-common-redis: `lens-common-redis` → `lens_2026/common/lens-common-redis`
- ✅ lens-common-mariadb: `lens-common-mariadb` → `lens_2026/common/lens-common-mariadb`

**Blog modules**:
- ✅ lens-blog-persistence: `lens-blog-persistence` → `lens_2026/lens-blog/lens-blog-persistence`
- ✅ lens-blog-admin-backend: `lens-blog-admin-backend` → `lens_2026/lens-blog/lens-blog-admin-backend`
- ✅ lens-blog-search: `lens-blog-search` → `lens_2026/lens-blog/lens-blog-search`
- ✅ lens-blog-backend: `lens-blog-backend` → `lens_2026/lens-blog/lens-blog-backend`
- ✅ lens-blog-picture: `lens-blog-picture` → `lens_2026/lens-blog/lens-blog-picture`
- ✅ lens-blog-frontend: `lens-blog-frontend` → `lens_2026/lens-blog/lens-blog-frontend`

#### Naming Convention
All modules now follow the pattern:
```xml
<name>lens_2026/{parent-module}/{module-name}</name>
```

Examples:
- Root: `lens_2026`
- Parent: `lens_2026/platform`
- Module: `lens_2026/platform/lens-platform-auth`

---

## Quick Reference: Starting Services

### Prerequisites Checklist
- [ ] Nacos running on `localhost:8848`
- [ ] Keycloak running on `localhost:8080` with realm `lens`
- [ ] **All configurations created in Nacos** (namespace: `lens_2026`, group: `DEFAULT_GROUP`)

### Start Services
```bash
# Terminal 1 - Gateway
cd /home/zhenac/my/lens_2026/platform/lens-platform-gateway
mvn spring-boot:run

# Terminal 2 - Auth
cd /home/zhenac/my/lens_2026/platform/lens-platform-auth
mvn spring-boot:run

# Terminal 3 - System
cd /home/zhenac/my/lens_2026/platform/lens-platform-system
mvn spring-boot:run

# Terminal 4 - Monitor
cd /home/zhenac/my/lens_2026/platform/lens-platform-monitor
mvn spring-boot:run
```

### Success Indicators
Each service should show:
```
Located property source: NacosPropertySource{name='[service-name].yaml'}
Started [ServiceClass] in X.XXX seconds
Tomcat started on port(s): [PORT] (http)
```

### Common Issues

**Issue**: `config[dataId=xxx.yaml, group=DEFAULT_GROUP] is empty`  
**Fix**: Create the configuration in Nacos console (see "How to Create Nacos Configuration" above)

**Issue**: `Could not resolve placeholder 'xxx' in value "${xxx}"`  
**Fix**: Either add default value in `@Value("${xxx:default}")` or add property to local `application.yml`

**Issue**: Service starts on wrong port  
**Fix**: Verify `server.port` is set in Nacos configuration

**Issue**: IDEA doesn't load Nacos config
**Fix**: 
1. Ensure configuration exists in Nacos (namespace: `lens_2026`, Data ID: `lens-platform-auth.yaml`)
2. Add VM options in IDEA Run Configuration for debug logging (see `IDEA_VM_OPTIONS.txt`)
3. Verify local fallback properties exist in `application.yml`
4. See detailed guide: `/platform/lens-platform-auth/IDEA_SETUP.md`

---

## Files Created for IDEA Support

### lens-platform-auth Module
- `/platform/lens-platform-auth/IDEA_VM_OPTIONS.txt` - VM options for IDEA Run Configuration
- `/platform/lens-platform-auth/IDEA_SETUP.md` - Complete IDEA setup and troubleshooting guide

### Key Points for IDEA
1. **Nacos config must exist** before starting application in IDEA
2. **Add debug logging** via VM options to see what's happening
3. **Local fallback properties** in `application.yml` prevent startup failures
4. **Namespace must match**: Use `lens_2026` (check namespace ID in Nacos console)

---

## 2026-02-25: IDEA-Specific Nacos Config Loading Fix

### Change 9: Fixed IDEA Spring Boot Run Configuration Issue

#### Problem Identified
- ✅ **Terminal works**: `mvn spring-boot:run` loads Nacos config successfully
  ```
  [Nacos Config] Load config[dataId=lens-platform-auth.yaml, group=DEFAULT_GROUP] success
  ```
- ❌ **IDEA fails**: Shows "config is empty" warning with same application.yml

#### Root Cause
IntelliJ IDEA's Spring Boot run configuration handles `spring.config.import` differently than Maven due to:
1. Different classpath construction
2. IDEA's Spring Boot DevTools may interfere
3. Configuration property resolution order
4. Working directory differences

#### Solution: Add Program Arguments in IDEA

**Step-by-Step Fix:**

1. **Open Run Configuration**:
   - Run → Edit Configurations
   - Select `LensPlatformAuth` (or create new Spring Boot configuration)

2. **Add Program Arguments**:
   ```
   --spring.config.import=nacos:lens-platform-auth.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true
   ```

3. **Optional: Add VM Options for Debug Logging**:
   ```
   -Dlogging.level.com.alibaba.cloud.nacos.client=DEBUG
   -Dspring.devtools.restart.enabled=false
   ```

4. **Set Working Directory**:
   - Working directory: `$MODULE_DIR$`

5. **Apply and Restart**

#### Alternative: Use Maven Goal in IDEA

Create a Maven run configuration instead:
1. Run → Edit Configurations → + → Maven
2. Working directory: `/home/zhenac/my/lens_2026/platform/lens-platform-auth`
3. Command line: `spring-boot:run`
4. This runs exactly like terminal

#### Recommended IDEA Run Configuration

```
Configuration Name: LensPlatformAuth
Type: Spring Boot
Main class: com.lens.platform.auth.LensPlatformAuth
Module: lens-platform-auth
Working directory: $MODULE_DIR$

Program arguments:
--spring.config.import=nacos:lens-platform-auth.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true

VM options:
-Dlogging.level.com.alibaba.cloud.nacos.client=DEBUG
-Dspring.devtools.restart.enabled=false

Environment variables: (empty or nacos=localhost if needed)
```

#### Verification

After applying fix, IDEA logs should match terminal:
```
✅ [Nacos Config] Load config[dataId=lens-platform-auth.yaml, group=DEFAULT_GROUP] success
✅ Located property source: NacosPropertySource{name='lens-platform-auth.yaml'}
✅ Started LensPlatformAuth
```

#### Why This Works

Adding `--spring.config.import` as a program argument ensures it's processed at the highest priority level, before IDEA's internal configuration handling. This bypasses IDEA's classpath differences.

#### Apply to All Services

Use the same fix for other platform services:
- lens-platform-gateway: `--spring.config.import=nacos:lens-platform-gateway.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true`
- lens-platform-system: `--spring.config.import=nacos:lens-platform-system.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true`
- lens-platform-monitor: `--spring.config.import=nacos:lens-platform-monitor.yaml?group=DEFAULT_GROUP&namespace=lens_2026&refresh=true`

---

**Last Updated**: 2026-02-25  
**Total Changes**: 9 major refactorings  
**Status**: ✅ All services ready, IDEA configuration issue resolved
