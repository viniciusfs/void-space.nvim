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

    it("section a.fg matches the background of its palette variant", function()
      local palette_bg = require("void-space.palette").get(entry.variant).bg
      assert.equals(palette_bg, theme.normal.a.fg,
        ("expected normal.a.fg to equal palette bg for variant %q"):format(entry.variant))
    end)

    it("section a does not have gui='bold' for inactive mode", function()
      assert.is_not_equal("bold", theme.inactive.a.gui)
    end)

    it("section a defines fg and bg for all active modes", function()
      for _, mode in ipairs(ACTIVE_MODES) do
        assert.is_string(theme[mode].a.fg,
          ("expected %s.a.fg to be a string"):format(mode))
        assert.is_string(theme[mode].a.bg,
          ("expected %s.a.bg to be a string"):format(mode))
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

describe("lualine theme void-space: auto-adapts to configured variant", function()
  local void_space

  before_each(function()
    package.loaded["lualine.themes.void-space"] = nil
    void_space = require("void-space")
  end)

  after_each(function()
    void_space.config.variant = "default"
  end)

  it("uses cosmic_dawn palette when config variant is cosmic_dawn", function()
    void_space.config.variant = "cosmic_dawn"
    local theme = require("lualine.themes.void-space")
    local p = require("void-space.palette").get("cosmic_dawn")
    assert.equals(p.bg, theme.normal.a.fg,
      "expected normal.a.fg to match cosmic_dawn palette bg")
  end)

  it("uses nebula palette when config variant is nebula", function()
    void_space.config.variant = "nebula"
    local theme = require("lualine.themes.void-space")
    local p = require("void-space.palette").get("nebula")
    assert.equals(p.bg, theme.normal.a.fg,
      "expected normal.a.fg to match nebula palette bg")
  end)
end)
