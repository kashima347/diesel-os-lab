#!/usr/bin/env bash
set -euo pipefail

cd ~/diesel-os-lab

echo "==> Limpando link result antigo"
rm -f result

echo "==> Buildando a ISO"
nix --extra-experimental-features "nix-command flakes" build .#nixosConfigurations.iso.config.system.build.isoImage

echo "==> Localizando ISO gerada"
ISO_SOURCE="$(find ~/diesel-os-lab/result/iso -maxdepth 1 -type f -name '*.iso' | head -n1)"

if [ -z "${ISO_SOURCE}" ]; then
  echo "ERRO: nenhuma ISO encontrada em ~/diesel-os-lab/result/iso"
  exit 1
fi

TODAY="$(date +%F)"
ISO_TARGET="$HOME/Downloads/diesel-os-lab-${TODAY}.iso"

echo "==> Copiando ISO para Downloads com nome amigável"
cp -f "$ISO_SOURCE" "$ISO_TARGET"

echo
echo "ISO final:"
ls -lh "$ISO_TARGET"
echo
echo "Origem:"
echo "$ISO_SOURCE"
echo
echo "Destino:"
echo "$ISO_TARGET"
