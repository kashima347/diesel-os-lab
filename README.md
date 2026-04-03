# Diesel OS Lab

**Technology & Gaming Platform**  
**Plataforma de Tecnologia e Games**  
**Plateforme de technologie et de gaming**

---

## Português

### O que é o Diesel OS Lab

O **Diesel OS Lab** é o laboratório principal de evolução de um sistema baseado em **NixOS**, com foco em:

- desktop premium
- gaming
- performance
- identidade visual própria
- restore confiável
- futura ISO personalizada

Este repositório concentra a configuração principal da máquina, as decisões técnicas do projeto, a documentação e a base da futura ISO.

### Baseline atual validada

A combinação atualmente validada na máquina principal **hal** e adotada como referência para a futura ISO é:

- **Kernel:** `6.18.13-zen1`
- **Driver NVIDIA:** `595.58.03`
- **NVIDIA power management:** `hardware.nvidia.powerManagement.enable = false`

### Estrutura principal do repositório

- **Configuração ativa da máquina hal:** `nixos-machines/hal/`
- **Notas técnicas e decisões:** `docs/notes/`
- **Guia de restore da máquina hal:** `docs/restore/hal-restore-pt-en-fr.md`

### Objetivo do projeto

O objetivo do projeto é construir uma base NixOS refinada, estável, visualmente forte e preparada para:

- uso diário
- jogos
- testes locais
- futura distribuição própria / ISO personalizada

### Restore e reinstalação

Para reinstalações futuras da máquina **hal**, siga o guia oficial de restore:

`docs/restore/hal-restore-pt-en-fr.md`

### Observações importantes

- os arquivos da máquina **hal** permanecem na branch **main**
- a pasta `docs/` concentra explicações, histórico técnico e guias
- a baseline atual foi validada na prática e deve ser tratada como referência até novo teste superior

---

## English

### What Diesel OS Lab is

**Diesel OS Lab** is the main development lab for a **NixOS-based** system focused on:

- premium desktop experience
- gaming
- performance
- custom visual identity
- reliable restore workflow
- future custom ISO

This repository centralizes the main machine configuration, technical decisions, project documentation and the foundation of the future ISO.

### Current validated baseline

The combination currently validated on the main **hal** machine and adopted as the reference for the future ISO is:

- **Kernel:** `6.18.13-zen1`
- **NVIDIA driver:** `595.58.03`
- **NVIDIA power management:** `hardware.nvidia.powerManagement.enable = false`

### Main repository structure

- **Active configuration of the hal machine:** `nixos-machines/hal/`
- **Technical notes and decisions:** `docs/notes/`
- **Restore guide for the hal machine:** `docs/restore/hal-restore-pt-en-fr.md`

### Project goal

The goal of the project is to build a refined, stable, visually strong NixOS base prepared for:

- daily use
- gaming
- local testing
- a future custom distribution / ISO

### Restore and reinstallation

For future reinstalls of the **hal** machine, follow the official restore guide:

`docs/restore/hal-restore-pt-en-fr.md`

### Important notes

- the **hal** machine files remain in the **main** branch
- the `docs/` directory centralizes explanations, technical history and guides
- the current baseline has been validated in practice and should be treated as the main reference until a better one is proven

---

## Français

### Qu’est-ce que Diesel OS Lab

**Diesel OS Lab** est le laboratoire principal de développement d’un système basé sur **NixOS**, avec un accent sur :

- une expérience desktop premium
- le gaming
- la performance
- une identité visuelle propre
- un flux de restauration fiable
- une future ISO personnalisée

Ce dépôt centralise la configuration principale de la machine, les décisions techniques, la documentation du projet et la base de la future ISO.

### Base actuellement validée

La combinaison actuellement validée sur la machine principale **hal** et adoptée comme référence pour la future ISO est :

- **Noyau :** `6.18.13-zen1`
- **Pilote NVIDIA :** `595.58.03`
- **Gestion d’alimentation NVIDIA :** `hardware.nvidia.powerManagement.enable = false`

### Structure principale du dépôt

- **Configuration active de la machine hal :** `nixos-machines/hal/`
- **Notes techniques et décisions :** `docs/notes/`
- **Guide de restauration de la machine hal :** `docs/restore/hal-restore-pt-en-fr.md`

### Objectif du projet

L’objectif du projet est de construire une base NixOS raffinée, stable, visuellement forte et préparée pour :

- l’usage quotidien
- le gaming
- les tests locaux
- une future distribution / ISO personnalisée

### Restauration et réinstallation

Pour les futures réinstallations de la machine **hal**, suivre le guide officiel de restauration :

`docs/restore/hal-restore-pt-en-fr.md`

### Remarques importantes

- les fichiers de la machine **hal** restent dans la branche **main**
- le dossier `docs/` centralise les explications, l’historique technique et les guides
- la base actuelle a été validée en pratique et doit être traitée comme référence principale jusqu’à preuve d’une meilleure combinaison

---

## Current status / Estado atual / État actuel

- validated desktop baseline
- machine configuration tracked in repository
- restore workflow documented
- project documentation available in three languages
- future ISO planned from the validated baseline

---

## Reference machine / Máquina de referência / Machine de référence

**Host:** `hal`  
**Project name:** `diesel-os-lab`

---

## Notes / Notas / Notes

For technical observations and milestone records, see:

`docs/notes/`

For restore instructions, see:

`docs/restore/hal-restore-pt-en-fr.md`
