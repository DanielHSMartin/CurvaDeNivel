#!/bin/bash
set -e

PLUGIN_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_NAME="curva_de_nivel"
METADATA="$PLUGIN_DIR/metadata.txt"

VERSION=$(grep -E "^version\s*=" "$METADATA" | head -1 | sed 's/.*=\s*//' | tr -d '[:space:]')

if [ -z "$VERSION" ]; then
  echo "Error: could not read version from metadata.txt"
  exit 1
fi

EXCLUDES=(
  --exclude "$PLUGIN_NAME/.git/*"
  --exclude "$PLUGIN_NAME/.gitignore"
  --exclude "$PLUGIN_NAME/.DS_Store"
  --exclude "$PLUGIN_NAME/__pycache__/*"
  --exclude "$PLUGIN_NAME/*.pyc"
  --exclude "$PLUGIN_NAME/*.zip"
  --exclude "$PLUGIN_NAME/package.sh"
  --exclude "$PLUGIN_NAME/.venv/*"
  --exclude "$PLUGIN_NAME/.vscode/*"
  --exclude "$PLUGIN_NAME/.claude/*"
  --exclude "$PLUGIN_NAME/CLAUDE.md"
  --exclude "$PLUGIN_NAME/scripts/*"
  --exclude "$PLUGIN_NAME/test/*"
  --exclude "$PLUGIN_NAME/Support/*"
  --exclude "$PLUGIN_NAME/Makefile"
  --exclude "$PLUGIN_NAME/pb_tool.cfg"
  --exclude "$PLUGIN_NAME/pyrightconfig.json"
  --exclude "$PLUGIN_NAME/plugin_upload.py"
  --exclude "$PLUGIN_NAME/pylintrc"
  --exclude "$PLUGIN_NAME/help/*"
  --exclude "$PLUGIN_NAME/i18n/*"
)

echo "--- 1/4 Secrets detection ---"
if ! command -v detect-secrets &>/dev/null; then
  echo "Error: detect-secrets not found. Install with: pip install detect-secrets"
  exit 1
fi
SECRETS=$(detect-secrets scan "$PLUGIN_DIR" --exclude-files '\.git/|__pycache__/|test/|scripts/|help/|i18n/' 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print(sum(len(v) for v in d['results'].values()))")
if [ "$SECRETS" != "0" ]; then
  echo "Error: detect-secrets found $SECRETS potential secret(s). Run 'detect-secrets scan \"$PLUGIN_DIR\"' to inspect, mark false positives with '# pragma: allowlist secret'."
  exit 1
fi
echo "OK: no secrets detected."

echo "--- 2/4 metadata.txt parses ---"
python3 -c "
import configparser
c = configparser.ConfigParser()
c.read('$METADATA')
" || { echo "Error: metadata.txt failed to parse (check for a stray unescaped '%')."; exit 1; }
echo "OK: metadata.txt parses cleanly."

echo "--- 3/4 Bandit security scan ---"
if ! command -v bandit &>/dev/null; then
  echo "Error: bandit not found. Install with: pip install bandit"
  exit 1
fi
bandit -r "$PLUGIN_DIR" -x "$PLUGIN_DIR/test/,$PLUGIN_DIR/plugin_upload.py,$PLUGIN_DIR/scripts/" --severity-level medium -q
echo "OK: no Medium/High bandit findings."

OUTPUT_DIR="$(dirname "$PLUGIN_DIR")"
ZIP_FILE="$OUTPUT_DIR/${PLUGIN_NAME}_${VERSION}.zip"
rm -f "$ZIP_FILE"

cd "$OUTPUT_DIR" || exit 1
zip -r "$ZIP_FILE" "$PLUGIN_NAME" "${EXCLUDES[@]}"

echo "--- 4/4 Suspicious files in zip ---"
HIDDEN=$(unzip -Z1 "$ZIP_FILE" | grep -E '(^|/)\.[^/]+$' || true)
if [ -n "$HIDDEN" ]; then
  echo "Error: hidden files ended up in the zip (add them to EXCLUDES in package.sh):"
  echo "$HIDDEN"
  rm -f "$ZIP_FILE"
  exit 1
fi
echo "OK: no hidden files in the zip."

echo "Created: $ZIP_FILE"
ls -lh "$ZIP_FILE"
