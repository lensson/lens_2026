#!/bin/bash
# Script to upload lens-platform-auth configuration to Nacos
# Usage: ./upload-auth-config.sh

NACOS_SERVER="http://localhost:8848"
NAMESPACE="lens_2026"
GROUP="DEFAULT_GROUP"
DATA_ID="lens-platform-auth.yaml"
CONFIG_FILE="lens-platform-auth.yaml"
FORMAT="yaml"

echo "Uploading configuration to Nacos..."
echo "Namespace: $NAMESPACE"
echo "Group: $GROUP"
echo "Data ID: $DATA_ID"
echo "Format: $FORMAT"
echo ""

RESPONSE=$(curl -X POST "$NACOS_SERVER/nacos/v1/cs/configs" \
  --data-urlencode "dataId=$DATA_ID" \
  --data-urlencode "group=$GROUP" \
  --data-urlencode "tenant=$NAMESPACE" \
  --data-urlencode "type=$FORMAT" \
  --data-urlencode "content@$CONFIG_FILE" \
  -w "\nHTTP_CODE:%{http_code}" 2>/dev/null)

HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | grep -v "HTTP_CODE:")

echo "Response: $BODY"
echo "HTTP Status Code: $HTTP_CODE"

if [ "$BODY" = "true" ] || [ "$HTTP_CODE" = "200" ]; then
    echo ""
    echo "✅ Configuration uploaded successfully!"
    echo ""
    echo "Verifying configuration..."
    curl -s "$NACOS_SERVER/nacos/v1/cs/configs?dataId=$DATA_ID&group=$GROUP&tenant=$NAMESPACE" | head -20
else
    echo ""
    echo "❌ Failed to upload configuration"
    echo "Please check if Nacos is running and accessible at $NACOS_SERVER"
fi
