# Light Theme (cosmic_dawn) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `cosmic_dawn` light-background palette variant to void-space.nvim, with proper background switching and inverted-text contrast on light backgrounds.

**Architecture:** A new `M.bg_inverted` semantic key is added to all three palettes (dark palettes point it to `M.bg`, light palette points it to `M.fg`). Eight highlight groups in `editor.lua` that used `fg = c.bg` as inverted text are updated to `fg = c.bg_inverted`. `init.lua` reads `palette.background` instead of hardcoding `"dark"`.

**Tech Stack:** Lua 5.1, Neovim ≥ 0.8, busted (test runner via `make test`)

---

## File Map

| File | Action |
|---|---|
| `spec/palette_spec.lua` | Modify — add `bg_inverted` to `CANONICAL_KEYS`; fix luminance test for light themes; add `cosmic_dawn` to `VARIANTS` |
| `lua/void-space/palettes/default.lua` | Modify — add `M.bg_inverted = M.bg` |
| `lua/void-space/palettes/nebula.lua` | Modify — add `M.bg_inverted = M.bg` |
| `lua/void-space/palettes/cosmic_dawn.lua` | Create — full Cosmic Dawn palette |
| `lua/void-space/highlights/editor.lua` | Modify — 8 groups: `fg = c.bg` → `fg = c.bg_inverted` |
| `lua/void-space/init.lua` | Modify — `vim.o.background = palette.background or "dark"` |

---

## Task 1: Add `bg_inverted` to palette spec canonical keys

**Files:**
- Modify: `spec/palette_spec.lua`

- [ ] **Step 1: Add `bg_inverted` to `CANONICAL_KEYS`**

In `spec/palette_spec.lua`, update the `CANONICAL_KEYS` table (line 3–10) to include `"bg_inverted"`:

```lua
local CANONICAL_KEYS = {
  "bg_dark", "bg", "bg_float", "sel", "fg", "fg_dim",
  "bg_inverted",
  "comment", "keyword", "func", "type_name", "string_lit", "constant", "operator",
  "type", "builtin",
  "error", "warning", "info", "hint",
  "red", "green", "yellow", "blue", "cyan", "purple", "orange", "pink",
  "bright_yellow", "none",
}
```

- [ ] **Step 2: Run tests — expect failure**

```bash
make test
```

Expected: FAIL — `variant "default" is missing canonical key "bg_inverted"` and same for `"nebula"`.

- [ ] **Step 3: Commit the failing test**

```bash
git add spec/palette_spec.lua
git commit -m "test(palette): add bg_inverted to canonical keys"
```

---

## Task 2: Add `bg_inverted` to `default.lua`

**Files:**
- Modify: `lua/void-space/palettes/default.lua`

- [ ] **Step 1: Add the key**

After the `M.none = "NONE"` line (end of file, before `return M`), add:

```lua
M.bg_inverted = M.bg
```

The full end of the file should look like:

```lua
-- Diagnostics
M.error = M.red
M.warning = M.yellow
M.info = M.cyan
M.hint = M.purple

M.none = "NONE"
M.bg_inverted = M.bg

return M
```

- [ ] **Step 2: Run tests**

```bash
make test
```

Expected: `default` variant palette tests PASS. `nebula` still FAILS on `bg_inverted`.

---

## Task 3: Add `bg_inverted` to `nebula.lua`

**Files:**
- Modify: `lua/void-space/palettes/nebula.lua`

- [ ] **Step 1: Add the key**

After the `M.none = "NONE"` line (before `return M`), add:

```lua
M.bg_inverted = M.bg
```

The full end of the file should look like:

```lua
-- Diagnostics
M.error = _wild_watermelon
M.warning = _lightning_yellow
M.info = _cornflower_blue
M.hint = _maya_blue

M.none = "NONE"
M.bg_inverted = M.bg

return M
```

- [ ] **Step 2: Run tests**

```bash
make test
```

Expected: All `default` and `nebula` palette tests PASS.

- [ ] **Step 3: Commit**

```bash
git add lua/void-space/palettes/default.lua lua/void-space/palettes/nebula.lua
git commit -m "feat(palettes): add bg_inverted semantic key to default and nebula"
```

---

## Task 4: Fix luminance test for light themes and add `cosmic_dawn` to VARIANTS

**Files:**
- Modify: `spec/palette_spec.lua`

The existing luminance test asserts `luminance(bg) < luminance(fg)` — true for dark themes (dark bg, bright fg) but false for light themes (bright bg, dark fg). It needs to branch on `c.background`.

- [ ] **Step 1: Replace the luminance test**

Find and replace the entire `it("bg_dark is darker than bg which is darker than fg", ...)` block with:

```lua
it("bg_dark is darker than bg", function()
  local function luminance(hex)
    local r = tonumber(hex:sub(2, 3), 16)
    local g = tonumber(hex:sub(4, 5), 16)
    local b = tonumber(hex:sub(6, 7), 16)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b
  end
  assert.is_true(luminance(c.bg_dark) < luminance(c.bg),
    "bg_dark should be darker than bg")
end)

it("fg and bg have the right luminance relationship for the background type", function()
  local function luminance(hex)
    local r = tonumber(hex:sub(2, 3), 16)
    local g = tonumber(hex:sub(4, 5), 16)
    local b = tonumber(hex:sub(6, 7), 16)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b
  end
  if c.background == "light" then
    assert.is_true(luminance(c.fg) < luminance(c.bg),
      "light theme: fg should be darker than bg")
  else
    assert.is_true(luminance(c.bg) < luminance(c.fg),
      "dark theme: bg should be darker than fg")
  end
end)
```

- [ ] **Step 2: Add `cosmic_dawn` to `VARIANTS`**

Update line 12:

```lua
local VARIANTS = { "default", "nebula", "cosmic_dawn" }
```

- [ ] **Step 3: Run tests — expect failure**

```bash
make test
```

Expected: FAIL — `module 'void-space.palettes.cosmic_dawn' not found`.

- [ ] **Step 4: Commit the failing test**

```bash
git add spec/palette_spec.lua
git commit -m "test(palette): add cosmic_dawn variant, fix luminance test for light themes"
```

---

## Task 5: Create `cosmic_dawn.lua`

**Files:**
- Create: `lua/void-space/palettes/cosmic_dawn.lua`

- [ ] **Step 1: Create the palette file**

```lua
-- void-space: cosmic_dawn palette (light background variant)

local M = {}

-- ------------
-- Named colors
-- ------------
local _alice_blue    = "#EEF1F7"  -- main background
local _lavender_mist = "#E4E8F2"  -- floats / sidebar
local _steel_mist    = "#DDE3EE"  -- darkest background (inactive windows)
local _periwinkle    = "#D0D8E8"  -- selection
local _slate         = "#5A6880"  -- dimmed text, comments
local _dark_indigo   = "#283048"  -- main foreground / inverted text

local _crimson       = "#A02040"
local _forest        = "#2E7834"
local _golden        = "#C09010"  -- see note in spec: yellow is a light-theme compromise
local _royal         = "#2850B0"
local _teal          = "#1E6888"
local _violet        = "#6040A8"
local _rose          = "#983080"
local _sienna        = "#8A5020"
local _bright_gold   = "#D4A820"

-- -------------------------
-- Semantic colors
-- -------------------------
-- Backgrounds & foregrounds
M.bg_dark    = _steel_mist
M.bg         = _alice_blue
M.bg_float   = _lavender_mist
M.sel        = _periwinkle
M.fg_dim     = _slate
M.fg         = _dark_indigo
M.bg_inverted = _dark_indigo
M.background  = "light"

-- Accent colors
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

return M
```

- [ ] **Step 2: Run tests**

```bash
make test
```

Expected: All palette tests PASS for all three variants. All other existing tests still PASS.

- [ ] **Step 3: Commit**

```bash
git add lua/void-space/palettes/cosmic_dawn.lua
git commit -m "feat(palettes): add cosmic_dawn light palette"
```

---

## Task 6: Update `editor.lua` — use `bg_inverted` for inverted text groups

**Files:**
- Modify: `lua/void-space/highlights/editor.lua`

- [ ] **Step 1: Update the 8 highlight groups**

Find and replace each of the following lines exactly. All are in `M.get(c, opts)`:

| Find | Replace |
|---|---|
| `hl.Search = { fg = c.bg, bg = c.yellow }` | `hl.Search = { fg = c.bg_inverted, bg = c.yellow }` |
| `hl.IncSearch = { fg = c.bg, bg = c.bright_yellow, bold = true }` | `hl.IncSearch = { fg = c.bg_inverted, bg = c.bright_yellow, bold = true }` |
| `hl.Substitute = { fg = c.bg, bg = c.orange }` | `hl.Substitute = { fg = c.bg_inverted, bg = c.orange }` |
| `hl.DiffAdd = { fg = c.bg, bg = c.green }` | `hl.DiffAdd = { fg = c.bg_inverted, bg = c.green }` |
| `hl.DiffChange = { fg = c.bg, bg = c.yellow }` | `hl.DiffChange = { fg = c.bg_inverted, bg = c.yellow }` |
| `hl.DiffDelete = { fg = c.bg, bg = c.red }` | `hl.DiffDelete = { fg = c.bg_inverted, bg = c.red }` |
| `hl.DiffText = { fg = c.bg, bg = c.blue }` | `hl.DiffText = { fg = c.bg_inverted, bg = c.blue }` |
| `hl.MatchParen = { fg = c.bg_float, bg = c.pink, bold = true }` | `hl.MatchParen = { fg = c.bg_inverted, bg = c.pink, bold = true }` |

- [ ] **Step 2: Run tests**

```bash
make test
```

Expected: All tests PASS. The `highlights_spec.lua` test `"fg/bg/sp values are palette colors or NONE"` validates that `c.bg_inverted` is a known palette color (it is, since it was added in Tasks 2–5).

- [ ] **Step 3: Commit**

```bash
git add lua/void-space/highlights/editor.lua
git commit -m "fix(editor): use bg_inverted for inverted-text highlight groups"
```

---

## Task 7: Update `init.lua` — read background from palette

**Files:**
- Modify: `lua/void-space/init.lua`

- [ ] **Step 1: Replace the hardcoded background line**

Find (line 47):
```lua
vim.o.background = "dark"
```

Replace with:
```lua
vim.o.background = palette.background or "dark"
```

Note: `palette` is already in scope at this point — it was assigned on line 51. The line to change is **before** that assignment. Move the background line to after the palette is loaded:

The relevant block in `M.load()` currently reads (lines 43–51):
```lua
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.o.termguicolors = true
vim.g.colors_name = "void-space"

local palette = require("void-space.palette").get(M.config.variant)
```

Change it to:
```lua
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.g.colors_name = "void-space"

local palette = require("void-space.palette").get(M.config.variant)
vim.o.background = palette.background or "dark"
```

- [ ] **Step 2: Run tests**

```bash
make test
```

Expected: All tests PASS (`init.lua` changes are not unit-tested, but existing suite confirms nothing is broken).

- [ ] **Step 3: Verify manually in Neovim**

Open Neovim and run:
```vim
:lua require("void-space").setup({ variant = "cosmic_dawn" })
:lua require("void-space").load()
```

Expected: editor switches to a light background, Cosmic Dawn colors visible. Then verify dark theme still works:
```vim
:lua require("void-space").setup({ variant = "default" })
:lua require("void-space").load()
```

Expected: editor returns to dark background.

- [ ] **Step 4: Commit**

```bash
git add lua/void-space/init.lua
git commit -m "feat(init): read background from palette instead of hardcoding dark"
```
