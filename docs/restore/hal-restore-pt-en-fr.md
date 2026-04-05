# Restore da máquina hal  
# Restore guide for the hal machine  
# Guide de restauration de la machine hal

---

## Português

### Objetivo

Este guia existe para evitar perda de referência durante reinstalações futuras da máquina **hal**.

A ideia é sempre usar o repositório `diesel-os-lab` como fonte principal de verdade para a configuração da máquina, mantendo também o cuidado de aproveitar o `hardware-configuration.nix` novo gerado pela instalação.

### Arquivos principais

Os arquivos principais da máquina ficam em:

- `nixos-machines/hal/configuration.nix`
- `nixos-machines/hal/hardware-configuration.nix`
- `nixos-machines/hal/dconf-backup.ini`

### Baseline validada

A baseline aprovada até o momento é:

- **Kernel:** `6.18.13-zen1`
- **Driver NVIDIA:** `595.58.03`
- **NVIDIA power management:** `hardware.nvidia.powerManagement.enable = false`

### Fluxo de reinstalação

1. Instalar o NixOS limpo.
2. Entrar no sistema novo.
3. Clonar o repositório:

```bash
git clone git@github.com:kashima347/diesel-os-lab.git
cd ~/diesel-os-lab
