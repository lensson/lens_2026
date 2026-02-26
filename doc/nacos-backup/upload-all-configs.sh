#!/bin/bash
# Script to upload all platform service configurations to Nacos
# Usage: ./upload-all-configs.sh

NACOS_SERVER="http://localhost:8848"
NAMESPACE="lens_2026"
GROUP="DEFAULT_GROUP"
FORMAT="yaml"

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

upload_config() {
    local SERVICE_NAME=$1
    local DATA_ID="${SERVICE_NAME}.yaml"
    local CONFIG_FILE="${SERVICE_NAME}.yaml"

    echo -e "${YELLOW}Uploading configuration for $SERVICE_NAME...${NC}"
    echo "  Namespace: $NAMESPACE"
    echo "  Group: $GROUP"
    echo "  Data ID: $DATA_ID"
    echo "  Format: $FORMAT"
    echo ""

    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}❌ Configuration file $CONFIG_FILE not found${NC}"
        echo ""
        return 1
    fi

    RESPONSE=$(curl -X POST "$NACOS_SERVER/nacos/v1/cs/configs" \
      --data-urlencode "dataId=$DATA_ID" \
      --data-urlencode "group=$GROUP" \
      --data-urlencode "tenant=$NAMESPACE" \
      --data-urlencode "type=$FORMAT" \
      --data-urlencode "content@$CONFIG_FILE" \
      -w "\nHTTP_CODE:%{http_code}" 2>/dev/null)

    HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d: -f2)
    BODY=$(echo "$RESPONSE" | grep -v "HTTP_CODE:")

    if [ "$BODY" = "true" ] || [ "$HTTP_CODE" = "200" ]; then
        echo -e "${GREEN}✅ Configuration uploaded successfully for $SERVICE_NAME${NC}"
        echo ""
    else
        echo -e "${RED}❌ Failed to upload configuration for $SERVICE_NAME${NC}"
        echo "Response: $BODY"
        echo "HTTP Status Code: $HTTP_CODE"
        echo ""
        return 1
    fi
}

echo "=========================================="
echo "Uploading Platform Service Configurations"
echo "=========================================="
echo ""

# Upload configurations
upload_config "lens-platform-gateway"
upload_config "lens-platform-auth"
upload_config "lens-platform-system"
upload_config "lens-platform-monitor"

echo "=========================================="
echo "Upload Complete"
echo "=========================================="
echo ""
echo "To verify configurations in Nacos, visit:"
echo "  http://localhost:8848/nacos"
echo "  Namespace: $NAMESPACE"
echo "  Group: $GROUP"
