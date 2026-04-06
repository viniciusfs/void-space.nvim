local M = {}

function M.get(c, opts)
	local hl = {}

	local bg_float = opts.transparent and c.none or c.bg_float
	local bg_sidebar = opts.transparent and c.none or c.bg

	hl.NeoTreeNormal = { fg = c.fg, bg = bg_sidebar }
	hl.NeoTreeNormalNC = { fg = c.fg_dim, bg = bg_sidebar }
	hl.NeoTreeVertSplit = { fg = c.sel, bg = bg_sidebar }
	hl.NeoTreeWinSeparator = { fg = c.sel, bg = bg_sidebar }
	hl.NeoTreeStatusLine = { link = "StatusLine" }
	hl.NeoTreeSignColumn = { fg = c.fg_dim, bg = bg_sidebar }
	hl.NeoTreeEndOfBuffer = { fg = c.sel, bg = bg_sidebar }

	hl.NeoTreeRootName = { fg = c.blue, bold = true }
	hl.NeoTreeDirectoryName = { fg = c.blue }
	hl.NeoTreeDirectoryIcon = { fg = c.blue }
	hl.NeoTreeFileName = { fg = c.fg }
	hl.NeoTreeFileNameOpened = { fg = c.yellow }
	hl.NeoTreeFileIcon = { fg = c.fg }
	hl.NeoTreeSymbolicLinkTarget = { fg = c.cyan }
	hl.NeoTreeIndentMarker = { fg = c.sel }
	hl.NeoTreeDimText = { fg = c.fg_dim }
	hl.NeoTreeFadeText1 = { fg = c.fg_dim }
	hl.NeoTreeFadeText2 = { fg = c.sel }
	hl.NeoTreeHiddenByName = { fg = c.fg_dim }
	hl.NeoTreeDotfile = { fg = c.fg_dim }
	hl.NeoTreeModified = { fg = c.yellow }
	hl.NeoTreeMessage = { fg = c.fg_dim }
	hl.NeoTreeFilterTerm = { fg = c.yellow, bold = true }

	hl.NeoTreeGitAdded = { fg = c.green }
	hl.NeoTreeGitConflict = { fg = c.red, bold = true }
	hl.NeoTreeGitDeleted = { fg = c.red }
	hl.NeoTreeGitIgnored = { fg = c.fg_dim }
	hl.NeoTreeGitModified = { fg = c.yellow }
	hl.NeoTreeGitRenamed = { fg = c.purple }
	hl.NeoTreeGitStaged = { fg = c.green, bold = true }
	hl.NeoTreeGitUnstaged = { fg = c.yellow }
	hl.NeoTreeGitUntracked = { fg = c.orange }

	hl.NeoTreeFloatBorder = { fg = c.sel, bg = bg_float }
	hl.NeoTreeFloatTitle = { fg = c.yellow, bg = bg_float, bold = true }
	hl.NeoTreeTitleBar = { fg = c.bg, bg = c.blue, bold = true }

	hl.NeoTreeTabActive = { fg = c.fg, bg = c.sel, bold = true }
	hl.NeoTreeTabInactive = { fg = c.fg_dim, bg = c.bg }
	hl.NeoTreeTabSeparatorActive = { fg = c.sel, bg = c.sel }
	hl.NeoTreeTabSeparatorInactive = { fg = c.bg, bg = c.bg }

	return hl
end

return M
