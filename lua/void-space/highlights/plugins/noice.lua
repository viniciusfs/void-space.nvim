local M = {}

function M.get(c, opts)
	local hl = {}

	-- Transparent-aware backgrounds for inline and float surfaces
	local bg_normal = opts.transparent and c.none or c.bg
	local bg_float = opts.transparent and c.none or c.bg_float

	-- Command-line area (rendered in the status line area)
	hl.NoiceCmdline = { fg = c.fg, bg = bg_normal }
	hl.NoiceCmdlineIcon = { fg = c.cyan }
	hl.NoiceCmdlineIconSearch = { fg = c.yellow }
	-- Command-line popup float (replaces the built-in cmdline)
	hl.NoiceCmdlinePopup = { fg = c.fg, bg = bg_float }
	hl.NoiceCmdlinePopupBorder = { fg = c.sel, bg = bg_float }
	hl.NoiceCmdlinePopupTitle = { fg = c.yellow, bold = true }
	hl.NoiceCmdlinePrompt = { fg = c.cyan }
	-- Confirm dialog float
	hl.NoiceConfirm = { fg = c.fg, bg = bg_float }
	hl.NoiceConfirmBorder = { fg = c.yellow, bg = bg_float }
	-- Mini notification bar (bottom-right message; bg_float-based)
	hl.NoiceMini = { fg = c.fg, bg = bg_float }
	-- Generic popup float
	hl.NoicePopup = { fg = c.fg, bg = bg_float }
	hl.NoicePopupBorder = { fg = c.sel, bg = bg_float }
	-- Completion/command popup menu (sel-based, always visible)
	hl.NoicePopupmenu = { fg = c.fg, bg = c.sel }
	hl.NoicePopupmenuBorder = { fg = c.sel, bg = c.sel }
	hl.NoicePopupmenuMatch = { fg = c.yellow, bold = true }
	hl.NoicePopupmenuSelected = { fg = c.bg, bg = c.blue }
	-- Split-window messages
	hl.NoiceSplit = { fg = c.fg, bg = bg_normal }
	hl.NoiceSplitBorder = { fg = c.sel }
	-- Scrollbar chrome
	hl.NoiceScrollbar = { bg = c.sel }
	hl.NoiceScrollbarThumb = { bg = c.fg }
	-- LSP progress indicators
	hl.NoiceLspProgressSpinner = { fg = c.cyan }
	hl.NoiceLspProgressTitle = { fg = c.yellow }
	hl.NoiceLspProgressClient = { fg = c.fg_dim }
	hl.NoiceFormatProgressTodo = { fg = c.fg_dim }
	hl.NoiceFormatProgressDone = { fg = c.green }

	return hl
end

return M
