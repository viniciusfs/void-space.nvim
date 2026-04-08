-- Minimal vim stub for testing init.lua without Neovim
local hl_calls = {}
local g_store = {}
local o_store = {}

_G.vim = {
	tbl_deep_extend = function(mode, base, ...)
		local result = {}
		for k, v in pairs(base) do
			result[k] = v
		end
		for _, tbl in ipairs({ ... }) do
			for k, v in pairs(tbl) do
				result[k] = v
			end
		end
		return result
	end,
	version = function()
		return { minor = 10 }
	end,
	cmd = function() end,
	fn = {
		exists = function()
			return 0
		end,
		stdpath = function(what)
			if what == "cache" then
				return "/tmp/nvim-test-cache"
			end
			return "/tmp"
		end,
		mkdir = function() end,
		glob = function() return "" end,
		delete = function() end,
	},
	log = { levels = { WARN = 2, INFO = 2 } },
	notify = function() end,
	api = {
		nvim_set_hl = function(ns, group, spec)
			table.insert(hl_calls, { ns = ns, group = group, spec = spec })
		end,
		nvim_create_user_command = function() end,
	},
	o = setmetatable({}, {
		__newindex = function(_, k, v)
			o_store[k] = v
		end,
		__index = function(_, k)
			return o_store[k]
		end,
	}),
	g = setmetatable({}, {
		__newindex = function(_, k, v)
			g_store[k] = v
		end,
		__index = function(_, k)
			return g_store[k]
		end,
	}),
}

-- Ensure init module is freshly loaded
package.loaded["void-space"] = nil
local M = require("void-space")

describe("void-space init", function()
	before_each(function()
		hl_calls = {}
		g_store = {}
		o_store = {}
		-- Reset module config to defaults
		M.config = {
			variant = "default",
			italic_comments = true,
			italic_keywords = false,
			transparent = false,
			dim_inactive = false,
			on_highlights = nil,
		}
	end)

	it("default config has correct values", function()
		assert.equals("default", M.config.variant)
		assert.equals(true, M.config.italic_comments)
		assert.equals(false, M.config.italic_keywords)
		assert.equals(false, M.config.transparent)
		assert.equals(false, M.config.dim_inactive)
		assert.is_nil(M.config.on_highlights)
	end)

	it("setup() merges options and preserves defaults", function()
		M.setup({ italic_comments = false })
		assert.equals(false, M.config.italic_comments)
		assert.equals(false, M.config.italic_keywords) -- untouched
		assert.equals(false, M.config.transparent) -- untouched
		assert.equals(false, M.config.dim_inactive) -- untouched
	end)

	it("load() calls nvim_set_hl more than 100 times", function()
		M.load()
		assert.is_true(#hl_calls > 100, ("expected > 100 nvim_set_hl calls, got %d"):format(#hl_calls))
	end)

	it("load() applies a Normal group", function()
		M.load()
		local found = false
		for _, call in ipairs(hl_calls) do
			if call.group == "Normal" then
				found = true
				break
			end
		end
		assert.is_true(found, "Normal highlight was not applied")
	end)

	it("load() sets vim.g.terminal_color_0 to palette.bg", function()
		local palette = require("void-space.palette").get()
		M.load()
		assert.equals(palette.bg, g_store.terminal_color_0)
	end)

	it("on_highlights callback can mutate highlights before application", function()
		M.setup({
			on_highlights = function(hl, _)
				hl.Normal = { fg = "#ffffff", bg = "#000000" }
			end,
		})
		M.load()
		local normal_spec
		for _, call in ipairs(hl_calls) do
			if call.group == "Normal" then
				normal_spec = call.spec
				break
			end
		end
		assert.is_not_nil(normal_spec)
		assert.equals("#ffffff", normal_spec.fg)
		assert.equals("#000000", normal_spec.bg)
	end)

	it("load() returns early when vim.version().minor < 8", function()
		vim.version = function()
			return { minor = 7 }
		end
		M.load()
		assert.equals(0, #hl_calls)
		vim.version = function()
			return { minor = 10 }
		end
	end)

	it("setup() with empty table preserves all defaults", function()
		M.setup({})
		assert.equals(true, M.config.italic_comments)
		assert.equals(false, M.config.italic_keywords)
		assert.equals(false, M.config.transparent)
		assert.equals(false, M.config.dim_inactive)
	end)

  describe("cache integration", function()
    after_each(function()
      package.loaded["void-space.cache"] = nil
    end)

    it("applies highlights from cache and skips theme.get() on cache hit", function()
      local theme_called = false
      local cached_hl = { Normal = { fg = "#aabbcc", bg = "#112233" } }

      package.loaded["void-space.cache"] = {
        load = function(_) return cached_hl end,
        save = function() end,
        clear = function() end,
      }
      local original_theme = package.loaded["void-space.theme"]
      package.loaded["void-space.theme"] = {
        get = function() theme_called = true; return {} end,
      }

      hl_calls = {}
      M.load()

      package.loaded["void-space.theme"] = original_theme
      assert.is_false(theme_called, "theme.get() should not be called on cache hit")
      local found = false
      for _, call in ipairs(hl_calls) do
        if call.group == "Normal" and call.spec.fg == "#aabbcc" then
          found = true; break
        end
      end
      assert.is_true(found, "cached Normal highlight should be applied")
    end)

    it("calls cache.save() on cache miss", function()
      local save_called = false

      package.loaded["void-space.cache"] = {
        load = function(_) return nil end,
        save = function() save_called = true end,
        clear = function() end,
      }

      hl_calls = {}
      M.load()

      assert.is_true(save_called, "cache.save() should be called on cache miss")
    end)
  end)
end)
