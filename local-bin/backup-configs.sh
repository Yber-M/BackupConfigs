#!/usr/bin/env bash

set -e

BACKUP_DIR="$HOME/BackupConfigs"

# Sincronizar configs actuales
rsync -a --delete "$HOME/.config/hypr/" "$BACKUP_DIR/hypr/"
rsync -a --delete "$HOME/.config/kitty/" "$BACKUP_DIR/kitty/"
rsync -a --delete "$HOME/.config/waybar/" "$BACKUP_DIR/waybar/"
rsync -a --delete "$HOME/.config/zsh/" "$BACKUP_DIR/zsh/"
rsync -a --delete "$HOME/.config/copyq/" "$BACKUP_DIR/copyq/" 2>/dev/null || true
rsync -a --delete "$HOME/.config/fastfetch/" "$BACKUP_DIR/fastfetch/" 2>/dev/null || true
rsync -a --delete "$HOME/.config/starship/" "$BACKUP_DIR/starship/"
rsync -a --delete "$HOME/.config/fontconfig/" "$BACKUP_DIR/fontconfig/" 2>/dev/null || true
rsync -a --delete "$HOME/.config/rofi/" "$BACKUP_DIR/rofi/" 2>/dev/null || true
rsync -a --delete "$HOME/.config/systemd/user/" "$BACKUP_DIR/systemd-user/" 2>/dev/null || true
rsync -a --delete "$HOME/.local/bin/" "$BACKUP_DIR/local-bin/" 2>/dev/null || true

# Archivos importantes
cp "$HOME/.zshrc" "$BACKUP_DIR/.zshrc" 2>/dev/null || true

mkdir -p "$BACKUP_DIR/sddm"
cp /etc/sddm.conf "$BACKUP_DIR/sddm/sddm.conf" 2>/dev/null || true

cd "$BACKUP_DIR"

git add .

# Si no hay cambios, salir sin error
if git diff --cached --quiet; then
    echo "No hay cambios para respaldar."
    exit 0
fi

git commit -m "Auto backup $(date '+%Y-%m-%d %H:%M')"
git push
