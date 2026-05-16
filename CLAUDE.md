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

Propagate palette changes to `extras/`, `assets/`, and the logo SVG:
```sh
make sync
# or directly:
python3 scripts/sync_palette.py
```

Generate README screenshots (requires `vhs` and JetBrainsMono Nerd Font):
```sh
make screenshots           # plugin screenshots from scripts/screenshots/tapes/
make screenshots-samples   # syntax screenshots for all files in samples/
```

## Architecture

void-space.nvim is a Neovim colorscheme with multi-variant support. The load path is:

1. **`colors/void-space.lua`** — Neovim's colorscheme entry point (invoked by `colorscheme void-space`). Just calls `require('void-space').load()`.
2. **`lua/void-space/init.lua`** — Public API. Exposes `M.setup(opts)` (merges user config) and `M.load()` (applies the theme). Holds the `VoidSpaceConfig` type definition. Config options: `variant`, `italic_comments`, `italic_keywords`, `transparent`, `dim_inactive`, `on_highlights`, `dev` (set `dev = true` to disable disk cache during development).
3. **`lua/void-space/palette.lua`** — Variant router. `M.get(variant)` requires `void-space.palettes.<variant>` and returns the resolved color table. All highlight modules receive this table as `c`.
4. **`lua/void-space/palettes/`** — One file per variant: `default.lua`, `nebula.lua`, `cosmic_dawn.lua`. Each is the single source of truth for that variant's colors. All hex values are derived from HSL — H fixed per semantic role, only L varies for states. Every color used in highlights **must** come from the active palette file.
5. **`lua/void-space/cache.lua`** — Disk cache. On first load the computed highlights table is serialized to `stdpath("cache")/void-space/<key>.lua`. Subsequent loads with the same config skip all module requires and deserialize from disk. Run `:VoidSpaceClearCache` to force regeneration.
6. **`lua/void-space/theme.lua`** — Orchestrator. Iterates over all highlight modules in order (core first, then plugins alphabetically), merges their output into one table, and returns it to `init.lua`.
7. **`lua/void-space/highlights/*.lua`** — Core modules: `editor`, `syntax`, `treesitter`, `lsp`, `diagnostics`. Each exports `M.get(c, opts)` returning a flat `{ GroupName = spec }` table.
8. **`lua/void-space/highlights/plugins/*.lua`** — One file per plugin concern. Same interface as core modules. Also includes `legacy.lua` (CSS, HTML, JS, Ruby, git commit syntax groups), loaded last.
9. **`lua/lualine/themes/`** — Three lualine integration files, one per variant: `void-space.lua` (default), `void-space-nebula.lua`, `void-space-cosmic-dawn.lua`. Loaded automatically by lualine when the matching `theme` name is set.

### Highlight modules (load order)

Core (first):
- `editor`, `syntax`, `treesitter`, `lsp`, `diagnostics`

Plugins (alphabetical, under `highlights/plugins/`):
- `bufferline`, `cmp`, `dashboard`, `fidget`, `flash`, `gitsigns`, `illuminate`, `indent`, `lazy`, `mini`, `neo_tree`, `noice`, `notify`, `render_markdown`, `snacks`, `telescope`, `todo_comments`, `trouble`, `which_key`

Legacy (last, also under `highlights/plugins/`):
- `legacy` — CSS, HTML, JS, Ruby, git commit syntax groups

### Key constraints enforced by tests

- Every highlight spec must only use keys from: `fg`, `bg`, `sp`, `bold`, `italic`, `underline`, `undercurl`, `strikethrough`, `reverse`, `nocombine`, `link`.
- Specs using `link` must have **only** the `link` key — no mixed attributes.
- All `fg`/`bg`/`sp` values must be palette colors or `c.none` ("NONE") — no hardcoded hex strings outside `palettes/`.
- No two highlight modules may define the same group name.

### Adding support for a new plugin

1. Create `lua/void-space/highlights/plugins/<plugin_name>.lua` with a `M.get(c, opts)` function.
2. Register the module in the `MODULES` list in `lua/void-space/theme.lua`.
3. The spec tests in `spec/highlights_spec.lua` automatically pick up and validate any module listed there.

### Adding a new palette variant

1. Create `lua/void-space/palettes/<variant_name>.lua` (copy an existing one as starting point).
2. Create `lua/lualine/themes/void-space-<variant_name>.lua` referencing the new palette.
3. Register the variant name in `spec/lualine_spec.lua`'s `THEMES` table.
4. Add templates for `extras/` files if the variant should have terminal theme files.

## Test suite

| File | What it covers |
|------|---------------|
| `spec/palette_spec.lua` | Palette structure, required keys, hex format, gray aliases |
| `spec/highlights_spec.lua` | All highlight modules: valid keys, no hardcoded hex, link-only constraint, no duplicate group names |
| `spec/theme_spec.lua` | Orchestrator merging logic |
| `spec/cache_spec.lua` | Cache key generation, serialize/deserialize round-trip, clear |
| `spec/init_spec.lua` | Public API (`setup`, `load`) |
| `spec/opts_spec.lua` | User config option handling |
| `spec/lualine_spec.lua` | All three lualine themes: required modes, sections, valid hex values |

## Repository layout

```
lua/void-space/
  init.lua            # Public API + VoidSpaceConfig type
  palette.lua         # Variant router → palettes/<variant>.lua
  palettes/           # default.lua, nebula.lua, cosmic_dawn.lua
  cache.lua           # Disk cache (stdpath cache/void-space/)
  theme.lua           # Highlight orchestrator (MODULES list)
  highlights/         # Core modules: editor, syntax, treesitter, lsp, diagnostics
    plugins/          # Plugin + legacy modules
lua/lualine/themes/   # void-space.lua, void-space-nebula.lua, void-space-cosmic-dawn.lua

spec/                 # Busted test suite
samples/              # Syntax sample files used for screenshot generation
scripts/
  gen_swatch.py       # Generates SVG palette swatches → assets/swatches/
  sync_palette.py     # Propagates palette → extras/, assets/, logo SVG
  templates/          # *.tmpl files rendered by sync_palette.py → extras/
  screenshots/        # VHS tapes + nvim config for screenshot generation
extras/               # Terminal themes (alacritty, kitty, terminator, tmux)
assets/               # Logo, palette SVGs, screenshots
docs/
  PALETTE.md          # Source of truth for visual identity — HSL principles, semantic colors, variant guide
  ROADMAP.md          # Epics and tasks backlog
  HIGHLIGHTS.md       # Highlight group documentation / acceptance criteria
  superpowers/
    specs/            # Design specs approved before implementation
    plans/            # Step-by-step implementation plans
.worktrees/           # Active git worktrees (light-theme, nebula) — do not delete
```

## Palette design principles

Colors are defined by HSL — H (hue) is fixed per semantic role, only L (lightness) varies for hover/selection/dim variants. Saturation stays between ~19–55% for a soft aesthetic. Background stack uses H≈219°, S≈21%, only L changes across `bg_dark` → `bg` → `bg_float` → `sel` → `fg_dim` → `fg`.

When modifying or extending a palette, run `make sync` afterward to propagate hex values to terminal theme files and SVG assets.
