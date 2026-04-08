#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
SCHEMADIR="/run/current-system/sw/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas"
MANGOHUD_DIR="${HOME}/.config/MangoHud"
MANGOHUD_FILE="${MANGOHUD_DIR}/MangoHud.conf"

echo "==> Restaurando configuracao gamer do HAL"

echo "==> Criando configuracao do MangoHud"
mkdir -p "${MANGOHUD_DIR}"

cat > "${MANGOHUD_FILE}" <<'MANGOHUD_EOF'
horizontal
hud_compact
hud_no_margin
position=top-right
font_size=18
font_size_text=18
background_alpha=0.15
alpha=1.0
fps
gpu_stats
gpu_core_clock
gpu_mem_clock
gpu_temp
cpu_stats
cpu_temp
ram
vram
frame_timing=0
MANGOHUD_EOF

echo "==> Ajustando perfil de energia para performance"
if command -v powerprofilesctl >/dev/null 2>&1; then
  powerprofilesctl set performance || true
fi

echo "==> Reaplicando ajustes visuais basicos do GNOME"
if command -v gsettings >/dev/null 2>&1; then
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' || true
  gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' || true
  gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita' || true
  gsettings set org.gnome.desktop.interface icon-theme 'Fluent-dark' || true
  gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']" || true
fi

echo "==> Reaplicando configuracao do Dash to Dock"
if [[ -d "${SCHEMADIR}" ]] && command -v gsettings >/dev/null 2>&1; then
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM' || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock extend-height false || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock dock-fixed false || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock autohide true || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock autohide-in-fullscreen true || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock intellihide true || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock disable-overview-on-startup true || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock require-pressure-to-show false || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock pressure-threshold 0.0 || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock show-trash false || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock show-mounts false || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock isolate-workspaces false || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock click-action 'minimize' || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock scroll-action 'cycle-windows' || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock show-delay 0.0 || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock hide-delay 0.0 || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock animation-time 0.15 || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40 || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED' || true
  gsettings --schemadir "${SCHEMADIR}" set org.gnome.shell.extensions.dash-to-dock background-opacity 0.75 || true
fi

echo "==> Recarregando extensao do Dash to Dock"
if command -v gnome-extensions >/dev/null 2>&1; then
  gnome-extensions disable dash-to-dock@micxgx.gmail.com >/dev/null 2>&1 || true
  gnome-extensions enable dash-to-dock@micxgx.gmail.com >/dev/null 2>&1 || true
fi

echo "==> Restauracao concluida"
echo "Arquivo do MangoHud salvo em: ${MANGOHUD_FILE}"
