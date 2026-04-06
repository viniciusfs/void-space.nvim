local M = {}

---@class VoidSpaceConfig
---@field variant          string   Palette variant name (default: "default")
---@field italic_comments  boolean  Italicize comments (default: true)
---@field italic_keywords  boolean  Italicize keywords/conditionals (default: false)
---@field transparent      boolean  Transparent background (default: false)
---@field dim_inactive     boolean  Dim inactive windows (default: false)
---@field on_highlights    fun(hl: table, c: table)|nil  Override highlights after load

---@type VoidSpaceConfig
M.config = {
	variant = "deep_space",
	italic_comments = true,
	italic_keywords = false,
	transparent = false,
	dim_inactive = false,
	on_highlights = nil,
}

---Configure the color scheme (call before load / colorscheme command).
---@param opts VoidSpaceConfig|nil
function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

---Apply all highlights to the current session.
function M.load()
	if vim.version().minor < 8 then
		vim.notify("void-space: Neovim >= 0.8 required", vim.log.levels.WARN)
		return
	end

	-- Reset
	vim.cmd("hi clear")
	if vim.fn.exists("syntax_on") == 1 then
		vim.cmd("syntax reset")
	end

	vim.o.background = "dark"
	vim.o.termguicolors = true
	vim.g.colors_name = "void-space"

	local palette = require("void-space.palette").get(M.config.variant)
	local theme = require("void-space.theme")

	local highlights = theme.get(palette, M.config)

	-- Allow user overrides
	if type(M.config.on_highlights) == "function" then
		M.config.on_highlights(highlights, palette)
	end

	-- Apply all highlights
	for group, spec in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, spec)
	end

	-- Terminal colors (mapped from canonical palette keys)
	vim.g.terminal_color_0 = palette.bg
	vim.g.terminal_color_8 = palette.bg_float
	vim.g.terminal_color_1 = palette.red
	vim.g.terminal_color_9 = palette.orange
	vim.g.terminal_color_2 = palette.green
	vim.g.terminal_color_10 = palette.green
	vim.g.terminal_color_3 = palette.yellow
	vim.g.terminal_color_11 = palette.bright_yellow
	vim.g.terminal_color_4 = palette.blue
	vim.g.terminal_color_12 = palette.blue
	vim.g.terminal_color_5 = palette.purple
	vim.g.terminal_color_13 = palette.pink
	vim.g.terminal_color_6 = palette.cyan
	vim.g.terminal_color_14 = palette.fg_dim
	vim.g.terminal_color_7 = palette.sel
	vim.g.terminal_color_15 = palette.fg
end

return M
