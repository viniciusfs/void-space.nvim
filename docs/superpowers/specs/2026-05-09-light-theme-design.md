# Light Theme Design: Cosmic Dawn Palette

**Date:** 2026-05-09
**Branch:** experimental/light
**Scope:** Core only — palette file, background switching, inverted-fg fix. No lualine or terminal extras.

---

## Goal

Add a light background variant (`cosmic_dawn`) to void-space.nvim. The palette draws on a cool blue-gray aesthetic: clear morning sky, calm and focused. The existing dark variants (`default`, `nebula`) are unchanged in behavior.

---

## Architecture

### New file: `lua/void-space/palettes/cosmic_dawn.lua`

Follows the same structure as existing palette files. Adds two new fields:

- `M.background = "light"` — read by `init.lua` to set `vim.o.background`
- `M.bg_inverted = M.fg` — a dark color for use as text on colored backgrounds (see Highlight Changes below)

### Changes to existing palettes (`default.lua`, `nebula.lua`)

Add `M.bg_inverted = M.bg` to each. For dark palettes this is a no-op — the value is the same as what highlight groups already used. It makes the semantic intent explicit and ensures `c.bg_inverted` is always available across all palettes.

### Changes to `init.lua`

Replace:
```lua
vim.o.background = "dark"
```

With:
```lua
vim.o.background = palette.background or "dark"
```

This is the only change needed in `init.lua`. All existing dark palettes omit the field (or set it to `"dark"`), so behavior is fully backwards-compatible.

### Changes to `lua/void-space/highlights/editor.lua`

Eight highlight groups currently use `fg = c.bg` or `fg = c.bg_float` as "inverted text" — dark text on a colored background. On a light palette these resolve to a light color, breaking contrast. Each is updated to `fg = c.bg_inverted`:

| Group | Old | New |
|---|---|---|
| `Search` | `fg = c.bg` | `fg = c.bg_inverted` |
| `IncSearch` | `fg = c.bg` | `fg = c.bg_inverted` |
| `Substitute` | `fg = c.bg` | `fg = c.bg_inverted` |
| `DiffAdd` | `fg = c.bg` | `fg = c.bg_inverted` |
| `DiffChange` | `fg = c.bg` | `fg = c.bg_inverted` |
| `DiffDelete` | `fg = c.bg` | `fg = c.bg_inverted` |
| `DiffText` | `fg = c.bg` | `fg = c.bg_inverted` |
| `MatchParen` | `fg = c.bg_float` | `fg = c.bg_inverted` |

`CurSearch` links to `IncSearch` — no change needed.

No other highlight modules require changes. All syntax, treesitter, LSP, diagnostics, and plugin files use palette colors as foregrounds only.

---

## Cosmic Dawn Palette

### Named colors

```lua
local _alice_blue     = "#EEF1F7"  -- bg
local _lavender_mist  = "#E4E8F2"  -- bg_float
local _steel_mist     = "#DDE3EE"  -- bg_dark
local _periwinkle     = "#D0D8E8"  -- sel
local _slate          = "#5A6880"  -- fg_dim
local _dark_indigo    = "#283048"  -- fg / bg_inverted

local _crimson        = "#A02040"  -- red
local _forest         = "#2E7834"  -- green
local _golden         = "#C09010"  -- yellow (★ see note)
local _royal          = "#2850B0"  -- blue
local _teal           = "#1E6888"  -- cyan
local _violet         = "#6040A8"  -- purple
local _rose           = "#983080"  -- pink
local _sienna         = "#8A5020"  -- orange
local _bright_gold    = "#D4A820"  -- bright_yellow
```

### Semantic assignments

```lua
-- Backgrounds & foregrounds
M.bg_dark    = _steel_mist
M.bg         = _alice_blue
M.bg_float   = _lavender_mist
M.sel        = _periwinkle
M.fg_dim     = _slate
M.fg         = _dark_indigo
M.bg_inverted = _dark_indigo
M.background  = "light"

-- Accents
M.red          = _crimson
M.green        = _forest
M.yellow       = _golden
M.blue         = _royal
M.cyan         = _teal
M.purple       = _violet
M.pink         = _rose
M.orange       = _sienna
M.bright_yellow = _bright_gold

-- Syntax roles
M.comment    = M.fg_dim
M.keyword    = M.blue
M.func       = M.purple
M.type_name  = M.cyan
M.string_lit = M.green
M.constant   = M.orange
M.operator   = M.fg
M.type       = M.cyan
M.builtin    = M.purple
M.special    = M.yellow

-- Diagnostics
M.error   = M.red
M.warning = M.yellow
M.info    = M.cyan
M.hint    = M.purple

M.none = "NONE"
```

### Yellow note

Yellow (`#C09010`) is a known light-theme compromise. As syntax fg on `bg (#EEF1F7)` it has ~3:1 contrast (acceptable for secondary syntax groups like `Special`). As `Search` background with `bg_inverted (#283048)` text it achieves ~4:1. Fine-tune the exact value during implementation in Neovim — push darker if syntax readability matters more, brighter if Search visibility matters more.

---

## User Config

```lua
require("void-space").setup({ variant = "cosmic_dawn" })
```

No other config change required. `transparent`, `dim_inactive`, `italic_comments`, `italic_keywords`, and `on_highlights` all work as-is.

---

## Out of Scope

- Lualine theme (`lua/lualine/themes/void-space.lua`) — follow-up
- Terminal extras (`extras/`) — follow-up
- New spec tests for the palette — follow-up
