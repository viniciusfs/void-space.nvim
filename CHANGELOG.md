# Changelog

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
