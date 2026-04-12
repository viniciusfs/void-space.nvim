# ROADMAP

void-space.nvim é um trabalho contínuo sem marcos de release fixos. O backlog é organizado em épicos com dependências explícitas — o status de cada épico indica o que pode ser atacado agora.

**Status:** `[ACTIVE]` pode ser trabalhado agora · `[BLOCKED]` aguarda outro épico · `[PARALLEL]` independente, pode andar a qualquer momento

---

## Épico 1 — Fundação conceitual `[DONE]`

Consolida a visão, paleta e identidade do tema. Desbloqueia o Épico 2.

- [x] 1.1 Definir e documentar a identidade visual do tema (conceito, mood, intenção estética)
- [x] 1.2 Escrever `docs/PALETTE.md` — paleta completa, boas práticas HSL, justificativa de cada cor semântica

---

## Épico 2 — Refinamento de highlights `[ACTIVE]`

Revisão sistemática de todos os highlight groups: consistência visual, redução de ruído e documentação. Requer a fundação conceitual do Épico 1 como referência.

- [ ] 2.1 Reorganizar estrutura de arquivos — mover plugins para `highlights/plugins/`, um arquivo por plugin
- [ ] 2.2 Revisar highlights core (`editor`, `syntax`, `treesitter`, `lsp`, `diagnostics`)
- [ ] 2.3 Revisar highlights de cada plugin (19 plugins + `legacy`) — um item por arquivo
- [ ] 2.4 Documentar critério de aceite por grupo: o que o highlight faz e como validar no Neovim

---

## Épico 3 — Tooling `[PARALLEL]`

Automações independentes, sem bloquear nem ser bloqueadas pelos outros épicos.

- [ ] 3.1 Automação de captura de screenshots de demonstração (`make screenshots` via VHS)
- [x] 3.2 Sincronização de alterações na paleta com destinos (`extras/`, `assets/`, logo SVG, docs)
