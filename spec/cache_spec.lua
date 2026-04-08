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
end)
