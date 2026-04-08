#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_CONFIG="${REPO_ROOT}/nixos-machines/hal/configuration.nix"
RESTORE_SCRIPT="${REPO_ROOT}/scripts/restore-hal-gamer-state.sh"

EXPECTED_KERNEL="6.19.9-zen1"
EXPECTED_DRIVER="595.58.03"

current_kernel="$(uname -r 2>/dev/null || true)"
current_driver="$(nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null | head -n 1 | tr -d ' ' || true)"

echo "==> Restore HAL post-install"
echo "==> Kernel atual: ${current_kernel:-desconhecido}"
echo "==> Driver atual: ${current_driver:-desconhecido}"

if [[ ! -f "${TARGET_CONFIG}" ]]; then
  echo "ERRO: configuracao da maquina nao encontrada em: ${TARGET_CONFIG}"
  exit 1
fi

echo "==> Copiando configuration.nix oficial para /etc/nixos/configuration.nix"
sudo cp "${TARGET_CONFIG}" /etc/nixos/configuration.nix

if [[ "${current_kernel}" != "${EXPECTED_KERNEL}" || "${current_driver}" != "${EXPECTED_DRIVER}" ]]; then
  echo "==> Base gamer ainda nao esta ativa"
  echo "==> Aplicando configuracao pinada com nixos-rebuild boot"
  sudo nixos-rebuild -I nixos-config=/etc/nixos/configuration.nix -I nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos boot
  echo
  echo "==> Etapa 1 concluida"
  echo "==> Agora reinicie a maquina e rode este mesmo script novamente:"
  echo "${REPO_ROOT}/scripts/restore-hal-postinstall.sh"
  exit 0
fi

echo "==> Base gamer correta detectada"
echo "==> Rodando restore gamer de usuario"
if [[ -x "${RESTORE_SCRIPT}" ]]; then
  "${RESTORE_SCRIPT}"
else
  echo "ERRO: script de restore gamer nao encontrado/executavel em: ${RESTORE_SCRIPT}"
  exit 1
fi

echo "==> Validando GameMode"
gamemoded -t

echo
echo "==> Restauracao completa"
echo "==> Kernel: ${EXPECTED_KERNEL}"
echo "==> Driver: ${EXPECTED_DRIVER}"
echo "==> MangoHud, Dash to Dock e perfil performance reaplicados"
