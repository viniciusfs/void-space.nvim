# Changelog

## [0.3.0] - 2026-05-09

### New Features

- **Kitty terminal theme** — `extras/void-space-kitty.conf` added, ANSI color mapping
  aligned with the existing Alacritty and Terminator themes.

- **Palette sync** (`make sync`) — new `scripts/sync_palette.py` script regenerates all
  terminal extras (`alacritty`, `terminator`, `tmux`, `kitty`), `palette_default.svg`, and
  `void_space_logo.svg` directly from `palette.lua`. Run `make sync` after any palette
  change to keep all assets in sync automatically.

### Bug Fixes

#### Transparent mode — background leaks fixed across plugins

Plugins that were ignoring `opts.transparent` and rendering a solid background in
transparent configurations are now corrected:

- `render-markdown.nvim` — headings and code blocks
- `mini.nvim` — diff, picker, statusline, tabline
- `trouble.nvim` — preview pane
- `snacks.nvim` — picker input and input widget
- `noice.nvim` — `NoiceMini` background
- `neo-tree` — tab bar inactive groups
- `gitsigns.nvim` — line number groups

#### Color and option correctness

- `telescope.nvim` — prompt pane now uses transparent-aware `bg_float`
- `bufferline.nvim` — hardcoded italic replaced with `opts.italic_keywords`
- `cmp.nvim` — hardcoded italic and misused `c.red` replaced in kind icon groups
- `gitsigns.nvim` — blame line now respects `opts.italic_comments`
- `notify.nvim` — INFO severity groups corrected to `c.info` (cyan)
- `trouble.nvim` — info/hint icon colors corrected
- `mini.nvim` — hint/info severity colors corrected
- `lazy.nvim` — `LazyH1` linked to `LazyButtonActive` (was duplicate spec)
- `legacy` — `javaScriptNumber` and `javaScriptNull` use `c.constant` instead of `c.red`

#### Core highlights

- `@property` aligned with `@variable.member` color decision
- `lsp` inlay hint italic now respects the `opts` system
- `treesitter` semantic color assignments corrected
- `syntax` `Exception` color inconsistency with treesitter resolved

### Internal

- Plugin highlight modules moved to `highlights/plugins/` subdirectory. No user-facing
  impact — require paths are internal to the plugin.

## [0.2.0] - 2026-04-08

### Performance

- **Disk cache for colorscheme loading** — subsequent loads now take ~0.3–0.8ms instead
  of ~3–5ms. On first load (or after a config change) the full theme is computed and
  saved to `~/.cache/nvim/void-space/<key>.lua`. All following loads read the pre-built
  file directly, skipping all module requires and theme computation.

- Cache is automatically invalidated when any config option changes (`variant`,
  `transparent`, `italic_comments`, `italic_keywords`, `dim_inactive`). Old cache files
  are not deleted automatically — run `:VoidSpaceClearCache` to purge them.

### New commands

- `:VoidSpaceClearCache` — removes all cached highlight files and forces regeneration on
  the next load. Run this after updating the plugin to pick up new highlight groups.

## [0.1.0] - 2026-04-06

### Initial public release

**void-space.nvim** is a dark Neovim colorscheme with a soft, low-saturation palette
inspired by the deep space aesthetic. Colors are derived from HSL — hue is fixed per
semantic role, only lightness varies for variants.

#### Included

- **Default palette** — 15 HSL-derived colors with a neutral blue-gray background stack
  (`bg_dark` → `bg` → `bg_float` → `sel` → `fg_dim` → `fg`) and accent colors for
  syntax, diagnostics, and UI elements.

- **25 highlight modules** covering:
  - Core editor: `editor`, `syntax`, `treesitter`, `lsp`, `diagnostics`
  - Plugins: `bufferline`, `cmp`, `dashboard`, `fidget`, `flash`, `gitsigns`,
    `illuminate`, `indent`, `lazy`, `mini`, `neo_tree`, `noice`, `notify`,
    `render_markdown`, `snacks`, `telescope`, `todo_comments`, `trouble`, `which_key`
  - Legacy syntax groups: CSS, HTML, JavaScript, Ruby, git commit

- **Terminal extras** (synchronized with the default palette):
  - Alacritty (`extras/void-space-alacritty.toml`)
  - tmux (`extras/void-space-tmux.conf`)
  - Terminator (`extras/void-space-terminator.conf`)

- **Lualine integration** — theme available at `lua/lualine/themes/void-space.lua`

#### Notes

- The `nebula` palette variant exists in the codebase and is usable, but it is not
  actively maintained and is not documented in the README at this time.
