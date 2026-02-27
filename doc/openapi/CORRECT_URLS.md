# Correct Swagger UI URLs

## ✅ Verified Correct URLs

### Gateway's Own Swagger UI

**Recommended URL (use this!):**
```
http://localhost:8050/swagger-ui/index.html
```

**Why this URL?**
- ✅ Direct access to Swagger UI page
- ✅ Consistent with backend services URL pattern
- ✅ No redirect, loads immediately
- ✅ Canonical URL for all services

**Alternative URL (also works):**
```
http://localhost:8050/swagger-ui.html
```

**Why not recommended?**
- ⚠️ This is a redirect (302) to `/swagger-ui/index.html`
- ⚠️ Different pattern than backend services
- ⚠️ Less consistent across the platform

**Both URLs work** because Springdoc automatically creates both:
- `/swagger-ui.html` → 302 redirect → `/swagger-ui/index.html`
- `/swagger-ui/index.html` → 200 OK (actual page)

**For consistency:** Always use `/swagger-ui/index.html`

### Auth Service via Gateway
```
http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html
```

### System Service via Gateway
```
http://localhost:8050/v2/lens/platform/system/swagger-ui/index.html
```

### Monitor Service via Gateway
```
http://localhost:8050/v2/lens/platform/monitor/actuator
```

## Direct Service Access (Not via Gateway)

### Auth Service Direct
```
http://localhost:8041/swagger-ui/index.html
```

### System Service Direct
```
http://localhost:8042/swagger-ui/index.html
```

### Gateway Direct
```
http://localhost:8050/swagger-ui/index.html
```

## Configuration Note

### Gateway Springdoc Configuration

The gateway's Springdoc is configured with:
```yaml
springdoc:
  swagger-ui:
    path: /swagger-ui  # Directory path (not .html file)
```

This configuration means:
- `/swagger-ui/` → serves `index.html` automatically
- `/swagger-ui/index.html` → direct access to Swagger UI
- `/swagger-ui.html` → convenience redirect (may or may not work depending on Spring Boot version)

**Recommended:** Always use `/swagger-ui/index.html` for consistency across all services.

## Important Notes

### URL Format
- ✅ **Correct:** `swagger-ui/index.html`
- ❌ **Incorrect:** `swagger-ui.html` (this is a redirect URL, not the actual Swagger UI page)

### Why index.html?
Springdoc Swagger UI serves the actual UI at `/swagger-ui/index.html`. The path `/swagger-ui.html` is just a convenience redirect that Spring provides, but the actual content is at `/swagger-ui/index.html`.

### OAuth2 Redirect URLs
The OAuth2 redirect URLs in configuration should point to:
```
http://localhost:8050/v2/lens/platform/auth/swagger-ui/oauth2-redirect.html
http://localhost:8050/v2/lens/platform/system/swagger-ui/oauth2-redirect.html
```

## Quick Test

After starting services, verify with:

```bash
# Auth service via gateway
curl -I http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html

# System service via gateway  
curl -I http://localhost:8050/v2/lens/platform/system/swagger-ui/index.html

# Gateway's own
curl -I http://localhost:8050/swagger-ui/index.html

# All should return HTTP 200 OK
```

## Documentation Updates

All documentation files have been updated to use the correct URLs:
- ✅ `/doc/openapi/BEARER_TOKEN_AUTH.md`
- ✅ `/doc/openapi/README.md`
- ⚠️ Other historical docs may still reference old URLs for reference

## Summary

**Always use:** `swagger-ui/index.html` not `swagger-ui.html`

The full path structure is:
- Gateway route: `/v2/lens/platform/{service}/`
- Swagger UI: `swagger-ui/index.html`
- Full URL: `http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html`

**Last Updated:** 2026-02-27
