# Epic 2 — Task 2.3: Plugin Highlights Review — Design Spec

**Date:** 2026-04-12
**Status:** Approved
**Scope:** Task 2.3 — review all 20 plugin highlight modules

---

## Overview

Task 2.3 reviews all plugin highlight modules for semantic color correctness, link hygiene, transparent path consistency, and italic discipline. Work follows the same model established by Plans 2 and 3 for core modules: code audit → visual validation → inline comments → `HIGHLIGHTS.md` plugin section filled.

The 20 plugins are split into 5 phases of 4 plugins each, ordered by visual prominence. Each phase produces one implementation plan file.

| Plan file | Phase | Plugins |
|-----------|-------|---------|
| `epic2-plan4-plugins-phase1.md` | 1 — Always visible | `bufferline`, `telescope`, `cmp`, `gitsigns` |
| `epic2-plan5-plugins-phase2.md` | 2 — Frequently visible | `neo_tree`, `noice`, `notify`, `snacks` |
| `epic2-plan6-plugins-phase3.md` | 3 — Contextual | `which_key`, `illuminate`, `trouble`, `todo_comments` |
| `epic2-plan7-plugins-phase4.md` | 4 — Support/overlay | `indent`, `flash`, `fidget`, `mini` |
| `epic2-plan8-plugins-phase5.md` | 5 — Peripheral/special | `dashboard`, `lazy`, `render_markdown`, `legacy` |

Plans are generated phase by phase as work progresses. This spec covers design for all phases; each plan file is authored before its phase begins.

---

## Work model per plugin

Each plugin goes through four steps in order:

**Step 1 — Code audit**

Apply the generic checklist (see below) to every group in the file. Identify and fix any issues found.

**Step 2 — Visual validation**

Open Neovim with the theme active and verify the plugin visually. Each plan defines what to open and what to check per plugin.

**Step 3 — Inline comments**

Add section header comments and single-line explanations for non-obvious color choices. Follow the pattern from core modules (e.g., `-- Selected state`).

**Step 4 — `HIGHLIGHTS.md` entry**

Fill the plugin's section in `docs/HIGHLIGHTS.md` following the core module format: group name, palette key(s), and how to validate in Neovim.

---

## Generic audit checklist

Applied to every plugin, in this order:

1. **Semantic colors** — Does each `fg`/`bg`/`sp` use the correct semantic palette role? Common violations:
   - Diagnostic colors (`c.error`, `c.warning`, `c.info`, `c.hint`) used outside diagnostic context
   - Accent colors used for structural UI (borders, separators) instead of `c.sel`
   - `c.red` used for non-error content (e.g., numbers, decorative elements)

2. **Link vs. repetition** — Groups that exactly replicate another group should use `link = "GroupName"` instead of repeating the color spec. Check for groups that are identical to a sibling or to a Neovim built-in.

3. **Transparent path** — Any group with a `bg` field: does it respect `opts.transparent`? The standard pattern is:
   ```lua
   local bg_x = opts.transparent and c.none or c.x
   hl.SomeGroup = { fg = c.fg, bg = bg_x }
   ```
   Groups that hardcode `c.bg`, `c.bg_float`, or `c.bg_dark` as a background without checking transparency are a violation (unless the group is intentionally opaque regardless of the setting).

4. **Italic discipline** — Any `italic = true` must use `opts.italic_comments` or `opts.italic_keywords`. Hardcoded `italic = true` or `italic = false` is a violation.

If an issue cannot be cleanly resolved during the audit (e.g., requires a design decision), document it as a callout in the plan and resolve it before committing.

---

## Known callouts (identified before phase execution)

These issues are already visible from reading the files:

### `telescope.lua`

`TelescopePromptNormal` and `TelescopeResultsNormal` access `bg_float` inconsistently:
- `TelescopeNormal` and `TelescopeResultsNormal` use the local `bg_float` variable (transparent-aware)
- `TelescopePromptNormal` and `TelescopePromptBorder` access `c.bg_float` directly (not transparent-aware)

Fix: use the local `bg_float` variable consistently across all groups, or decide which panels should always be opaque and document the intent.

### `bufferline.lua`

- `BufferLineBufferSelected = { ..., italic = false }` — explicitly setting `italic = false` is unusual. Either remove the key (falsy is the default) or replace with `italic = opts.italic_keywords` if the intent is to follow user preference.
- `BufferLinePickSelected`, `BufferLinePick`, `BufferLinePickVisible` all have `italic = true` hardcoded. Replace with `opts.italic_keywords`.

### `legacy.lua`

`javaScriptNumber = { fg = c.red }` — `c.red` is the error/danger color. Numbers should use `c.constant` (orange), consistent with how `@number` is defined in `treesitter.lua`.

---

## `HIGHLIGHTS.md` format for plugin sections

Each plugin adds a section under `## Plugin modules` following this format:

```markdown
### plugin_name

One-sentence description of what UI surface this plugin covers.

| Group | Color(s) | Validates as |
|-------|----------|--------------|
| `GroupName` | fg: palette_key | What to look for in Neovim |
```

Only document groups that are non-obvious or representative. Skip groups that are pure links or trivially self-explanatory.

---

## Completion condition

Task 2.3 is complete when:
- All 20 plugin files have passed the generic audit checklist
- All known callouts have been resolved
- Visual validation has been performed for each plugin
- Inline comments added to non-obvious sections
- All 20 plugin sections filled in `HIGHLIGHTS.md`
- All changes committed
