local palette = require("void-space.palette").get("default")

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

local KNOWN_KEYS = {
	fg = true,
	bg = true,
	sp = true,
	bold = true,
	italic = true,
	underline = true,
	undercurl = true,
	strikethrough = true,
	reverse = true,
	nocombine = true,
	link = true,
}

local default_opts = {
	italic_comments = true,
	italic_keywords = false,
	transparent = false,
	dim_inactive = false,
}

-- Collect all palette color values for validation
local palette_values = {}
for _, v in pairs(palette) do
	palette_values[v] = true
end

for _, mod_name in ipairs(MODULES) do
	describe(mod_name, function()
		local mod = require(mod_name)
		local result

		it("has a get function", function()
			assert.is_function(mod.get)
		end)

		it("get(palette, opts) returns a non-empty table", function()
			result = mod.get(palette, default_opts)
			assert.is_table(result)
			local count = 0
			for _ in pairs(result) do
				count = count + 1
			end
			assert.is_true(count > 0, "module returned empty table")
		end)

		it("every group name is a non-empty string", function()
			result = result or mod.get(palette, default_opts)
			for group in pairs(result) do
				assert.is_string(group)
				assert.is_true(#group > 0, "empty group name found")
			end
		end)

		it("every spec is a table", function()
			result = result or mod.get(palette, default_opts)
			for group, spec in pairs(result) do
				assert.is_table(spec, ("spec for %q is not a table"):format(group))
			end
		end)

		it("specs only contain known keys", function()
			result = result or mod.get(palette, default_opts)
			for group, spec in pairs(result) do
				for k in pairs(spec) do
					assert.is_truthy(KNOWN_KEYS[k], ("unknown key %q in group %q"):format(k, group))
				end
			end
		end)

		it("link specs have only the link key", function()
			result = result or mod.get(palette, default_opts)
			for group, spec in pairs(result) do
				if spec.link ~= nil then
					local count = 0
					for _ in pairs(spec) do
						count = count + 1
					end
					assert.equals(1, count, ("group %q mixes link with other attributes"):format(group))
				end
			end
		end)

		it("fg/bg/sp values are palette colors or NONE", function()
			result = result or mod.get(palette, default_opts)
			for group, spec in pairs(result) do
				for _, attr in ipairs({ "fg", "bg", "sp" }) do
					local v = spec[attr]
					if v ~= nil then
						assert.is_truthy(
							palette_values[v],
							("group %q attr %q = %q is not a palette color"):format(group, attr, v)
						)
					end
				end
			end
		end)
	end)
end
