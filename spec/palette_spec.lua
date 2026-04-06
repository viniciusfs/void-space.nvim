local palette = require("void-space.palette")

local CANONICAL_KEYS = {
  "bg_dark", "bg", "bg_float", "sel", "fg", "fg_dim",
  "comment", "keyword", "func", "type_name", "string_lit", "constant", "operator",
  "error", "warning", "info", "hint",
  "red", "green", "yellow", "blue", "cyan", "purple", "orange", "pink",
  "bright_yellow", "none",
}

local VARIANTS = { "default", "nebula" }

for _, variant in ipairs(VARIANTS) do
  describe("void-space.palette variant: " .. variant, function()
    local c = palette.get(variant)

    it("returns a table", function()
      assert.is_table(c)
    end)

    it("exports all canonical keys", function()
      for _, key in ipairs(CANONICAL_KEYS) do
        assert.is_not_nil(c[key],
          ("variant %q is missing canonical key %q"):format(variant, key))
      end
    end)

    it("all color values match #rrggbb format", function()
      for _, key in ipairs(CANONICAL_KEYS) do
        local v = c[key]
        if key ~= "none" then
          assert.is_truthy(
            v:match("^#%x%x%x%x%x%x$"),
            ("palette[%q].%s = %q does not match #rrggbb"):format(variant, key, v)
          )
        end
      end
    end)

    it("none equals 'NONE' exactly", function()
      assert.equals("NONE", c.none)
    end)

    it("bg_dark is darker than bg which is darker than fg", function()
      local function luminance(hex)
        local r = tonumber(hex:sub(2, 3), 16)
        local g = tonumber(hex:sub(4, 5), 16)
        local b = tonumber(hex:sub(6, 7), 16)
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
      end
      assert.is_true(luminance(c.bg_dark) < luminance(c.bg),
        "bg_dark should be darker than bg")
      assert.is_true(luminance(c.bg) < luminance(c.fg),
        "bg should be darker than fg")
    end)
  end)
end

describe("void-space.palette", function()
  it("get() with no args defaults to default", function()
    local default_c = palette.get()
    local explicit_c = palette.get("default")
    assert.are.same(default_c, explicit_c)
  end)
end)
