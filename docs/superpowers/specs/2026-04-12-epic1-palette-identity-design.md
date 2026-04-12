# Design Spec — Épico 1: Fundação Conceitual

**Data:** 2026-04-12
**Status:** aprovado
**Entregáveis:** `docs/PALETTE.md` (documento único integrando identidade + referência técnica)

---

## Contexto

O Épico 1 do roadmap estabelece a fundação conceitual do void-space.nvim: identidade visual documentada e paleta justificada. Essa fundação desbloqueia o Épico 2 (refinamento sistemático de highlights), pois os critérios de aceite de cada grupo precisam de uma referência de cor e intenção estética.

Hoje o projeto tem:
- `lua/void-space/palettes/default.lua` — paleta principal com cores nomeadas e papéis semânticos
- `lua/void-space/palettes/nebula.lua` — variante experimental, fora do escopo deste épico
- `docs/color-analysis.html` — análise técnica visual (gerada, não narrativa)
- README com tabela de paleta, mas sem identidade ou justificativa de escolhas

O que falta: um documento que explique *por que* o tema tem essa cara.

---

## Identidade do void-space

O void-space não é uma derivação do vim-deep-space. O deep-space é um ponto de partida histórico; as decisões de cor do void-space são tomadas pela intenção estética atual, não por fidelidade ao antecessor.

**Conceito:** espaço profundo com textura de nebulosa. O universo não é um vazio uniforme — é gás ionizado, poeira estelar, gradientes de densidade. As cores refletem isso: têm hue e saturação escolhidos para evocar essa textura sem ser agressivos.

**Mood:** vívido mas sóbrio. Cores que se distinguem entre si com clareza funcional, mas que nunca "gritam". Conforto visual é requisito — o programador passa horas olhando para esse tema.

**Princípio central:** baixo contraste intencional. A hierarquia visual emerge de diferenças de luminosidade e hue, não de choques de valor. Nenhum branco puro, nenhum preto puro.

---

## Abordagem escolhida

**Um único `docs/PALETTE.md` integrado** — o documento começa com identidade e flui para técnica. A justificativa de cada cor está no mesmo lugar que sua especificação HSL. Quem lê aprende o "porquê" antes do "o quê".

Alternativas descartadas:
- Dois documentos separados (IDENTITY.md + PALETTE.md) — risco de divergência
- Identidade no README — o README fica pesado e a justificativa técnica de cor não pertence lá

---

## Estrutura do `docs/PALETTE.md`

### Bloco 1 — Identidade
Prosa em três parágrafos: conceito, mood, princípio central. Sem tabelas. Tom direto.

### Bloco 2 — Princípios HSL
Três regras operacionais documentadas explicitamente:

1. **H fixo por papel semântico** — cada cor tem um hue dono. Azul ~214–220°, roxo ~256°, ciano ~187°, etc. Garante coerência perceptual mesmo quando L muda para variantes.
2. **S contida** — saturação entre ~19% (backgrounds) e ~52% (acentos). Acima: perde sobriedade. Abaixo: perde textura nebulosa.
3. **L como único grau de liberdade para estados** — hover, seleção, dim derivam só de L. H e S não mudam para expressar estado.

### Bloco 3 — Stack de backgrounds
A progressão documentada como sistema, não como lista de cores avulsas:

```
bg_dark   H=220 S=23% L=10%  ← borders, inactive windows
bg        H=219 S=21% L=13%  ← main background
bg_float  H=221 S=21% L=17%  ← cursor line, popups
sel       H=218 S=21% L=25%  ← selection, borders destacados
fg_dim    H=219 S=20% L=47%  ← comments, dimmed text
fg        H=217 S=22% L=67%  ← main foreground, operators
```

A progressão só de L (10→13→17→25→47→67%) é o sistema — um gradiente de profundidade espacial. H e S variam minimamente (~1–2°, ~1–3%) por limitações de nomes CSS disponíveis, não por intenção.

### Bloco 4 — Cores semânticas
Tabela com uma linha de justificativa de hue por cor. Formato:

```
| Chave          | Hex     | HSL                | Nome CSS    | Papéis semânticos        | Justificativa de hue                                              |
|----------------|---------|--------------------|-------------|--------------------------|-------------------------------------------------------------------|
| red            | #c68b8f | H=356 S=34% L=66% | Tapestry    | error, deleted           | H≈0 (vermelho clássico de erro), dessaturado para não agredir     |
| green          | #8fb98c | H=116 S=24% L=64% | Envy        | string, added            | H=116 ancora no verde frio, distinto do amarelo sem competir      |
| yellow         | #b39b64 | H=42  S=34% L=55% | Barley Corn | special, warning         | H=42 âmbar terroso — quente sem ser alaranjado                    |
| blue           | #618bc2 | H=214 S=44% L=57% | Danube      | keyword, builtin         | H=214 alinha com o stack de bg, keywords "pertencem" ao espaço    |
| purple         | #9b88d0 | H=256 S=43% L=67% | Cold Purple | func, hint               | H=256 diferencia função de keyword sem sair da família fria       |
| cyan           | #4ab5c4 | H=187 S=51% L=53% | Pelorous    | type_name, info          | H=187 turquesa frio, distinto do azul (H=214), evoca gás ionizado |
| orange         | #ba8873 | H=18  S=34% L=59% | Medium Wood | constant                 | H=18 quente e terroso, contrasta com a frieza geral               |
| pink           | #cc7dd0 | H=297 S=47% L=65% | Orchid      | match paren, attention   | H=297 magenta suave — alerta sem ser erro                         |
| bright_yellow  | #d5ad75 | H=35  S=53% L=65% | Putty       | emphasis, terminal 11    | L mais alto que yellow — mesmo H, mais brilho para ênfase         |
```

### Bloco 5 — Guia para variantes
Quatro regras para criação de novas paletas:

1. **Chaves obrigatórias** — toda paleta deve exportar: `bg_dark`, `bg`, `bg_float`, `sel`, `fg_dim`, `fg`, `red`, `green`, `yellow`, `blue`, `purple`, `cyan`, `orange`, `pink`, `bright_yellow`, `comment`, `keyword`, `func`, `type_name`, `string_lit`, `constant`, `operator`, `type`, `builtin`, `special`, `error`, `warning`, `info`, `hint`, `none`.
2. **O que pode variar** — H, S, L de qualquer acento; L dos backgrounds (mantendo a progressão de profundidade).
3. **O que não pode** — remover chaves obrigatórias; usar hex hardcoded fora de `palettes/`; quebrar a progressão monotônica do stack de bg.
4. **Como testar** — `make test` deve passar; executar `make swatches` e verificar visualmente a coerência perceptual.

---

## Fora do escopo

- Paleta `nebula` — variante experimental, documentada futuramente como expressão mais intensa da identidade default.
- Highlights individuais — cobertos pelo Épico 2.
- Automatizações de sincronização de paleta — Épico 3.

---

## Critério de conclusão do Épico 1

- [ ] 1.1 concluído: identidade visual documentada (bloco 1 do PALETTE.md)
- [ ] 1.2 concluído: `docs/PALETTE.md` completo, commitado, cobrindo os 5 blocos
- Épico 2 desbloqueado: qualquer decisão de highlight pode ser justificada referenciando este documento
