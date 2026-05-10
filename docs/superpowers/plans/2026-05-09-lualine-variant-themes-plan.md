# Lualine Variant Themes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create lualine theme files for the `cosmic_dawn` and `nebula` palette variants, following the exact pattern of the existing `void-space` lualine theme.

**Architecture:** Two new files under `lua/lualine/themes/` — one per variant — each loading its palette via `require("void-space.palette").get("<variant>")` and returning the same 7-mode table structure used by the existing `void-space` theme. Tests live in `spec/lualine_spec.lua` and cover all three lualine themes (default + two new ones) for structure validity and color format.

**Tech Stack:** Lua 5.1, busted test framework, void-space palette system.

---

## File Map

| Action | Path | Responsibility |
|---|---|---|
| Create | `spec/lualine_spec.lua` | Tests for all lualine theme files |
| Create | `lua/lualine/themes/void-space-cosmic-dawn.lua` | Lualine theme using cosmic_dawn palette |
| Create | `lua/lualine/themes/void-space-nebula.lua` | Lualine theme using nebula palette |

No existing files are modified.

---

### Task 1: Write failing tests for lualine variant themes

**Files:**
- Create: `spec/lualine_spec.lua`

The busted lpath is `lua/?.lua;lua/?/init.lua`, so `require("lualine.themes.void-space-cosmic-dawn")` resolves to `lua/lualine/themes/void-space-cosmic-dawn.lua`. All palette files are pure Lua (no `vim` API), so they load cleanly under busted.

The test suite covers all three lualine themes in a loop to avoid repetition.

- [ ] **Step 1: Create spec/lualine_spec.lua**

```lua
-- spec/lualine_spec.lua
local THEMES = {
  { name = "void-space",             variant = "default" },
  { name = "void-space-cosmic-dawn", variant = "cosmic_dawn" },
  { name = "void-space-nebula",      variant = "nebula" },
}

local MODES        = { "normal", "insert", "visual", "replace", "command", "terminal", "inactive" }
local ACTIVE_MODES = { "normal", "insert", "visual", "replace", "command", "terminal" }
local SECTIONS     = { "a", "b", "c" }
local HEX          = "^#%x%x%x%x%x%x$"

local function is_hex(s)
  return type(s) == "string" and s:match(HEX) ~= nil
end

for _, entry in ipairs(THEMES) do
  describe("lualine theme: " .. entry.name, function()
    local theme

    before_each(function()
      package.loaded["lualine.themes." .. entry.name] = nil
      theme = require("lualine.themes." .. entry.name)
    end)

    it("loads and returns a table", function()
      assert.is_table(theme)
    end)

    it("has all required modes", function()
      for _, mode in ipairs(MODES) do
        assert.is_table(theme[mode], "missing mode: " .. mode)
      end
    end)

    it("has a, b, c sections in every mode", function()
      for _, mode in ipairs(MODES) do
        for _, section in ipairs(SECTIONS) do
          assert.is_table(theme[mode][section],
            ("missing section %s in mode %s"):format(section, mode))
        end
      end
    end)

    it("section a has gui='bold' for all active modes", function()
      for _, mode in ipairs(ACTIVE_MODES) do
        assert.equals("bold", theme[mode].a.gui,
          ("expected bold gui in %s.a"):format(mode))
      end
    end)

    it("all fg and bg values are #rrggbb hex strings", function()
      for _, mode in ipairs(MODES) do
        for _, section in ipairs(SECTIONS) do
          local s = theme[mode][section]
          if s.fg ~= nil then
            assert.is_true(is_hex(s.fg),
              ("%s.%s.fg is not a hex color: %s"):format(mode, section, tostring(s.fg)))
          end
          if s.bg ~= nil then
            assert.is_true(is_hex(s.bg),
              ("%s.%s.bg is not a hex color: %s"):format(mode, section, tostring(s.bg)))
          end
        end
      end
    end)
  end)
end
```

- [ ] **Step 2: Run tests to verify they fail (cosmic_dawn and nebula themes missing)**

```bash
busted --config-file=.busted spec/lualine_spec.lua
```

Expected output: errors for `void-space-cosmic-dawn` and `void-space-nebula` (module not found). The `void-space` suite should pass.

---

### Task 2: Create void-space-cosmic-dawn lualine theme

**Files:**
- Create: `lua/lualine/themes/void-space-cosmic-dawn.lua`

- [ ] **Step 1: Create the theme file**

```lua
-- Lualine theme for void-space (cosmic_dawn variant)
-- Loaded automatically when lualine is configured with theme = 'void-space-cosmic-dawn'

local c = require("void-space.palette").get("cosmic_dawn")

local vs = {}

vs.normal = {
	a = { fg = c.bg, bg = c.blue,   gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.insert = {
	a = { fg = c.bg, bg = c.green,  gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.visual = {
	a = { fg = c.bg, bg = c.purple, gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.replace = {
	a = { fg = c.bg, bg = c.red,    gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.command = {
	a = { fg = c.bg, bg = c.yellow, gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.terminal = {
	a = { fg = c.bg, bg = c.cyan,   gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.inactive = {
	a = { fg = c.fg_dim, bg = c.bg_float },
	b = { fg = c.fg_dim, bg = c.bg_float },
	c = { fg = c.fg_dim, bg = c.bg_float },
}

return vs
```

- [ ] **Step 2: Run the cosmic_dawn suite to verify it passes**

```bash
busted --config-file=.busted spec/lualine_spec.lua
```

Expected: `lualine theme: void-space` and `lualine theme: void-space-cosmic-dawn` pass; `void-space-nebula` still fails.

---

### Task 3: Create void-space-nebula lualine theme

**Files:**
- Create: `lua/lualine/themes/void-space-nebula.lua`

- [ ] **Step 1: Create the theme file**

```lua
-- Lualine theme for void-space (nebula variant)
-- Loaded automatically when lualine is configured with theme = 'void-space-nebula'

local c = require("void-space.palette").get("nebula")

local vs = {}

vs.normal = {
	a = { fg = c.bg, bg = c.blue,   gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.insert = {
	a = { fg = c.bg, bg = c.green,  gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.visual = {
	a = { fg = c.bg, bg = c.purple, gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.replace = {
	a = { fg = c.bg, bg = c.red,    gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.command = {
	a = { fg = c.bg, bg = c.yellow, gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.terminal = {
	a = { fg = c.bg, bg = c.cyan,   gui = "bold" },
	b = { fg = c.fg, bg = c.bg_float },
	c = { fg = c.fg, bg = c.bg },
}

vs.inactive = {
	a = { fg = c.fg_dim, bg = c.bg_float },
	b = { fg = c.fg_dim, bg = c.bg_float },
	c = { fg = c.fg_dim, bg = c.bg_float },
}

return vs
```

- [ ] **Step 2: Run the full lualine spec to verify all three themes pass**

```bash
busted --config-file=.busted spec/lualine_spec.lua
```

Expected: all 15 assertions across 3 themes pass, 0 failures.

- [ ] **Step 3: Run the full test suite to confirm no regressions**

```bash
make test
```

Expected: all specs pass.

- [ ] **Step 4: Commit**

```bash
git add spec/lualine_spec.lua \
        lua/lualine/themes/void-space-cosmic-dawn.lua \
        lua/lualine/themes/void-space-nebula.lua
git commit -m "feat(lualine): add cosmic_dawn and nebula variant themes"
```
