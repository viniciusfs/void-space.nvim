-- Stub vim for testing outside Neovim
_G.vim = {
  fn = {
    stdpath = function(what)
      if what == "cache" then
        return "/tmp/void-space-test-cache"
      end
    end,
    mkdir = function() end,
    glob = function(pattern)
      -- returns newline-separated matches; stub returns empty
      return ""
    end,
    delete = function() end,
  },
  log = { levels = { INFO = 2 } },
  notify = function() end,
}

package.loaded["void-space.cache"] = nil
local cache = require("void-space.cache")

describe("void-space.cache", function()
  describe("path()", function()
    it("returns a path inside stdpath cache dir", function()
      local opts = {
        variant = "deep_space",
        transparent = false,
        italic_comments = true,
        italic_keywords = false,
        dim_inactive = false,
      }
      local p = cache.path(opts)
      assert.truthy(p:find("/void%-space/", 1, false))
      assert.truthy(p:match("%.lua$"))
    end)

    it("returns different paths for different configs", function()
      local opts_a = { variant = "deep_space", transparent = false, italic_comments = true,  italic_keywords = false, dim_inactive = false }
      local opts_b = { variant = "deep_space", transparent = true,  italic_comments = true,  italic_keywords = false, dim_inactive = false }
      assert.not_equals(cache.path(opts_a), cache.path(opts_b))
    end)

    it("returns same path for same config", function()
      local opts = { variant = "default", transparent = false, italic_comments = false, italic_keywords = false, dim_inactive = false }
      assert.equals(cache.path(opts), cache.path(opts))
    end)
  end)

  describe("clear()", function()
    it("calls vim.fn.delete for each glob match", function()
      local deleted = {}
      vim.fn.glob = function(_pattern)
        return "/tmp/void-space-test-cache/void-space/a.lua\n/tmp/void-space-test-cache/void-space/b.lua"
      end
      vim.fn.delete = function(p)
        table.insert(deleted, p)
      end

      cache.clear()

      assert.equals(2, #deleted)
      vim.fn.glob = function() return "" end
      vim.fn.delete = function() end
    end)

    it("does nothing when no cache files exist", function()
      local deleted = {}
      vim.fn.glob = function() return "" end
      vim.fn.delete = function(p) table.insert(deleted, p) end

      cache.clear()

      assert.equals(0, #deleted)
    end)
  end)

  describe("save() and load()", function()
    local tmp_path

    before_each(function()
      tmp_path = os.tmpname() .. ".lua"
      -- override path() to use a controlled temp file
      vim.fn.mkdir = function() end
    end)

    after_each(function()
      os.remove(tmp_path)
    end)

    it("load() returns nil when file does not exist", function()
      local opts = { variant = "nope", transparent = false, italic_comments = false, italic_keywords = false, dim_inactive = false }
      -- path() will point to a nonexistent file in /tmp/void-space-test-cache/
      local result = cache.load(opts)
      assert.is_nil(result)
    end)

    it("save() writes a loadable file and load() round-trips the table", function()
      local highlights = {
        Normal    = { fg = "#c8cfe8", bg = "#0d1220" },
        Comment   = { fg = "#5566aa", italic = true },
        ["@keyword"] = { fg = "#8899cc", bold = false },
      }

      -- Write to a known temp path by monkey-patching path()
      local original_path = cache.path
      cache.path = function(_) return tmp_path end

      cache.save({}, highlights)
      local loaded = cache.load({})

      cache.path = original_path

      assert.is_not_nil(loaded)
      assert.equals("#c8cfe8", loaded.Normal.fg)
      assert.equals("#0d1220", loaded.Normal.bg)
      assert.equals("#5566aa", loaded.Comment.fg)
      assert.is_true(loaded.Comment.italic)
      assert.is_false(loaded["@keyword"].bold)
    end)
  end)
end)
