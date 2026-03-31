# ROADMAP — diesel-os-lab

## Objetivo central

Transformar o `diesel-os-lab` no laboratório principal de evolução do sistema, mantendo o `nixos-config-clean` como base congelada e confiável.

---

## Fase 1 — Fundação do projeto

- consolidar README
- definir estrutura inicial do repositório
- separar hosts, modules, scripts, iso, assets e docs
- registrar a filosofia do projeto
- preparar base para expansão futura

---

## Fase 2 — Organização técnica

- estruturar configuração por módulos
- separar componentes core, desktop, gaming e nvidia
- começar a definir convenções do repositório
- preparar base para flake mais organizada
- planejar reaproveitamento de blocos por máquina

---

## Fase 3 — Linha gamer

- consolidar Steam
- Proton / Proton-GE
- MangoHud
- GameMode
- launch options padronizadas
- possíveis scripts por jogo
- ajustes de firewall/host quando necessário
- foco em desempenho e praticidade

---

## Fase 4 — Branding

- definir identidade visual do projeto
- preparar naming interno
- organizar wallpapers
- organizar logos
- preparar assets para futura ISO
- dar “cara própria” ao sistema

---

## Fase 5 — Scripts e automação

- scripts de backup
- scripts de restore
- scripts pós-instalação
- scripts de aplicação de dconf
- scripts de preparação gamer
- scripts de build e validação
- automação de tarefas recorrentes

---

## Fase 6 — ISO personalizada

- preparar base de build
- estudar estrutura ideal
- incorporar identidade do projeto
- automatizar instalação e pós-instalação
- reduzir trabalho manual em reinstalações

---

## Fase 7 — Consolidação

- validar o que realmente funcionou
- separar o que é experimental do que já virou base madura
- tornar o projeto cada vez mais reproduzível
- transformar o lab em uma plataforma sólida de evolução contínua

---

## Regra principal

- `nixos-config-clean` = base confiável, congelada
- `diesel-os-lab` = evolução, gamer, branding, scripts, ISO e experimentação
