#!/usr/bin/env bash
set -euo pipefail

# Dar tiempo a que Wayland/Hyprland terminen de restaurar la sesión.
sleep 2

# Matshell está administrado por systemd --user.
# Si ya está activo, este comando no hace nada.
# Si no está activo, lo inicia.
systemctl --user start matshell.service
