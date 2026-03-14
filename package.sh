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
  -x "$PLUGIN_NAME/.git/*" \
  "$PLUGIN_NAME/.gitignore" \
  "$PLUGIN_NAME/.DS_Store" \
  "$PLUGIN_NAME/__pycache__/*" \
  "$PLUGIN_NAME/*.pyc" \
  "$PLUGIN_NAME/*.zip" \
  "$PLUGIN_NAME/package.sh" \
  "$PLUGIN_NAME/.venv/*" \
  "$PLUGIN_NAME/.vscode/*" \
  "$PLUGIN_NAME/test/*" \
  "$PLUGIN_NAME/Support/*" \
  "$PLUGIN_NAME/Makefile" \
  "$PLUGIN_NAME/pb_tool.cfg" \
  "$PLUGIN_NAME/pyrightconfig.json" \
  "$PLUGIN_NAME/plugin_upload.py" \
  "$PLUGIN_NAME/pylintrc" \
  "$PLUGIN_NAME/help/*" \
  "$PLUGIN_NAME/i18n/*"

echo "Created: $ZIP_FILE"
ls -lh "$ZIP_FILE"
