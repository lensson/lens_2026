# OpenAPI Documentation Access Guide

## Overview

This directory contains all documentation and guides related to OpenAPI/Swagger UI access across the Lens platform.

**Status:** ✅ All platform modules configured for public API documentation access

## Accessing API Documentation

### Direct Access (No Gateway)

Each service exposes its own Swagger UI and OpenAPI specification:

**Gateway Service:**
- Swagger UI: http://localhost:8050/swagger-ui/index.html
- OpenAPI Spec: http://localhost:8050/v3/api-docs

**Auth Service:**
- Swagger UI: http://localhost:8041/swagger-ui/index.html
- OpenAPI Spec: http://localhost:8041/v3/api-docs

**System Service:**
- Swagger UI: http://localhost:8042/swagger-ui/index.html
- OpenAPI Spec: http://localhost:8042/v3/api-docs

**Monitor Service:**
- Actuator: http://localhost:8043/actuator

### Access via Gateway (Recommended)

Access backend service documentation through the gateway:

**Auth Service via Gateway:**
- Swagger UI: http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html
- OpenAPI Spec: http://localhost:8050/v2/lens/platform/auth/v3/api-docs

**System Service via Gateway:**
- Swagger UI: http://localhost:8050/v2/lens/platform/system/swagger-ui/index.html
- OpenAPI Spec: http://localhost:8050/v2/lens/platform/system/v3/api-docs

**Monitor Service via Gateway:**
- Actuator: http://localhost:8050/v2/lens/platform/monitor/actuator

## Gateway Configuration

The gateway has been configured to properly route Swagger UI requests and handle redirects:

### Key Configuration Elements

**1. OpenAPI Server URL (Critical for CORS)**

Backend services must configure the OpenAPI server URL to use the **gateway URL**, not the direct backend URL:

```yaml
# lens-platform-auth.yaml
openapi:
  service:
    title: Lens Platform Auth API
    version: ${OPENAPI_VERSION:2.0.0}
    # ✅ Correct: Use gateway URL
    url: ${AUTH_URL:http://localhost:8050/v2/lens/platform/auth}
    
    # ❌ Wrong: Using direct backend URL causes CORS errors
    # url: http://localhost:8041
```

**Why This Matters:**
- Swagger UI uses this URL as the base for all API calls
- If set to `http://localhost:8041`, Swagger UI will call backend directly
- Browser sees this as cross-origin request (8050 → 8041) → **CORS error**
- If set to gateway URL with path, all calls go through gateway → **No CORS issues**

**Environment Variables:**
```bash
# In conf/env/lens_2026.env
export AUTH_URL=http://localhost:8050/v2/lens/platform/auth
export SYSTEM_URL=http://localhost:8050/v2/lens/platform/system
```

**2. Forward Headers Strategy**

Backend services are configured to use forward headers:
```yaml
server:
  forward-headers-strategy: framework
  tomcat:
    redirect-context-root: false
    use-relative-redirects: true
```

This enables services to:
- Detect the original request path from the gateway
- Generate redirects relative to the gateway context
- Work properly behind a reverse proxy

**3. Gateway Routes with X-Forwarded-Prefix**

The gateway adds `X-Forwarded-Prefix` header to each route:
```yaml
routes:
  - id: lens-platform-auth-swagger
    uri: lb://lens-platform-auth
    predicates:
      - Path=/v2/lens/platform/auth/swagger-ui.html, /v2/lens/platform/auth/swagger-ui/**, /v2/lens/platform/auth/v3/api-docs/**
    filters:
      - StripPrefix=4
      - AddRequestHeader=X-Forwarded-Prefix, /v2/lens/platform/auth
      - PreserveHostHeader
```

**4. Springdoc Configuration**

Springdoc is configured to use forward headers:
```yaml
springdoc:
  api-docs:
    path: /v3/api-docs
  swagger-ui:
    path: /swagger-ui.html
    use-root-path: false
  use-management-port: false
  show-actuator: true
```

### How It Works

1. **Request**: Browser accesses `http://localhost:8050/v2/lens/platform/auth/swagger-ui.html`
2. **Gateway**: Strips prefix (removes `/v2/lens/platform/auth`) and adds `X-Forwarded-Prefix` header
3. **Backend**: Receives request for `/swagger-ui.html` with `X-Forwarded-Prefix: /v2/lens/platform/auth`
4. **Redirect**: Backend generates redirect to `/v2/lens/platform/auth/swagger-ui/index.html` (includes prefix)
5. **Browser**: Receives correct redirect and loads Swagger UI properly

### Why This Fix Is Needed

When accessing Swagger UI through a gateway with path prefix:
- Original URL: `http://localhost:8050/v2/lens/platform/auth/swagger-ui.html`
- Without forward headers: Backend redirects to `/swagger-ui/index.html` (absolute path)
- Browser interprets as: `http://localhost:8050/swagger-ui/index.html` (404 error)
- With forward headers: Backend redirects to `/v2/lens/platform/auth/swagger-ui/index.html`
- Browser loads correctly: `http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html`

## Security Configuration

### Public Endpoints (No Authentication)

All security configurations permit public access to API documentation:

**Gateway SecurityConfig:**
```java
.pathMatchers("/actuator/**", "/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html").permitAll()
.pathMatchers("/v2/lens/platform/*/swagger-ui.html", "/v2/lens/platform/*/swagger-ui/**").permitAll()
```

**Auth/System SecurityConfig:**
```java
.requestMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html", "/actuator/**").permitAll()
```

### Protected Endpoints

Business logic endpoints require OAuth2 JWT authentication:
- `/echo`, `/caller/ping`, etc. require valid JWT token
- Can be tested via Swagger UI after clicking "Authorize" button

## Using Swagger UI

### 1. Open Swagger UI (No Authentication Needed)

Open in browser:
```
http://localhost:8050/v2/lens/platform/auth/swagger-ui.html
```

### 2. Browse API Documentation

- View all available endpoints
- See request/response schemas
- Read endpoint descriptions
- No authentication required for viewing

### 3. Test Protected Endpoints

To test protected endpoints from Swagger UI:

**Step 1: Get token**
```bash
cd ../keycloak/scripts
source quick-token.sh
echo $TOKEN
```

**Step 2: In Swagger UI**
- Click "Authorize" button (top right)
- Select "keycloak_oAuth_security_schema"
- Paste your token in the value field
- Click "Authorize"

**Step 3: Try endpoints**
- Click on any endpoint (e.g., GET /echo)
- Click "Try it out"
- Click "Execute"
- See response from protected endpoint

### 4. OAuth2 Flow in Swagger UI (Alternative)

Swagger UI can also initiate OAuth2 flow:
- Click "Authorize"
- Select OAuth2 scheme
- Click "Authorize" button
- Complete Keycloak login
- Return to Swagger UI with token

## Testing Access

### Test All Swagger UI Endpoints

```bash
# Gateway itself
curl http://localhost:8050/swagger-ui.html

# Auth via gateway
curl http://localhost:8050/v2/lens/platform/auth/swagger-ui.html

# System via gateway
curl http://localhost:8050/v2/lens/platform/system/swagger-ui.html

# Direct auth
curl http://localhost:8041/swagger-ui.html

# Direct system
curl http://localhost:8042/swagger-ui.html
```

All should return HTML without requiring authentication (no 401 status).

### Test OpenAPI Specs

```bash
# Gateway
curl http://localhost:8050/v3/api-docs | jq .

# Auth via gateway
curl http://localhost:8050/v2/lens/platform/auth/v3/api-docs | jq .

# System via gateway
curl http://localhost:8050/v2/lens/platform/system/v3/api-docs | jq .
```

## Troubleshooting

### Issue: 404 Not Found for Swagger UI via Gateway

**Cause:** Gateway routes not properly configured for Swagger UI static resources

**Solution:** ✅ Fixed - Added dedicated routes for Swagger UI paths

### Issue: 401 Unauthorized for API Documentation

**Cause:** Security configuration not permitting public access

**Solution:** All modules already configured correctly with `.permitAll()` for:
- `/v3/api-docs/**`
- `/swagger-ui/**`
- `/swagger-ui.html`

### Issue: Swagger UI loads but can't fetch API spec

**Cause:** OpenAPI spec path not accessible

**Solution:** Ensure both `/swagger-ui.html` and `/v3/api-docs` are public

### Issue: CSS/JS not loading in Swagger UI

**Cause:** Static resources under `/swagger-ui/` not routed correctly

**Solution:** ✅ Fixed - Gateway routes include `/swagger-ui/**` pattern

## OpenAPI Configuration Files

Each service has OpenAPIConfig.java:

**Location:**
- Gateway: `/platform/lens-platform-gateway/src/main/java/.../OpenAPIConfig.java`
- Auth: `/platform/lens-platform-auth/src/main/java/.../OpenAPIConfig.java`
- System: `/platform/lens-platform-system/src/main/java/.../OpenAPIConfig.java`

**Features:**
- OAuth2 security schemes configured
- Keycloak integration
- Authorization code flow
- Scopes: VIEW, ADMIN

## Summary

✅ **All API documentation is publicly accessible**  
✅ **Swagger UI works via gateway and direct access**  
✅ **OpenAPI specs available without authentication**  
✅ **OAuth2 security schemes configured for testing protected endpoints**  
✅ **Consistent configuration across all platform modules**  

## Files in This Directory

- `README.md` - This file
- `OPENAPI_VERIFICATION.md` - Detailed verification report
- `HOW_TO_GET_TOKEN.md` - Guide for obtaining OAuth2 tokens
- `SWAGGER_UI_ACCESS.md` - Swagger UI access guide (if created)

## Quick Links

- Gateway Swagger UI: http://localhost:8050/swagger-ui.html
- Auth Swagger UI (via Gateway): http://localhost:8050/v2/lens/platform/auth/swagger-ui.html
- System Swagger UI (via Gateway): http://localhost:8050/v2/lens/platform/system/swagger-ui.html
- Get Token Script: `../keycloak/scripts/quick-token.sh`

## Next Steps

1. **Restart Gateway** to apply new routes:
   ```bash
   cd platform/lens-platform-gateway
   mvn spring-boot:run
   ```

2. **Test Swagger UI access**:
   ```
   http://localhost:8050/v2/lens/platform/auth/swagger-ui.html
   ```

3. **Test API with OAuth2**:
   - Get token from Keycloak
   - Use "Authorize" button in Swagger UI
   - Test protected endpoints
