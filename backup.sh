#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="$HOME/zed-backup"
EXT_DEST="$BACKUP_DIR/extensions"
CFG_DEST="$BACKUP_DIR/config"

if [[ "$OSTYPE" == "darwin"* ]]; then
  EXT_SRC="$HOME/Library/Application Support/Zed/extensions/installed"
  CFG_SRC="$HOME/.config/zed"
else
  EXT_SRC="${XDG_DATA_HOME:-$HOME/.local/share}/zed/extensions/installed"
  CFG_SRC="${XDG_CONFIG_HOME:-$HOME/.config}/zed"
fi

echo "Cleaning broken symlinks in: $EXT_SRC"
find "$EXT_SRC" -xtype l -print -delete

echo "Backing up from: $EXT_SRC"
mkdir -p "$EXT_DEST" "$CFG_DEST"

rsync -avL --delete "$EXT_SRC"/ "$EXT_DEST"/
rsync -avL "$CFG_SRC"/settings.json "$CFG_DEST"/settings.json 2>/dev/null || true
rsync -avL "$CFG_SRC"/keymap.json "$CFG_DEST"/keymap.json 2>/dev/null || true

# Strip any embedded .git dirs so extensions are stored as plain files, not submodules
echo "Stripping embedded .git directories..."
find "$EXT_DEST" -mindepth 1 -maxdepth 3 -type d -name ".git" -print -exec rm -rf {} +

cd "$BACKUP_DIR"
git add -A
git commit -m "Zed backup: $(date '+%Y-%m-%d %H:%M:%S')" || echo "Nothing new to commit"
git push

echo "Backup complete and pushed."
