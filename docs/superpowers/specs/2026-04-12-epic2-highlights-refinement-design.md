# Epic 2 — Highlights Refinement: Design Spec

**Date:** 2026-04-12
**Status:** Approved
**Scope:** Tasks 2.1, 2.2, 2.4 (task 2.3 is deferred — plugin review, phased separately)

---

## Overview

Epic 2 produces three sequentially executed plans. Each plan has a concrete output artifact and a clear completion condition.

| Plan | Task | Output artifact | Prerequisite |
|------|------|-----------------|--------------|
| 1 | 2.1 | `highlights/plugins/` directory + updated `theme.lua`, tests passing | — |
| 2 | 2.2 | 5 core modules reviewed (code audit + visual validation) | Plan 1 complete |
| 3 | 2.4 | Inline comments on 5 core modules + `docs/HIGHLIGHTS.md` reference | Plan 2 complete |

Task 2.3 (plugin review) follows later in phased plans grouped by plugin, replicating the work model established by Plans 2 and 3.

---

## Plan 1 — File Structure Reorganization (2.1)

### Objective

Separate plugin highlights from core highlights in the directory structure, with no behavior change.

### Changes

- Create `lua/void-space/highlights/plugins/` and move the 19 plugin files + `legacy` into it. The 5 core modules (`editor`, `syntax`, `treesitter`, `lsp`, `diagnostics`) remain at the root level.
- Update `theme.lua`: plugin require paths change from `void-space.highlights.<name>` to `void-space.highlights.plugins.<name>`.
- Verify and update any references in the test suite (primarily `spec/highlights_spec.lua`).
- Run `make test` to confirm all tests pass.

### Completion condition

Directory structure reflects core vs plugins separation. All tests pass. No behavior change.

---

## Plan 2 — Core Highlights Review (2.2)

### Objective

Ensure the 5 core modules (`editor`, `syntax`, `treesitter`, `lsp`, `diagnostics`) use semantically correct colors from the palette, have no visual noise, and are consistent with each other.

### Modules in scope

`editor`, `syntax`, `treesitter`, `lsp`, `diagnostics`

### Process per module

**Step 1 — Code audit:**
- Is each color the correct semantic color per `PALETTE.md`? (e.g., no `c.fg` where a thematic color should be used, no diagnostic colors applied out of context)
- Are there redundant definitions that should be `link` instead?
- Are there inconsistencies with other core modules (e.g., same concept colored differently across modules)?

**Step 2 — Visual validation checklist:**
- Open a representative file in Neovim and verify each group visually
- Coverage: syntax highlighting, diagnostics, LSP hints/references, diff, search

### Acceptance criteria per module

- All colors sourced from semantic palette (no arbitrary use of `c.fg` where a role-specific color exists)
- Redundant groups correctly linked
- Visual coherence: no highlights that break the theme's identity (no overly bright or jarring choices)

### Completion condition

5 modules audited + visual checklist complete per module. Changes committed.

---

## Plan 3 — Documentation (2.4)

### Objective

Make each highlight group self-documenting (inline) and create a navigable reference for the full core set.

### Part A — Inline comments (in the 5 core `.lua` files)

- Each logical section gets a header comment describing the role of the groups below (the pattern already exists in `treesitter.lua` with sections like `-- Variables`, `-- Constants`)
- Non-obvious groups get a single-line explanation of the color choice or behavior

### Part B — `docs/HIGHLIGHTS.md` (reference document)

- Structure: one section per core module
- Each section lists the main groups, the color used, and how to validate in Neovim (e.g., "open a `.lua` file, move the cursor over a variable")
- Serves as a template for plugin sections to be added during task 2.3

### Intentional incompleteness

The plugins section in `HIGHLIGHTS.md` is left with an explicit placeholder indicating it will be filled during task 2.3 plugin review plans.

### Completion condition

Inline comments added to all 5 core modules. `docs/HIGHLIGHTS.md` created and committed, covering the 5 core modules. Plugin section has a clear placeholder.

---

## Deferred: Task 2.3 — Plugin Review

Task 2.3 is out of scope for these three plans. It will be executed as phased plans after Plan 3 is complete, with plugins grouped by similarity or theme area. Each phase replicates the work model from Plans 2 and 3: code audit → visual validation → inline comments → `HIGHLIGHTS.md` plugin section filled.

**Plugin files (19 + legacy):**
`bufferline`, `cmp`, `dashboard`, `fidget`, `flash`, `gitsigns`, `illuminate`, `indent`, `lazy`, `mini`, `neo_tree`, `noice`, `notify`, `render_markdown`, `snacks`, `telescope`, `todo_comments`, `trouble`, `which_key`, `legacy`
