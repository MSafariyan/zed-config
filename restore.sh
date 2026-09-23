#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="$HOME/zed-backup"
EXT_SRC="$BACKUP_DIR/extensions"
CFG_SRC="$BACKUP_DIR/config"

if [[ "$OSTYPE" == "darwin"* ]]; then
  EXT_DEST="$HOME/Library/Application Support/Zed/extensions/installed"
  CFG_DEST="$HOME/.config/zed"
else
  EXT_DEST="${XDG_DATA_HOME:-$HOME/.local/share}/zed/extensions/installed"
  CFG_DEST="${XDG_CONFIG_HOME:-$HOME/.config}/zed"
fi

echo "Restoring to: $EXT_DEST"

mkdir -p "$EXT_DEST" "$CFG_DEST"

rsync -av "$EXT_SRC"/ "$EXT_DEST"/
cp "$CFG_SRC/settings.json" "$CFG_DEST/settings.json" 2>/dev/null || true
cp "$CFG_SRC/keymap.json" "$CFG_DEST/keymap.json" 2>/dev/null || true

echo "Restore complete. Restart Zed."
