# Baseline validada — kernel e driver NVIDIA  
# Validated baseline — kernel and NVIDIA driver  
# Base validée — noyau et pilote NVIDIA

Data / Date / Date : 2026-04-03

---

## Português

### Combinação validada nesta máquina

Após testes práticos no desktop **hal / diesel-os-lab**, a máquina passou a se comportar muito melhor com a seguinte combinação:

- **Kernel:** `6.18.13-zen1`
- **Driver NVIDIA:** `595.58.03`
- **GPU:** NVIDIA GeForce RTX 4060 Ti
- **NVIDIA power management:** `hardware.nvidia.powerManagement.enable = false`

### Resultado observado

A máquina ficou mais estável e se comportando melhor com esta combinação.

Estado final validado:

- kernel carregado corretamente em `6.18.13-zen1`
- driver carregado corretamente em `595.58.03`
- comportamento em idle normalizado
- GPU reduzindo corretamente para estado de repouso (`P8`) e baixo consumo em idle
- combinação aprovada como base técnica atual

### Decisão de projeto

**Esta combinação passa a ser a referência principal também para a ISO do projeto Diesel OS Lab**, salvo novo teste futuro que comprove combinação superior.

### Observação importante

Tentativas anteriores com outras combinações de Zen/driver não entregaram o mesmo comportamento final nesta máquina.

No momento, esta é a baseline considerada confiável para:

- desktop principal
- testes locais
- futura base da ISO

---

## English

### Combination validated on this machine

After practical testing on the **hal / diesel-os-lab** desktop, the machine behaved significantly better with the following combination:

- **Kernel:** `6.18.13-zen1`
- **NVIDIA driver:** `595.58.03`
- **GPU:** NVIDIA GeForce RTX 4060 Ti
- **NVIDIA power management:** `hardware.nvidia.powerManagement.enable = false`

### Observed result

The machine became more stable and behaved better with this combination.

Validated final state:

- kernel successfully loaded as `6.18.13-zen1`
- driver successfully loaded as `595.58.03`
- idle behavior normalized
- GPU correctly dropping to idle power state (`P8`) with low power consumption
- combination approved as the current technical baseline

### Project decision

**This combination now becomes the main reference for the Diesel OS Lab ISO as well**, unless a future test proves a better combination.

### Important note

Previous attempts with other Zen/driver combinations did not deliver the same final behavior on this machine.

At the moment, this is the baseline considered reliable for:

- main desktop
- local testing
- future ISO base

---

## Français

### Combinaison validée sur cette machine

Après des tests pratiques sur le desktop **hal / diesel-os-lab**, la machine s’est comportée bien mieux avec la combinaison suivante :

- **Noyau :** `6.18.13-zen1`
- **Pilote NVIDIA :** `595.58.03`
- **GPU :** NVIDIA GeForce RTX 4060 Ti
- **Gestion d’alimentation NVIDIA :** `hardware.nvidia.powerManagement.enable = false`

### Résultat observé

La machine est devenue plus stable et s’est mieux comportée avec cette combinaison.

État final validé :

- noyau chargé correctement en `6.18.13-zen1`
- pilote chargé correctement en `595.58.03`
- comportement au repos normalisé
- GPU revenant correctement à l’état de repos (`P8`) avec une faible consommation
- combinaison approuvée comme base technique actuelle

### Décision du projet

**Cette combinaison devient également la référence principale pour l’ISO du projet Diesel OS Lab**, sauf si un futur test prouve une combinaison supérieure.

### Remarque importante

Les tentatives précédentes avec d’autres combinaisons Zen/pilote n’ont pas donné le même résultat final sur cette machine.

Pour l’instant, cette base est considérée comme fiable pour :

- le desktop principal
- les tests locaux
- la future base de l’ISO
