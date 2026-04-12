-- void-space theme — orchestrator
-- Merges all highlight modules into a single table returned to init.lua.
-- To add or update groups for a specific plugin, edit its file under
-- lua/void-space/highlights/.

local M = {}

-- Load order: core first, then plugins alphabetically.
local MODULES = {
	-- Core
	"void-space.highlights.editor",
	"void-space.highlights.syntax",
	"void-space.highlights.treesitter",
	"void-space.highlights.lsp",
	"void-space.highlights.diagnostics",
	-- Plugins
	"void-space.highlights.plugins.bufferline",
	"void-space.highlights.plugins.cmp",
	"void-space.highlights.plugins.dashboard",
	"void-space.highlights.plugins.fidget",
	"void-space.highlights.plugins.flash",
	"void-space.highlights.plugins.gitsigns",
	"void-space.highlights.plugins.illuminate",
	"void-space.highlights.plugins.indent",
	"void-space.highlights.plugins.lazy",
	"void-space.highlights.plugins.mini",
	"void-space.highlights.plugins.neo_tree",
	"void-space.highlights.plugins.noice",
	"void-space.highlights.plugins.notify",
	"void-space.highlights.plugins.render_markdown",
	"void-space.highlights.plugins.snacks",
	"void-space.highlights.plugins.telescope",
	"void-space.highlights.plugins.todo_comments",
	"void-space.highlights.plugins.trouble",
	"void-space.highlights.plugins.which_key",
	-- Legacy syntax groups (CSS, HTML, JS, Ruby, git commit)
	"void-space.highlights.plugins.legacy",
}

---@param c table palette
---@param opts table user config
---@return table highlights
function M.get(c, opts)
	local hl = {}

	for _, mod in ipairs(MODULES) do
		for group, spec in pairs(require(mod).get(c, opts)) do
			hl[group] = spec
		end
	end

	return hl
end

return M
