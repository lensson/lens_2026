#!/bin/bash
# Startup script for Lens Platform Services
# This script loads environment variables and starts services

# Get the project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Load environment variables
ENV_FILE="$PROJECT_ROOT/conf/env/lens_2026.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "❌ Error: Environment file not found: $ENV_FILE"
    exit 1
fi

echo "Loading environment from: $ENV_FILE"
source "$ENV_FILE"

# Display loaded configuration
source "$ENV_FILE" --show

# Function to start a service
start_service() {
    local SERVICE_NAME=$1
    local SERVICE_DIR="$PROJECT_ROOT/platform/$SERVICE_NAME"

    if [ ! -d "$SERVICE_DIR" ]; then
        echo "❌ Service directory not found: $SERVICE_DIR"
        return 1
    fi

    echo ""
    echo "=========================================="
    echo "Starting $SERVICE_NAME"
    echo "=========================================="
    cd "$SERVICE_DIR"

    # Start with Maven
    mvn spring-boot:run &

    # Store PID
    echo $! > "/tmp/lens_${SERVICE_NAME}.pid"
    echo "✅ $SERVICE_NAME started (PID: $!)"
}

# Function to stop a service
stop_service() {
    local SERVICE_NAME=$1
    local PID_FILE="/tmp/lens_${SERVICE_NAME}.pid"

    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p $PID > /dev/null 2>&1; then
            echo "Stopping $SERVICE_NAME (PID: $PID)..."
            kill $PID
            rm "$PID_FILE"
            echo "✅ $SERVICE_NAME stopped"
        else
            echo "⚠️  $SERVICE_NAME is not running"
            rm "$PID_FILE"
        fi
    else
        echo "⚠️  No PID file found for $SERVICE_NAME"
    fi
}

# Function to check service status
status_service() {
    local SERVICE_NAME=$1
    local PID_FILE="/tmp/lens_${SERVICE_NAME}.pid"

    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p $PID > /dev/null 2>&1; then
            echo "✅ $SERVICE_NAME is running (PID: $PID)"
        else
            echo "❌ $SERVICE_NAME is not running (stale PID file)"
        fi
    else
        echo "❌ $SERVICE_NAME is not running"
    fi
}

# Main script logic
case "$1" in
    start)
        if [ -z "$2" ]; then
            # Start all services
            start_service "lens-platform-gateway"
            sleep 5
            start_service "lens-platform-auth"
            sleep 5
            start_service "lens-platform-system"
            sleep 5
            start_service "lens-platform-monitor"
        else
            # Start specific service
            start_service "$2"
        fi
        ;;
    stop)
        if [ -z "$2" ]; then
            # Stop all services
            stop_service "lens-platform-monitor"
            stop_service "lens-platform-system"
            stop_service "lens-platform-auth"
            stop_service "lens-platform-gateway"
        else
            # Stop specific service
            stop_service "$2"
        fi
        ;;
    restart)
        $0 stop "$2"
        sleep 3
        $0 start "$2"
        ;;
    status)
        if [ -z "$2" ]; then
            # Check all services
            echo "Platform Services Status:"
            echo "=========================="
            status_service "lens-platform-gateway"
            status_service "lens-platform-auth"
            status_service "lens-platform-system"
            status_service "lens-platform-monitor"
        else
            # Check specific service
            status_service "$2"
        fi
        ;;
    env)
        # Display environment configuration
        source "$ENV_FILE" --show
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|env} [service-name]"
        echo ""
        echo "Commands:"
        echo "  start [service]   - Start all services or specific service"
        echo "  stop [service]    - Stop all services or specific service"
        echo "  restart [service] - Restart all services or specific service"
        echo "  status [service]  - Check status of all services or specific service"
        echo "  env               - Display environment configuration"
        echo ""
        echo "Services:"
        echo "  lens-platform-gateway"
        echo "  lens-platform-auth"
        echo "  lens-platform-system"
        echo "  lens-platform-monitor"
        echo ""
        echo "Examples:"
        echo "  $0 start                           # Start all services"
        echo "  $0 start lens-platform-gateway     # Start gateway only"
        echo "  $0 stop                            # Stop all services"
        echo "  $0 status                          # Check all services"
        echo "  $0 env                             # Display environment"
        exit 1
        ;;
esac
