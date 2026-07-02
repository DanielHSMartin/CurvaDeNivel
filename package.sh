#!/bin/bash

PLUGIN_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_NAME="curva_de_nivel"
METADATA="$PLUGIN_DIR/metadata.txt"

VERSION=$(grep -E "^version\s*=" "$METADATA" | head -1 | sed 's/.*=\s*//' | tr -d '[:space:]')

if [ -z "$VERSION" ]; then
  echo "Error: could not read version from metadata.txt"
  exit 1
fi

OUTPUT_DIR="$(dirname "$PLUGIN_DIR")"
ZIP_FILE="$OUTPUT_DIR/${PLUGIN_NAME}_${VERSION}.zip"

cd "$OUTPUT_DIR" || exit 1

zip -r "$ZIP_FILE" "$PLUGIN_NAME" \
  --exclude "$PLUGIN_NAME/.git/*" \
  --exclude "$PLUGIN_NAME/.gitignore" \
  --exclude "$PLUGIN_NAME/__pycache__/*" \
  --exclude "$PLUGIN_NAME/*.pyc" \
  --exclude "$PLUGIN_NAME/scripts/*" \
  --exclude "$PLUGIN_NAME/package.sh"

echo "Created: $ZIP_FILE"
ls -lh "$ZIP_FILE"
