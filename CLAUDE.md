# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Plan execution

When executing a plan file (any file under `docs/superpowers/plans/`), mark each step's checkbox in the plan file from `- [ ]` to `- [x]` immediately after completing it. Do not batch updates — update the file after each individual step.

## Commands

Run all tests:
```sh
make test
# or directly:
busted --config-file=.busted
```

Run a single spec file:
```sh
busted --config-file=.busted spec/palette_spec.lua
```

Generate palette color swatches (requires Python 3):
```sh
make swatches
# or directly:
python3 scripts/gen_swatch.py
```

Generate README screenshots (requires `vhs` and JetBrainsMono Nerd Font):
```sh
make screenshots
```

## Architecture

void-space.nvim is a Neovim colorscheme. The load path is:

1. **`colors/void-space.lua`** — Neovim's colorscheme entry point (invoked by `colorscheme void-space`). Just calls `require('void-space').load()`.
2. **`lua/void-space/init.lua`** — Public API. Exposes `M.setup(opts)` (merges user config) and `M.load()` (applies the theme). Holds the `VoidSpaceConfig` type definition.
3. **`lua/void-space/palette.lua`** — Single source of truth for all colors. All hex values are derived from HSL — H fixed per semantic role, only L varies for variants. Every color used in highlights **must** come from this file.
4. **`lua/void-space/theme.lua`** — Orchestrator. Iterates over all highlight modules in order (core first, then plugins alphabetically), merges their output into one table, and returns it to `init.lua`.
5. **`lua/void-space/highlights/*.lua`** — One file per concern. Each must export a single function `M.get(c, opts)` that receives the palette (`c`) and user config (`opts`) and returns a flat table of `{ GroupName = spec }`. No group name may be defined in more than one module.
6. **`lua/lualine/themes/void-space.lua`** — Lualine integration. Loaded automatically by lualine when `theme = 'void-space'` is set. References palette directly.

### Highlight modules (load order)

Core (first):
- `editor`, `syntax`, `treesitter`, `lsp`, `diagnostics`

Plugins (alphabetical):
- `bufferline`, `cmp`, `dashboard`, `fidget`, `flash`, `gitsigns`, `illuminate`, `indent`, `lazy`, `mini`, `neo_tree`, `noice`, `notify`, `render_markdown`, `snacks`, `telescope`, `todo_comments`, `trouble`, `which_key`

Legacy (last):
- `legacy` — CSS, HTML, JS, Ruby, git commit syntax groups

### Key constraints enforced by tests

- Every highlight spec must only use keys from: `fg`, `bg`, `sp`, `bold`, `italic`, `underline`, `undercurl`, `strikethrough`, `reverse`, `nocombine`, `link`.
- Specs using `link` must have **only** the `link` key — no mixed attributes.
- All `fg`/`bg`/`sp` values must be palette colors or `c.none` ("NONE") — no hardcoded hex strings outside `palette.lua`.
- No two highlight modules may define the same group name.

### Planned: highlights directory reorganization (Epic 2, Plan 1)

The `highlights/` directory will be restructured so plugin modules live under `highlights/plugins/`. The 5 core modules (`editor`, `syntax`, `treesitter`, `lsp`, `diagnostics`) stay at the root level. `theme.lua` require paths for plugins will change from `void-space.highlights.<name>` to `void-space.highlights.plugins.<name>`. This is not yet done — see `docs/superpowers/plans/2026-04-12-epic2-plan1-file-reorganization.md`.

### Adding support for a new plugin

1. Create `lua/void-space/highlights/<plugin_name>.lua` with a `M.get(c, opts)` function.
2. Register the module in the `MODULES` list in `lua/void-space/theme.lua`.
3. The spec tests in `spec/highlights_spec.lua` automatically pick up and validate any module listed there.

## Test suite

| File | What it covers |
|------|---------------|
| `spec/palette_spec.lua` | Palette structure, required keys, hex format, gray aliases |
| `spec/highlights_spec.lua` | All highlight modules: valid keys, no hardcoded hex, link-only constraint, no duplicate group names |
| `spec/theme_spec.lua` | Orchestrator merging logic |
| `spec/init_spec.lua` | Public API (`setup`, `load`) |
| `spec/opts_spec.lua` | User config option handling |

## Repository layout

```
lua/void-space/
  init.lua          # Public API
  palette.lua       # Color definitions (HSL-derived hex)
  theme.lua         # Highlight orchestrator (MODULES list)
  highlights/       # One file per plugin/concern
lua/lualine/themes/void-space.lua   # Lualine theme

spec/               # Busted test suite
scripts/
  gen_swatch.py     # Generates SVG palette swatches → assets/swatches/
  screenshots/      # VHS tapes + nvim config for screenshot generation
    tapes/          # .tape files consumed by `make screenshots`
    nvim/           # Isolated nvim config used during screenshot capture
extras/
  void-space-alacritty.toml    # Alacritty terminal theme
  void-space-terminator.conf   # Terminator terminal theme
  void-space-tmux.conf         # tmux theme
assets/
  demo.png / demo2.png         # Demo screenshots for README
  palette_default.svg / palette_default_v2.svg
  void_space_logo.svg
  screenshots/                 # Generated by `make screenshots`
  swatches/                    # Generated by `make swatches`
docs/
  PALETTE.md        # Source of truth for visual identity — HSL principles, semantic colors, variant guide
  ROADMAP.md        # Epics and tasks backlog (Epic 1 done, Epic 2 active, Epic 3 parallel)
  superpowers/
    specs/          # Design specs approved before implementation (one per epic/feature)
    plans/          # Step-by-step implementation plans (generated from specs)
  color-analysis.html  # Interactive HSL analysis tool
```

## Palette design principles

Colors are defined by HSL — H (hue) is fixed per semantic role, only L (lightness) varies for hover/selection/dim variants. Saturation stays between ~19–52% for a soft aesthetic. Background stack uses a fixed H=220, S=22%, only L changes across `bg_dark` → `bg` → `bg_float` → `sel` → `fg_dim` → `fg`.
