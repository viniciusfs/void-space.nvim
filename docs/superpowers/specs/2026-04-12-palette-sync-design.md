# Design: Palette Sync (Epic 3.2)

**Date:** 2026-04-12
**Status:** Approved
**Scope:** Automate propagation of palette changes to `extras/`, `assets/palette_default.svg`, and `assets/void_space_logo.svg`

---

## Problem

The extras files (`void-space-alacritty.toml`, `void-space-terminator.conf`, `void-space-tmux.conf`) and SVG assets contain hardcoded hex values with no connection to the Lua palette. When palette colors change, these files drift silently.

---

## Goals

- A single `make sync` command updates all palette-derived artifacts for the `default` palette
- Color values in extras and SVGs are always consistent with `lua/void-space/palettes/default.lua`
- No new runtime dependencies (pure Python 3 stdlib, same as `gen_swatch.py`)

## Non-Goals

- Multi-variant support (nebula or future palettes) — only `default` for now
- Validation-only / CI diff mode
- Watching for palette changes automatically

---

## Architecture

### File Structure

```
scripts/
  sync_palette.py              # main script
  templates/
    void-space-alacritty.toml.tmpl
    void-space-terminator.conf.tmpl
    void-space-tmux.conf.tmpl
```

### Palette Parser

Reuses the `parse_lua_palette()` logic already proven in `gen_swatch.py`. Reads `lua/void-space/palettes/default.lua` and returns a `{key: "#RRGGBB"}` dict of all semantic exports.

### Template Rendering (extras)

Templates are valid config files with `{{key}}` placeholders in color positions. The script resolves each placeholder against the palette dict using `str.replace("{{key}}", value)`. No third-party template library required.

Example template snippet (`void-space-alacritty.toml.tmpl`):

```toml
[colors.primary]
background = "{{bg}}"
foreground = "{{fg}}"

[colors.normal]
black   = "{{bg}}"
red     = "{{red}}"
green   = "{{green}}"
yellow  = "{{yellow}}"
blue    = "{{blue}}"
magenta = "{{purple}}"
cyan    = "{{cyan}}"
white   = "{{sel}}"

[colors.bright]
black   = "{{bg_float}}"
red     = "{{orange}}"
green   = "{{green}}"
yellow  = "{{bright_yellow}}"
blue    = "{{blue}}"
magenta = "{{pink}}"
cyan    = "{{fg_dim}}"
white   = "{{fg}}"
```

The ANSI slot → palette key mapping is defined directly in each template, making it visible and editable without touching the script.

### SVG Updates

#### `assets/palette_default.svg`

Regenerated from scratch by the script. Since this file is simply a grid of colored rectangles displaying the palette, full regeneration is more robust than in-place substitution and guarantees the output always matches the current palette exactly.

#### `assets/void_space_logo.svg`

Updated in-place. The logo is a complex Inkscape-authored SVG with gradients, opacity, and many elements — regenerating it programmatically is not feasible.

The script maintains a `LOGO_COLOR_MAP` dict mapping each known hex value in the logo to its semantic palette key:

```python
LOGO_COLOR_MAP = {
    "#9b88d0": "purple",
    "#608cc3": "blue",
    "#1b202a": "bg_dark",
    "#9aa7bd": "fg",
    "#d5ad76": "bright_yellow",
    # ... (complete list populated during implementation)
}
```

The script reads the SVG as text, iterates over the map, and replaces each old hex with the current palette value for that key. This resolves existing color drift and handles future palette changes.

---

## Data Flow

```
lua/void-space/palettes/default.lua
        │
        ▼
  parse_lua_palette()
        │
        ├──► render template ──► extras/void-space-alacritty.toml
        ├──► render template ──► extras/void-space-terminator.conf
        ├──► render template ──► extras/void-space-tmux.conf
        ├──► regenerate SVG  ──► assets/palette_default.svg
        └──► in-place update ──► assets/void_space_logo.svg
```

---

## Error Handling

| Situation | Behavior |
|-----------|----------|
| `{{key}}` in template not found in palette | Abort with clear message: template name + missing key |
| Palette file not found | Abort with error |
| Hex in `LOGO_COLOR_MAP` not found in SVG | Warn and continue (color may have been removed from the logo) |

---

## CLI and Output

Invoked via `make sync` or directly:

```
$ make sync
Syncing palette 'default'...

  extras/void-space-alacritty.toml    updated
  extras/void-space-terminator.conf   updated
  extras/void-space-tmux.conf         updated
  assets/palette_default.svg          regenerated
  assets/void_space_logo.svg          updated (7 colors replaced)

Done.
```

No flags. The script always processes all targets for the default palette.

---

## Makefile

```makefile
sync:
    python3 scripts/sync_palette.py
```

---

## Testing

No automated tests for the script itself. Correctness is validated by:

1. Running `make sync` and inspecting the diff with `git diff extras/ assets/`
2. Loading the theme in Neovim and opening an Alacritty/tmux session to verify visual consistency
3. Opening the SVG files in a viewer to confirm colors updated correctly
