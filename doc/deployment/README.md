# Deployment and Service Management Scripts

This directory contains scripts for managing Lens platform services.

## Files

### Scripts (`scripts/`)

- **`start-services.sh`** - Service management script
  - Start/stop/restart services
  - Individual or all services
  - PID management
  - Status checking
  - Automatically loads environment variables

## Commands

### Start Services

```bash
# Start all services
./scripts/start-services.sh start

# Start specific service
./scripts/start-services.sh start lens-platform-gateway
./scripts/start-services.sh start lens-platform-auth
./scripts/start-services.sh start lens-platform-system
./scripts/start-services.sh start lens-platform-monitor
```

### Stop Services

```bash
# Stop all services
./scripts/start-services.sh stop

# Stop specific service
./scripts/start-services.sh stop lens-platform-gateway
```

### Restart Services

```bash
# Restart all services
./scripts/start-services.sh restart

# Restart specific service
./scripts/start-services.sh restart lens-platform-auth
```

### Check Status

```bash
# Check status of all services
./scripts/start-services.sh status

# Show environment variables
./scripts/start-services.sh env
```

## Environment Configuration

The start script automatically loads environment variables from:
- `/conf/env/lens_2026.env`

Ensure this file exists and contains proper configuration before starting services.

## Service Ports

Default service ports (configurable via environment):

- **Gateway**: 8050
- **Auth**: 8041
- **System**: 8042
- **Monitor**: 8043

## Prerequisites

Before starting services:

1. **Infrastructure services must be running:**
   - Nacos (port 8848)
   - Keycloak (port 28080)
   - MariaDB (port 33306)
   - Redis (port 6379)

2. **Upload configurations to Nacos:**
   ```bash
   cd ../nacos-backup
   ./upload-all-configs.sh
   ```

3. **Load environment:**
   ```bash
   source ../env/lens_2026.env
   ```

## Service Management

### Manual Start (Alternative)

```bash
# Using Maven
cd /home/zhenac/my/lens_2026/platform/lens-platform-gateway
mvn spring-boot:run

# Using Java
java -jar target/lens-platform-gateway-2.0.0-SNAPSHOT.jar
```

### Logs

Service logs are typically in:
- Console output (when using start-services.sh)
- Application logs directory (if configured)
- Check with: `./scripts/start-services.sh status`

## Troubleshooting

### Port Already in Use

```bash
# Find process using port
lsof -i :8050

# Kill process
kill -9 <PID>

# Or change port in environment
export GATEWAY_PORT=9050
```

### Service Won't Start

1. Check if Nacos is running:
   ```bash
   curl http://localhost:8848/nacos/v1/console/health/readiness
   ```

2. Verify configuration in Nacos:
   ```bash
   curl "http://localhost:8848/nacos/v1/cs/configs?dataId=lens-platform-gateway.yaml&group=DEFAULT_GROUP&tenant=lens_2026"
   ```

3. Check environment variables:
   ```bash
   ./scripts/start-services.sh env
   ```

## See Also

- `/doc/env/` - Environment configuration
- `/doc/nacos-backup/` - Nacos configuration management
- `/README.md` - Main project documentation
