# Nebula Palette Redesign: Electric Void

**Date:** 2026-05-09
**Branch:** experimental/light (to be ported to a dedicated nebula branch)
**Scope:** Replace `lua/void-space/palettes/nebula.lua` with the Electric Void design.

---

## Goal

Redesign the nebula palette to match its visual reference: rich violet backgrounds, magenta-dominant syntax, electric cyan contrast, and teal-mint strings. Fix three structural problems in the current palette: blue-only backgrounds with no purple character, and the green/cyan/func alias collision (all three point to the same `#78C8F0`).

---

## Inspiration

- `nebulosa.jpg`: near-black purple void, magenta/violet nebula gas, electric cyan-teal highlight, warm orange-red dust
- `jeremy-thomas-4dpAqfTbvKA-unsplash.jpg`: milky way with mauve/violet midtones, amber star clusters, cool blue-purple

Direction chosen: **Electric Void** — high-saturation, violet backgrounds, magenta-dominant syntax, teal-mint strings as the "living" color.

---

## Problems Fixed

| Problem | Current | Fixed |
|---|---|---|
| Blue backgrounds, no purple | `bg #0D1530` (blue-navy) | `bg #0E0A20` (rich violet) |
| green = cyan = func | all `#78C8F0` | three distinct colors |
| purple underused | only in `M.purple`, no syntax role | keyword + builtin |

---

## Palette

### Named colors

```lua
local _void_black     = "#080618"  -- bg_dark
local _dark_nebula    = "#0E0A20"  -- bg
local _nebula_deep    = "#180E30"  -- bg_float
local _nebula_violet  = "#301858"  -- sel
local _stardust       = "#7860A8"  -- fg_dim / comments
local _starlight      = "#DDD0F8"  -- fg

local _nova_rose      = "#E04070"  -- red
local _teal_stardust  = "#38D4A8"  -- green / string_lit
local _pale_gold      = "#E8D070"  -- yellow
local _blue_giant     = "#5870E8"  -- blue
local _electric_cyan  = "#40D0F0"  -- cyan / type_name
local _electric_violet = "#9060E8" -- purple / keyword
local _magenta_nebula = "#C847D9"  -- func
local _orchid_cloud   = "#A840B8"  -- type
local _hot_magenta    = "#E060C8"  -- pink
local _amber_star     = "#E0902A"  -- orange / constant
local _heliotrope     = "#C87EFF"  -- operator (inherited)
local _bright_gold    = "#F0D880"  -- bright_yellow
```

### Semantic assignments

```lua
-- Backgrounds & foregrounds
M.bg_dark     = _void_black
M.bg          = _dark_nebula
M.bg_float    = _nebula_deep
M.sel         = _nebula_violet
M.fg_dim      = _stardust
M.fg          = _starlight
M.bg_inverted = M.bg

-- Accent colors
M.red          = _nova_rose
M.green        = _teal_stardust
M.yellow       = _pale_gold
M.blue         = _blue_giant
M.cyan         = _electric_cyan
M.purple       = _electric_violet
M.pink         = _hot_magenta
M.orange       = _amber_star
M.bright_yellow = _bright_gold

-- Syntax roles (Magenta dominant)
M.comment    = M.fg_dim
M.keyword    = M.purple        -- electric violet
M.func       = _magenta_nebula -- hot magenta
M.type_name  = M.cyan          -- electric cyan (separates from func in same stmt)
M.string_lit = M.green         -- teal-mint
M.constant   = M.orange        -- amber
M.operator   = _heliotrope     -- light violet (inherited, works well)
M.type       = _orchid_cloud   -- orchid between func and type_name
M.builtin    = M.purple        -- same as keyword
M.special    = M.yellow        -- pale gold

-- Diagnostics
M.error   = M.red
M.warning = M.yellow
M.info    = M.cyan
M.hint    = M.purple

M.none = "NONE"
```

---

## Color Story

The syntax tells a story by temperature:

- **Keywords / builtins:** electric violet (`#9060E8`) — structural language
- **Functions:** hot magenta (`#C847D9`) — action, the brightest role
- **Types (instantiated):** orchid (`#A840B8`) — in the magenta family, quieter
- **Type names (declarations):** electric cyan (`#40D0F0`) — cold, structural contrast
- **Strings:** teal-mint (`#38D4A8`) — organic, the "living" color in the code
- **Constants/numbers:** amber (`#E0902A`) — warm counterpoint, star clusters
- **Operators:** heliotrope (`#C87EFF`) — pale violet, stays out of the way
- **Comments:** muted stardust violet (`#7860A8`) — recedes into the void

---

## Notes

- `bg_inverted = M.bg` (dark background color for inverted-text groups — consistent with other dark palettes)
- Exact values are a starting point. Fine-tune in Neovim, especially `_stardust` (fg_dim) which must read as clearly dimmed against `_starlight` (fg)
- The `green` accent color (`_teal_stardust`) doubles as `string_lit` — `M.green = M.string_lit` by value. This is intentional.
