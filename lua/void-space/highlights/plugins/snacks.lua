local M = {}

function M.get(c, opts)
	local hl = {}

	-- Transparent-aware backgrounds
	local bg_normal = opts.transparent and c.none or c.bg
	local bg_float = opts.transparent and c.none or c.bg_float

	-- Core float chrome (links to built-in float groups)
	hl.SnacksNormal = { link = "NormalFloat" }
	hl.SnacksNormalNC = { link = "NormalFloat" }
	hl.SnacksWinBar = { link = "WinBar" }
	hl.SnacksBackdrop = { bg = c.bg_dark }
	hl.SnacksScratch = { link = "NormalFloat" }
	hl.SnacksScratchKey = { fg = c.cyan }

	-- Picker: float chrome
	hl.SnacksPickerNormal = { fg = c.fg, bg = bg_float }
	hl.SnacksPickerBorder = { fg = c.blue, bg = bg_float }
	hl.SnacksPickerTitle = { fg = c.bg, bg = c.blue, bold = true }
	hl.SnacksPickerPrompt = { fg = c.cyan }
	-- Picker: input pane (prompt area — same bg_float as body)
	hl.SnacksPickerInput = { fg = c.fg, bg = bg_float }
	hl.SnacksPickerInputBorder = { fg = c.blue, bg = bg_float }
	-- Picker: results list pane
	hl.SnacksPickerList = { fg = c.fg, bg = bg_float }
	hl.SnacksPickerListBorder = { fg = c.sel, bg = bg_float }
	-- Picker: preview pane — intentionally always darker (bg_dark), not transparent-aware
	hl.SnacksPickerPreview = { fg = c.fg, bg = c.bg_dark }
	hl.SnacksPickerPreviewBorder = { fg = c.bg_dark, bg = c.bg_dark }
	hl.SnacksPickerPreviewTitle = { fg = c.bg, bg = c.cyan, bold = true }
	-- Picker: match highlighting and selection state
	hl.SnacksPickerMatch = { fg = c.yellow, bold = true }
	hl.SnacksPickerSelected = { fg = c.purple }
	hl.SnacksPickerCursor = { link = "Cursor" }
	hl.SnacksPickerDir = { fg = c.fg_dim }
	hl.SnacksPickerFile = { fg = c.fg }
	hl.SnacksPickerRow = { fg = c.fg_dim }
	hl.SnacksPickerCol = { fg = c.fg_dim }
	hl.SnacksPickerSearch = { fg = c.yellow }
	hl.SnacksPickerPathHidden = { fg = c.fg_dim }
	-- Picker: file metadata (path, row, col annotations)
	hl.SnacksPickerDir = { fg = c.fg_dim }
	-- Picker: filter flags and controls
	hl.SnacksPickerToggle = { fg = c.cyan }
	hl.SnacksPickerFlagBuf = { fg = c.blue }
	hl.SnacksPickerFlagPin = { fg = c.yellow }

	-- Notifier: severity borders (error/warn/info/debug/trace)
	hl.SnacksNotifierBorderError = { fg = c.red }
	hl.SnacksNotifierBorderWarn = { fg = c.yellow }
	hl.SnacksNotifierBorderInfo = { fg = c.blue }
	hl.SnacksNotifierBorderDebug = { fg = c.fg_dim }
	hl.SnacksNotifierBorderTrace = { fg = c.purple }
	-- Notifier: severity icons
	hl.SnacksNotifierIconError = { fg = c.red }
	hl.SnacksNotifierIconWarn = { fg = c.yellow }
	hl.SnacksNotifierIconInfo = { fg = c.blue }
	hl.SnacksNotifierIconDebug = { fg = c.fg_dim }
	hl.SnacksNotifierIconTrace = { fg = c.purple }
	-- Notifier: severity titles
	hl.SnacksNotifierTitleError = { fg = c.red, bold = true }
	hl.SnacksNotifierTitleWarn = { fg = c.yellow, bold = true }
	hl.SnacksNotifierTitleInfo = { fg = c.blue, bold = true }
	hl.SnacksNotifierTitleDebug = { fg = c.fg_dim, bold = true }
	hl.SnacksNotifierTitleTrace = { fg = c.purple, bold = true }
	-- Notifier: body (transparent-aware bg_float)
	hl.SnacksNotifierNormal = { fg = c.fg, bg = bg_float }
	hl.SnacksNotifierFooter = { fg = c.fg_dim }

	-- Dashboard (home screen)
	hl.SnacksDashboardNormal = { fg = c.fg, bg = bg_normal }
	hl.SnacksDashboardHeader = { fg = c.blue }
	hl.SnacksDashboardFooter = { fg = c.fg_dim, italic = opts.italic_comments }
	hl.SnacksDashboardTitle = { fg = c.yellow, bold = true }
	hl.SnacksDashboardDesc = { fg = c.fg }
	hl.SnacksDashboardKey = { fg = c.cyan }
	hl.SnacksDashboardIcon = { fg = c.blue }
	hl.SnacksDashboardFile = { fg = c.fg }
	hl.SnacksDashboardDir = { fg = c.fg_dim }
	hl.SnacksDashboardSpecial = { fg = c.orange }

	-- Indent guides (sel color for visual alignment)
	hl.SnacksIndent = { fg = c.sel }
	hl.SnacksIndentScope = { fg = c.fg_dim }
	hl.SnacksIndent1 = { fg = c.sel }
	hl.SnacksIndent2 = { fg = c.sel }
	hl.SnacksIndent3 = { fg = c.sel }
	hl.SnacksIndent4 = { fg = c.sel }
	hl.SnacksIndent5 = { fg = c.sel }
	hl.SnacksIndent6 = { fg = c.sel }
	hl.SnacksIndentChunk = { fg = c.fg_dim }

	-- Scrollbar chrome
	hl.SnacksScrollBar = { bg = c.sel }
	hl.SnacksScrollBarThumb = { bg = c.fg }

	-- Git graph branch colors (accent palette in order)
	hl.SnacksGitGraphBranch1 = { fg = c.blue }
	hl.SnacksGitGraphBranch2 = { fg = c.purple }
	hl.SnacksGitGraphBranch3 = { fg = c.cyan }
	hl.SnacksGitGraphBranch4 = { fg = c.yellow }
	hl.SnacksGitGraphBranch5 = { fg = c.green }

	-- Terminal float, input widget, and zen mode
	hl.SnacksTermNormal = { link = "NormalFloat" }
	hl.SnacksTermTitle = { fg = c.bg, bg = c.orange, bold = true }
	hl.SnacksInputNormal = { fg = c.fg, bg = bg_float }
	hl.SnacksInputBorder = { fg = c.yellow, bg = bg_float }
	hl.SnacksInputTitle = { fg = c.yellow, bold = true }
	hl.SnacksInputIcon = { fg = c.cyan }
	hl.SnacksInputPrompt = { fg = c.cyan }
	hl.SnacksInputCursor = { link = "Cursor" }
	hl.SnacksZenBar = { fg = c.sel }

	return hl
end

return M
