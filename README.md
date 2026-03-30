# nixos-config-clean

Backup e base de restore da configuração do NixOS da máquina **hal**.

Este repositório guarda os arquivos principais de configuração do sistema, o backup visual do GNOME e serve como referência para reinstalação, recuperação e sincronização da máquina.

---

# Estrutura do repositório

```text
nixos-config-clean/
└── nixos-machines/
    └── hal/
        ├── configuration.nix
        ├── hardware-configuration.nix
        └── dconf-backup.ini
