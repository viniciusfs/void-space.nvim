# Epic 1 — Palette Identity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create `docs/PALETTE.md` — a single document integrating void-space's visual identity with its full technical palette reference.

**Architecture:** One Markdown file with five sequential blocks: identity prose → HSL principles → background stack → semantic colors table → variant guide. No code changes — this is a pure documentation task. Source of truth for all decisions is `lua/void-space/palettes/default.lua`.

**Tech Stack:** Markdown, current palette from `lua/void-space/palettes/default.lua`.

---

## File Map

| Action | Path |
|--------|------|
| Create | `docs/PALETTE.md` |
| Modify | `docs/ROADMAP.md` (check off items 1.1 and 1.2) |

---

### Task 1: Create `docs/PALETTE.md` with Block 1 — Identity

**Files:**
- Create: `docs/PALETTE.md`

- [ ] **Step 1: Create the file with the identity block**

Create `docs/PALETTE.md` with this exact content:

```markdown
# void-space palette

> Source of truth for visual identity and color decisions.
> Every highlight group must reference a color from `lua/void-space/palettes/default.lua`.

---

## Identidade

void-space não é uma derivação do vim-deep-space. O deep-space é um ponto de partida histórico; as decisões de cor são tomadas pela intenção estética atual, não por fidelidade ao antecessor.

**Conceito:** espaço profundo com textura de nebulosa. O universo não é um vazio uniforme — é gás ionizado, poeira estelar, gradientes de densidade. As cores refletem isso: têm hue e saturação escolhidos para evocar essa textura sem ser agressivos.

**Mood:** vívido mas sóbrio. Cores que se distinguem entre si com clareza funcional, mas que nunca "gritam". Conforto visual é requisito — o programador passa horas olhando para esse tema.

**Princípio central:** baixo contraste intencional. A hierarquia visual emerge de diferenças de luminosidade e hue, não de choques de valor. Nenhum branco puro, nenhum preto puro.
```

- [ ] **Step 2: Verify the file was created**

```bash
head -20 docs/PALETTE.md
```

Expected: the header and identity prose appear correctly.

- [ ] **Step 3: Commit**

```bash
git add docs/PALETTE.md
git commit -m "docs(palette): add PALETTE.md with identity block"
```

---

### Task 2: Add Block 2 — Princípios HSL

**Files:**
- Modify: `docs/PALETTE.md`

- [ ] **Step 1: Append the HSL principles block**

Append to `docs/PALETTE.md`:

```markdown

---

## Princípios HSL

Todas as cores são especificadas em HSL. Três regras devem ser seguidas em qualquer paleta:

### 1. H fixo por papel semântico

Cada cor tem um hue dono. Azul é sempre ~214–220°, roxo ~256°, ciano ~187°, vermelho ~356°, etc. Mudar o hue de uma cor muda sua identidade — evite isso em variantes.

| Papel       | H aproximado |
|-------------|-------------|
| background  | 218–221°    |
| red         | 356°        |
| green       | 116°        |
| yellow      | 42°         |
| blue        | 214°        |
| purple      | 256°        |
| cyan        | 187°        |
| orange      | 18°         |
| pink        | 297°        |
| bright_yellow | 35°       |

### 2. S contida

Saturação entre **~19% (backgrounds)** e **~52% (acentos)**. Acima disso o tema perde a sobriedade; abaixo perde a textura nebulosa.

### 3. L como único grau de liberdade para estados

Hover, seleção e variantes dim são derivados alterando **apenas L**. H e S não mudam para expressar estado — só lightness varia.
```

- [ ] **Step 2: Verify the section renders correctly**

```bash
grep -n "Princípios HSL" docs/PALETTE.md
```

Expected: line number with the heading found.

- [ ] **Step 3: Commit**

```bash
git add docs/PALETTE.md
git commit -m "docs(palette): add HSL principles block"
```

---

### Task 3: Add Block 3 — Stack de Backgrounds

**Files:**
- Modify: `docs/PALETTE.md`

- [ ] **Step 1: Append the background stack block**

Append to `docs/PALETTE.md`:

```markdown

---

## Stack de backgrounds

Os seis tons do stack usam H≈219° e S≈21% fixos — apenas L muda. A progressão de L (10→67%) é um gradiente de profundidade espacial: da escuridão do void até o foreground legível.

```
bg_dark   #141820  H=220 S=23% L=10%  ← borders, janelas inativas
bg        #1a1f28  H=219 S=21% L=13%  ← background principal
bg_float  #232936  H=221 S=21% L=17%  ← cursor line, popups
sel       #323c4d  H=218 S=21% L=25%  ← seleção, borders em destaque
fg_dim    #5f7090  H=219 S=21% L=47%  ← comentários, texto dimmed
fg        #99a7be  H=217 S=22% L=67%  ← foreground principal, operadores
```

As pequenas variações de H (±2°) e S (±2%) refletem limitações de nomes CSS disponíveis, não intenção — o sistema é um gradiente de L uniforme.
```

- [ ] **Step 2: Verify**

```bash
grep -n "Stack de backgrounds" docs/PALETTE.md
```

Expected: line number with the heading found.

- [ ] **Step 3: Commit**

```bash
git add docs/PALETTE.md
git commit -m "docs(palette): add background stack block"
```

---

### Task 4: Add Block 4 — Cores Semânticas

**Files:**
- Modify: `docs/PALETTE.md`

- [ ] **Step 1: Verify all palette keys before writing**

Cross-check that every key exported from `lua/void-space/palettes/default.lua` is covered in the table you're about to write. Run:

```bash
grep "^M\." lua/void-space/palettes/default.lua | grep -v "= M\." | sed 's/M\.\([^ ]*\).*/\1/'
```

Expected output (these are all the keys that must appear in the table):

```
bg_dark
bg
bg_float
sel
fg_dim
fg
green
yellow
red
purple
blue
cyan
pink
orange
bright_yellow
comment
keyword
func
type_name
string_lit
constant
operator
type
builtin
special
error
warning
info
hint
none
```

Note: `comment`, `keyword`, `func`, etc. are aliases that point to accent colors — the table covers the 15 base colors; aliases are documented as a separate sub-section.

- [ ] **Step 2: Append the semantic colors block**

Append to `docs/PALETTE.md`:

```markdown

---

## Cores semânticas

### Paleta de acentos

| Chave | Hex | HSL | Nome CSS | Papéis semânticos | Justificativa de hue |
|-------|-----|-----|----------|-------------------|----------------------|
| `red` | `#c68b8f` | H=356 S=34% L=66% | Tapestry | `error`, `deleted` | H≈0° (vermelho clássico de erro), dessaturado para não agredir a retina em sessões longas |
| `green` | `#8fb98c` | H=116 S=24% L=64% | Envy | `string_lit`, `added` | H=116° ancora no verde frio — distinto do amarelo sem competir com o cyan |
| `yellow` | `#b39b64` | H=42 S=34% L=55% | Barley Corn | `special`, `warning` | H=42° âmbar terroso — quente sem ser alaranjado, evoca poeira estelar |
| `blue` | `#618bc2` | H=214 S=44% L=57% | Danube | `keyword`, `builtin` | H=214° alinha com o stack de bg — keywords "pertencem" ao espaço, não se destacam agressivamente |
| `purple` | `#9b88d0` | H=256 S=43% L=67% | Cold Purple | `func`, `hint` | H=256° diferencia função de keyword sem sair da família fria; roxo evoca emissão de gás ionizado |
| `cyan` | `#4ab5c4` | H=187 S=51% L=53% | Pelorous | `type_name`, `info` | H=187° turquesa frio, distinto do azul (H=214°) — o acento mais saturado do tema, reservado para tipos |
| `orange` | `#ba8873` | H=18 S=34% L=59% | Medium Wood | `constant` | H=18° quente e terroso — contrasta com a frieza geral, sinaliza valores imutáveis |
| `pink` | `#cc7dd0` | H=297 S=47% L=65% | Orchid | `match paren`, `attention` | H=297° magenta suave — alerta sem ser erro, distingue-se do roxo (H=256°) |
| `bright_yellow` | `#d5ad75` | H=35 S=53% L=65% | Putty | `emphasis`, `terminal_color_11` | Mesmo H que `yellow` (≈35–42°), L mais alto — ênfase dentro da mesma família hue |

### Aliases de sintaxe

Os seguintes aliases apontam para as cores acima. Mudar um alias não cria uma nova cor — reaponta para uma existente.

| Alias | Aponta para | Papel |
|-------|-------------|-------|
| `comment` | `fg_dim` | Comentários |
| `keyword` | `blue` | Palavras-chave, condicionais |
| `func` | `purple` | Funções |
| `type_name` | `cyan` | Nomes de tipo |
| `string_lit` | `green` | Literais de string |
| `constant` | `orange` | Constantes |
| `operator` | `fg` | Operadores |
| `type` | `cyan` | Tipos |
| `builtin` | `purple` | Built-ins |
| `special` | `yellow` | Caracteres especiais |
| `error` | `red` | Erros de diagnóstico |
| `warning` | `yellow` | Avisos de diagnóstico |
| `info` | `cyan` | Informações de diagnóstico |
| `hint` | `purple` | Hints de diagnóstico |
```

- [ ] **Step 3: Verify the table has all 9 accent colors**

```bash
grep -c "^| \`" docs/PALETTE.md
```

Expected: `9` (one row per accent color in the main table; alias rows start differently).

- [ ] **Step 4: Commit**

```bash
git add docs/PALETTE.md
git commit -m "docs(palette): add semantic colors table with hue justifications"
```

---

### Task 5: Add Block 5 — Guia para Variantes

**Files:**
- Modify: `docs/PALETTE.md`

- [ ] **Step 1: Append the variant guide block**

Append to `docs/PALETTE.md`:

```markdown

---

## Guia para variantes

Uma variante é um arquivo em `lua/void-space/palettes/<nome>.lua` que exporta a mesma interface da paleta `default`.

### Chaves obrigatórias

Toda paleta deve exportar exatamente estas chaves (em qualquer ordem):

```lua
-- Backgrounds & Foregrounds
bg_dark, bg, bg_float, sel, fg_dim, fg

-- Acentos
red, green, yellow, blue, purple, cyan, orange, pink, bright_yellow

-- Aliases de sintaxe
comment, keyword, func, type_name, string_lit, constant,
operator, type, builtin, special

-- Diagnósticos
error, warning, info, hint

-- Especial
none  -- deve ser sempre a string "NONE"
```

### O que pode variar

- H, S, L de qualquer acento (mas respeite a intenção semântica — não mude `blue` para H=0°)
- L dos backgrounds (mantenha a progressão monotônica crescente de `bg_dark` → `fg`)

### O que não pode

- Remover chaves obrigatórias
- Usar hex hardcoded fora de `lua/void-space/palettes/` — toda cor deve ser uma variável local primeiro
- Quebrar a progressão de L do stack de backgrounds (cada passo deve ser maior que o anterior)
- Atribuir `none` como qualquer valor diferente de `"NONE"`

### Como testar

```bash
# Testes de estrutura (cobertura de chaves, formato hex, aliases)
make test

# Inspeção visual dos swatches gerados
make swatches
# Abre assets/swatches/<variante>/ e verifica coerência perceptual
```

Os testes em `spec/palette_spec.lua` validam automaticamente: formato hex, chaves obrigatórias e aliases. Um PR de nova variante só está pronto quando `make test` passa com zero falhas.
```

- [ ] **Step 2: Verify the final structure of the document**

```bash
grep "^## " docs/PALETTE.md
```

Expected output:
```
## Identidade
## Princípios HSL
## Stack de backgrounds
## Cores semânticas
## Guia para variantes
```

- [ ] **Step 3: Commit**

```bash
git add docs/PALETTE.md
git commit -m "docs(palette): add variant guide block — PALETTE.md complete"
```

---

### Task 6: Mark Epic 1 complete in ROADMAP.md

**Files:**
- Modify: `docs/ROADMAP.md`

- [ ] **Step 1: Check off items 1.1 and 1.2**

In `docs/ROADMAP.md`, change:

```markdown
- [ ] 1.1 Definir e documentar a identidade visual do tema (conceito, mood, intenção estética)
- [ ] 1.2 Escrever `docs/PALETTE.md` — paleta completa, boas práticas HSL, justificativa de cada cor semântica
```

To:

```markdown
- [x] 1.1 Definir e documentar a identidade visual do tema (conceito, mood, intenção estética)
- [x] 1.2 Escrever `docs/PALETTE.md` — paleta completa, boas práticas HSL, justificativa de cada cor semântica
```

Also update the epic status from `[ACTIVE]` to `[DONE]` and `[BLOCKED by Épico 1]` for Epic 2 to `[ACTIVE]`:

```markdown
## Épico 1 — Fundação conceitual `[DONE]`
```

```markdown
## Épico 2 — Refinamento de highlights `[ACTIVE]`
```

- [ ] **Step 2: Verify**

```bash
grep -E "\[x\]|\[DONE\]|\[ACTIVE\]" docs/ROADMAP.md
```

Expected: items 1.1 and 1.2 marked `[x]`, Épico 1 as `[DONE]`, Épico 2 as `[ACTIVE]`.

- [ ] **Step 3: Commit**

```bash
git add docs/ROADMAP.md
git commit -m "chore: mark Epic 1 complete, unblock Epic 2"
```

---

## Self-Review

**Spec coverage:**
- [x] 1.1 — identidade visual: coberta em Task 1 (Block 1 do PALETTE.md)
- [x] 1.2 — PALETTE.md completo: Blocks 1–5 cobertos nas Tasks 1–5
- [x] HSL boas práticas: Task 2 (Block 2)
- [x] Justificativa de cada cor semântica: Task 4 (Block 4)
- [x] ROADMAP atualizado: Task 6

**Placeholder scan:** nenhum TBD, nenhum "fill in later". Todo conteúdo Markdown está inline nas steps.

**Consistency:** as chaves listadas no Block 5 (Task 5) são exatamente as mesmas derivadas do `default.lua` verificadas em Task 4 Step 1.
