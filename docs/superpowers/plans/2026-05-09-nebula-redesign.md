# Nebula Palette Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the `nebula` palette with the Electric Void design — rich violet backgrounds, magenta-dominant syntax, teal-mint strings, amber constants.

**Architecture:** Single file replacement: `lua/void-space/palettes/nebula.lua` is rewritten in full. The existing `palette_spec.lua` test suite validates all canonical keys and color format — no new tests needed. The worktree for this work is `experimental/nebula`, branched from `main`.

**Tech Stack:** Lua 5.1, Neovim ≥ 0.8, busted (test runner via `make test`)

---

## File Map

| File | Action |
|---|---|
| `lua/void-space/palettes/nebula.lua` | Rewrite — full Electric Void design |

---

## Task 1: Create `experimental/nebula` worktree

**Files:** none modified

- [ ] **Step 1: Create the branch and worktree**

Run from the main repo root:

```bash
cd /home/vinicius.figueiredo/Code/personal/void-space.nvim
git worktree add .worktrees/nebula -b experimental/nebula main
```

Expected output: `Preparing worktree (new branch 'experimental/nebula')`

Worktree will be at: `/home/vinicius.figueiredo/Code/personal/void-space.nvim/.worktrees/nebula`

- [ ] **Step 2: Verify baseline tests pass**

```bash
cd /home/vinicius.figueiredo/Code/personal/void-space.nvim/.worktrees/nebula && make test
```

Expected: all tests pass. The current nebula palette is structurally valid (has all canonical keys including `bg_inverted` which was added in the light-theme branch and merged to main). If `bg_inverted` is missing from main's nebula.lua, the test will fail with `variant "nebula" is missing canonical key "bg_inverted"` — in that case add `M.bg_inverted = M.bg` to `nebula.lua` and commit before proceeding.

---

## Task 2: Rewrite `nebula.lua` with Electric Void design

**Files:**
- Modify: `lua/void-space/palettes/nebula.lua` (full rewrite)

- [ ] **Step 1: Replace the file content**

Overwrite `/home/vinicius.figueiredo/Code/personal/void-space.nvim/.worktrees/nebula/lua/void-space/palettes/nebula.lua` with:

```lua
-- void-space: nebula palette (electric void variant)

local M = {}

-- ------------
-- Named colors
-- ------------
local _void_black      = "#080618"  -- darkest background
local _dark_nebula     = "#0E0A20"  -- main background
local _nebula_deep     = "#180E30"  -- floats / sidebar
local _nebula_violet   = "#301858"  -- selection
local _stardust        = "#7860A8"  -- dimmed text, comments
local _starlight       = "#DDD0F8"  -- main foreground

local _nova_rose       = "#E04070"  -- red
local _teal_stardust   = "#38D4A8"  -- green / strings
local _pale_gold       = "#E8D070"  -- yellow
local _blue_giant      = "#5870E8"  -- blue
local _electric_cyan   = "#40D0F0"  -- cyan / type names
local _electric_violet = "#9060E8"  -- purple / keywords
local _magenta_nebula  = "#C847D9"  -- functions
local _orchid_cloud    = "#A840B8"  -- types
local _hot_magenta     = "#E060C8"  -- pink
local _amber_star      = "#E0902A"  -- orange / constants
local _heliotrope      = "#C87EFF"  -- operators
local _bright_gold     = "#F0D880"  -- bright yellow

-- -------------------------
-- Semantic colors
-- -------------------------
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

-- Syntax roles (magenta dominant)
M.comment    = M.fg_dim
M.keyword    = M.purple        -- electric violet
M.func       = _magenta_nebula -- hot magenta
M.type_name  = M.cyan          -- electric cyan (distinct from func)
M.string_lit = M.green         -- teal-mint
M.constant   = M.orange        -- amber
M.operator   = _heliotrope     -- pale violet
M.type       = _orchid_cloud   -- orchid
M.builtin    = M.purple        -- same as keyword
M.special    = M.yellow        -- pale gold

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
cd /home/vinicius.figueiredo/Code/personal/void-space.nvim/.worktrees/nebula && make test
```

Expected: all tests pass. Key checks the suite runs on nebula:
- All canonical keys present (including `bg_inverted`) ✓
- All color values match `#rrggbb` format ✓
- `luminance(bg_dark) < luminance(bg)`: `#080618` (lum ≈ 6) < `#0E0A20` (lum ≈ 12) ✓
- `luminance(bg) < luminance(fg)` (dark theme): `#0E0A20` (lum ≈ 12) < `#DDD0F8` (lum ≈ 195) ✓

If any test fails, read the error carefully — most likely a missing key or a malformed hex string.

- [ ] **Step 3: Verify manually in Neovim**

Open Neovim from the worktree and run:

```vim
:lua require("void-space").setup({ variant = "nebula" })
:lua require("void-space").load()
```

Check:
- Background is near-black with violet character (not blue-navy)
- Functions and `class`/`def` keywords glow in magenta/violet
- String literals are teal-mint
- Numbers/constants are amber
- Comments recede into muted violet

Run `:VoidSpaceClearCache` first if you see stale colors from a previous load.

- [ ] **Step 4: Commit**

```bash
cd /home/vinicius.figueiredo/Code/personal/void-space.nvim/.worktrees/nebula
git add lua/void-space/palettes/nebula.lua
git commit -m "feat(palettes): redesign nebula as electric void — violet backgrounds, magenta syntax"
```
