#!/bin/bash

# Upload lens-migration-backend configuration to Nacos

NACOS_SERVER="localhost:8848"
DATA_ID="lens-migration-backend.yaml"
GROUP="DEFAULT_GROUP"
TENANT="lens_2026"
CONFIG_FILE="/home/zhenac/my/lens_2026/doc/nacos-backup/lens-migration-backend.yaml"

echo "================================================"
echo "Uploading lens-migration-backend configuration"
echo "================================================"
echo ""
echo "Nacos Server: $NACOS_SERVER"
echo "Data ID: $DATA_ID"
echo "Group: $GROUP"
echo "Tenant: $TENANT"
echo "Config File: $CONFIG_FILE"
echo ""

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: Config file not found: $CONFIG_FILE"
    exit 1
fi

echo "File size: $(wc -c < "$CONFIG_FILE") bytes"
echo ""
echo "Uploading..."

RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "http://${NACOS_SERVER}/nacos/v1/cs/configs" \
  -d "dataId=${DATA_ID}" \
  -d "group=${GROUP}" \
  -d "tenant=${TENANT}" \
  -d "type=yaml" \
  --data-urlencode "content@${CONFIG_FILE}")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

echo ""
echo "Response: $BODY"
echo "HTTP Code: $HTTP_CODE"
echo ""

if [ "$BODY" = "true" ] || [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Configuration uploaded successfully!"
    echo ""
    echo "Verify in Nacos console:"
    echo "  URL: http://${NACOS_SERVER}/nacos"
    echo "  Namespace: $TENANT"
    echo "  Data ID: $DATA_ID"
    echo "  Group: $GROUP"
else
    echo "❌ Upload may have failed."
    echo "Please check manually in Nacos console."
fi

echo ""
echo "================================================"
