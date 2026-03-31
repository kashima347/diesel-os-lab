# diesel-os-lab

Laboratório oficial de evolução do meu NixOS.

O **diesel-os-lab** é o repositório onde passam a acontecer todas as novas frentes de desenvolvimento do sistema, com foco em:

- gaming
- desempenho
- branding próprio
- scripts
- automação
- ISO personalizada
- estrutura modular
- experimentação controlada

Este projeto existe para permitir evolução contínua sem comprometer a base estável já validada.

---

# Visão do projeto

A proposta do **diesel-os-lab** é transformar uma configuração pessoal de NixOS em uma base cada vez mais:

- forte para jogos
- organizada
- reproduzível
- automatizada
- visualmente consistente
- preparada para reinstalação
- apta a gerar uma identidade própria de sistema

A visão de longo prazo é construir algo que não seja apenas um “conjunto de arquivos”, mas uma plataforma pessoal de sistema operacional com direção técnica, estética e prática bem definida.

---

# Relação entre os repositórios

## `nixos-config-clean`

O repositório **nixos-config-clean** permanece como:

- base confiável
- referência congelada
- ponto seguro de restore
- backup lógico da configuração validada
- fundação estável do ambiente

Ele não deve ser tratado como laboratório.

## `diesel-os-lab`

O repositório **diesel-os-lab** passa a ser o espaço de:

- evolução nova
- foco gamer
- branding
- scripts
- ISO
- experimentação
- reorganização estrutural
- testes técnicos
- preparação de futuras versões mais completas do sistema

Resumo prático:

- **nixos-config-clean** = base estável
- **diesel-os-lab** = laboratório de evolução

---

# Objetivo principal

Criar uma linha de desenvolvimento do sistema que permita:

- experimentar sem perder segurança
- evoluir sem destruir a base validada
- documentar melhor o que está sendo feito
- automatizar reinstalações e ajustes
- preparar uma configuração cada vez mais próxima de uma distro própria
- centralizar o futuro do projeto em um único repositório de trabalho

---

# Princípios do projeto

O **diesel-os-lab** segue estes princípios:

## 1. Separação entre estável e experimental

Nada importante deve depender apenas do laboratório sem validação.

A base estável continua preservada separadamente.

## 2. Reprodutibilidade

Sempre que possível, as mudanças devem caminhar para:

- configuração declarativa
- scripts previsíveis
- estrutura reaproveitável
- processo claro de rebuild, restore e manutenção

## 3. Evolução controlada

Mudanças novas devem ser feitas com cuidado, preferindo:

- etapas pequenas
- validação antes de aplicar
- organização progressiva
- rollback possível

## 4. Utilidade real

O projeto não existe para ser bonito apenas no papel.

Ele deve melhorar o uso real da máquina, principalmente em:

- jogos
- desempenho
- manutenção
- reinstalação
- clareza operacional

## 5. Identidade própria

O projeto deve ganhar, com o tempo, uma “cara” própria, incluindo:

- nome
- branding
- estrutura
- aparência
- fluxo de uso
- estilo de organização

---

# Escopo atual do diesel-os-lab

Este repositório passa a concentrar os seguintes tipos de trabalho.

## Gaming

- Steam
- Proton
- Proton-GE
- MangoHud
- GameMode
- launch options
- tuning para jogos
- compatibilidade
- automações gamer
- possíveis perfis por jogo
- melhorias de firewall/host para jogos específicos

## Desempenho

- kernel
- ajustes de sistema
- análise de impacto
- configurações de sessão
- serviços
- comportamento gráfico
- validação de estabilidade

## Branding

- identidade visual do projeto
- naming
- organização da futura ISO
- assets
- wallpapers
- aparência do sistema
- ícones
- padronização visual

## Scripts e automação

- backup
- restore
- sincronização
- pós-instalação
- aplicação de ajustes
- preparação de ambiente
- automação de tarefas repetitivas

## Estrutura NixOS

- modularização
- separação por função
- organização por host
- reaproveitamento de blocos
- limpeza de arquitetura
- preparação para flake/ISO e futuras expansões

## ISO personalizada

- build de ISO
- personalização de identidade
- inclusão de componentes relevantes
- caminho de instalação mais reproduzível
- automação de pós-instalação

## Experimentação

- novos módulos
- novos fluxos
- novos pacotes
- novas ideias
- testes de organização
- protótipos técnicos

---

# O que entra aqui

Devem entrar no **diesel-os-lab**:

- toda evolução nova
- todo recurso gamer novo
- branding novo
- scripts novos
- testes de ISO
- reorganização estrutural
- automações ainda em desenvolvimento
- experimentos que ainda não merecem ser promovidos para a base estável

---

# O que continua fora daqui como referência principal

A referência estável e congelada continua sendo o:

- `nixos-config-clean`

Isso significa que o **diesel-os-lab** não apaga a importância do repositório clean.

Ele trabalha em cima da estratégia de segurança dada pela existência do clean.

---

# Estratégia de trabalho

A estratégia do projeto é simples:

## Etapa 1: preservar a base

A base confiável continua protegida no repositório clean.

## Etapa 2: desenvolver no laboratório

Toda nova frente passa a ser construída no diesel-os-lab.

## Etapa 3: validar

Antes de aplicar algo importante no sistema:

- revisar
- comparar
- validar
- testar build quando necessário
- evitar mudanças grandes sem leitura final

## Etapa 4: consolidar o que funcionar

O que se mostrar útil, estável e coerente pode virar parte da linha principal do projeto.

---

# Roadmap inicial

## Curto prazo

- consolidar o README do projeto
- definir a estrutura inicial do repositório
- separar melhor hosts, módulos, scripts e assets
- preparar base para branding
- preparar base para scripts recorrentes
- começar a organizar a futura ISO

## Médio prazo

- modularizar melhor a configuração
- criar scripts práticos de manutenção e restore
- consolidar fluxo gamer
- consolidar fluxo visual/branding
- amadurecer a estrutura do projeto
- preparar builds mais organizados

## Longo prazo

- criar uma identidade completa do sistema
- gerar ISO realmente personalizada
- automatizar melhor reinstalação e pós-instalação
- construir um ambiente pessoal com cara de distro própria
- tornar o laboratório uma base madura de evolução contínua

---

# Estrutura pretendida

A estrutura ainda pode evoluir, mas a direção é algo próximo disso:

```text
diesel-os-lab/
├── README.md
├── flake.nix
├── hosts/
│   ├── hal/
│   └── notebook/
├── modules/
│   ├── core/
│   ├── desktop/
│   ├── gaming/
│   ├── nvidia/
│   ├── branding/
│   ├── services/
│   └── users/
├── scripts/
├── iso/
├── assets/
│   ├── wallpapers/
│   ├── branding/
│   ├── logos/
│   └── images/
└── docs/
