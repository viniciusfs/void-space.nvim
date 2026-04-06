local palette = require("void-space.palette").get("default")
local theme = require("void-space.theme")

local MODULES = {
	"void-space.highlights.editor",
	"void-space.highlights.syntax",
	"void-space.highlights.treesitter",
	"void-space.highlights.lsp",
	"void-space.highlights.diagnostics",
	"void-space.highlights.bufferline",
	"void-space.highlights.cmp",
	"void-space.highlights.dashboard",
	"void-space.highlights.fidget",
	"void-space.highlights.flash",
	"void-space.highlights.gitsigns",
	"void-space.highlights.illuminate",
	"void-space.highlights.indent",
	"void-space.highlights.lazy",
	"void-space.highlights.mini",
	"void-space.highlights.neo_tree",
	"void-space.highlights.noice",
	"void-space.highlights.notify",
	"void-space.highlights.render_markdown",
	"void-space.highlights.snacks",
	"void-space.highlights.telescope",
	"void-space.highlights.todo_comments",
	"void-space.highlights.trouble",
	"void-space.highlights.which_key",
	"void-space.highlights.legacy",
}

local REQUIRED_GROUPS = {
	"Normal",
	"Comment",
	"Keyword",
	"Function",
	"DiagnosticError",
	"@variable",
	"LspReferenceText",
}

local default_opts = {
	italic_comments = true,
	italic_keywords = false,
	transparent = false,
	dim_inactive = false,
}

describe("void-space.theme", function()
	local result

	it("has a get function", function()
		assert.is_function(theme.get)
	end)

	it("returns more than 100 groups", function()
		result = theme.get(palette, default_opts)
		local count = 0
		for _ in pairs(result) do
			count = count + 1
		end
		assert.is_true(count > 100, ("expected > 100 groups, got %d"):format(count))
	end)

	it("all 25 modules contribute at least one group", function()
		result = result or theme.get(palette, default_opts)
		for _, mod_name in ipairs(MODULES) do
			local mod_result = require(mod_name).get(palette, default_opts)
			local contributed = false
			for group in pairs(mod_result) do
				if result[group] ~= nil then
					contributed = true
					break
				end
			end
			assert.is_true(contributed, ("module %s contributed no groups to the merged output"):format(mod_name))
		end
	end)

	it("no two modules define the same group", function()
		local seen = {}
		for _, mod_name in ipairs(MODULES) do
			local mod_result = require(mod_name).get(palette, default_opts)
			for group in pairs(mod_result) do
				assert.is_nil(
					seen[group],
					("duplicate group %q defined in both %s and %s"):format(group, seen[group] or "", mod_name)
				)
				seen[group] = mod_name
			end
		end
	end)

	it("contains all required core groups", function()
		result = result or theme.get(palette, default_opts)
		for _, group in ipairs(REQUIRED_GROUPS) do
			assert.is_not_nil(result[group], ("required group %q is missing from theme output"):format(group))
		end
	end)
end)
