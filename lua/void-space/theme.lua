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
	-- Legacy syntax groups (CSS, HTML, JS, Ruby, git commit)
	"void-space.highlights.legacy",
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
