local M = {}

function M.get(c, opts)
	local hl = {}

	-- Transparent-aware backgrounds: float for overlays, sidebar for the panel itself
	local bg_float = opts.transparent and c.none or c.bg_float
	local bg_sidebar = opts.transparent and c.none or c.bg

	-- Panel chrome (window, separator, status)
	hl.NeoTreeNormal = { fg = c.fg, bg = bg_sidebar }
	hl.NeoTreeNormalNC = { fg = c.fg_dim, bg = bg_sidebar }
	hl.NeoTreeVertSplit = { fg = c.sel, bg = bg_sidebar }
	hl.NeoTreeWinSeparator = { fg = c.sel, bg = bg_sidebar }
	hl.NeoTreeStatusLine = { link = "StatusLine" }
	hl.NeoTreeSignColumn = { fg = c.fg_dim, bg = bg_sidebar }
	hl.NeoTreeEndOfBuffer = { fg = c.sel, bg = bg_sidebar }

	-- File tree items
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

	-- Git status per file (untracked = orange, distinct from ignored = fg_dim)
	hl.NeoTreeGitAdded = { fg = c.green }
	hl.NeoTreeGitConflict = { fg = c.red, bold = true }
	hl.NeoTreeGitDeleted = { fg = c.red }
	hl.NeoTreeGitIgnored = { fg = c.fg_dim }
	hl.NeoTreeGitModified = { fg = c.yellow }
	hl.NeoTreeGitRenamed = { fg = c.purple }
	hl.NeoTreeGitStaged = { fg = c.green, bold = true }
	hl.NeoTreeGitUnstaged = { fg = c.yellow }
	hl.NeoTreeGitUntracked = { fg = c.orange }

	-- Float overlays (search, filter popups)
	hl.NeoTreeFloatBorder = { fg = c.sel, bg = bg_float }
	hl.NeoTreeFloatTitle = { fg = c.yellow, bg = bg_float, bold = true }
	hl.NeoTreeTitleBar = { fg = c.bg, bg = c.blue, bold = true }

	-- Tab bar (when multiple roots/panels are open)
	hl.NeoTreeTabActive = { fg = c.fg, bg = c.sel, bold = true }
	hl.NeoTreeTabInactive = { fg = c.fg_dim, bg = bg_sidebar }
	hl.NeoTreeTabSeparatorActive = { fg = c.sel, bg = c.sel }
	hl.NeoTreeTabSeparatorInactive = { fg = bg_sidebar, bg = bg_sidebar }

	return hl
end

return M
