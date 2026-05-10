# Spec: Lualine Themes for cosmic_dawn and nebula Variants

## Overview

Create two new lualine theme files — one for the `cosmic_dawn` palette and one for the `nebula` palette — following the exact same pattern as the existing `lua/lualine/themes/void-space.lua`.

## Files to Create

| File | Lualine theme name | Palette variant |
|---|---|---|
| `lua/lualine/themes/void-space-cosmic-dawn.lua` | `'void-space-cosmic-dawn'` | `'cosmic_dawn'` |
| `lua/lualine/themes/void-space-nebula.lua` | `'void-space-nebula'` | `'nebula'` |

No changes to the existing `lua/lualine/themes/void-space.lua`.

## Structure

Each file mirrors `void-space.lua` exactly, with only the palette call differing:

```lua
local c = require("void-space.palette").get("<variant>")
```

### Mode → accent color mapping

| Mode | `a.bg` | `a.fg` | `a.gui` |
|---|---|---|---|
| normal | `c.blue` | `c.bg` | `"bold"` |
| insert | `c.green` | `c.bg` | `"bold"` |
| visual | `c.purple` | `c.bg` | `"bold"` |
| replace | `c.red` | `c.bg` | `"bold"` |
| command | `c.yellow` | `c.bg` | `"bold"` |
| terminal | `c.cyan` | `c.bg` | `"bold"` |

Sections `b` and `c` for all active modes: `fg = c.fg, bg = c.bg_float` and `fg = c.fg, bg = c.bg`.

Inactive mode (all sections): `fg = c.fg_dim, bg = c.bg_float`.

### Contrast rationale

- **cosmic_dawn** (light): `a.fg = c.bg = #EEF1F7` (near-white) over dark accent backgrounds (e.g. `blue = #2850B0`) — adequate contrast.
- **nebula** (dark): `a.fg = c.bg = #0E0A20` (near-black) over vivid electric accents (e.g. `purple = #9060E8`) — strong contrast.

## User configuration

Users activate a variant theme by setting lualine's `theme` option:

```lua
require('lualine').setup({ options = { theme = 'void-space-cosmic-dawn' } })
-- or
require('lualine').setup({ options = { theme = 'void-space-nebula' } })
```

## Out of scope

- No factory/shared module — three independent files.
- No changes to existing `void-space.lua`.
- No auto-detection of active colorscheme variant.
