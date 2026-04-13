local M = {}

function M.get(c, opts)
	local hl = {}

	-- Transparent-aware backgrounds: float for overlays, sidebar for panel/tabline active state
	local bg_float = opts.transparent and c.none or c.bg_float
	local bg_sidebar = opts.transparent and c.none or c.bg

	-- animate, clue, completion, cursorword
	hl.MiniAnimateCursor = { reverse = true, nocombine = true }
	hl.MiniClueSeparator = { fg = c.fg_dim }
	hl.MiniCompletionActiveParameter = { fg = c.yellow, bold = true }
	hl.MiniCursorword = { bg = c.sel }
	hl.MiniCursorwordCurrent = { bg = c.sel }

	-- deps: package manager log (Hint=purple/c.hint, Info=cyan/c.info to match diagnostic semantics)
	hl.MiniDepsChangeAdded = { fg = c.green }
	hl.MiniDepsChangeRemoved = { fg = c.red }
	hl.MiniDepsHint = { fg = c.hint }
	hl.MiniDepsInfo = { fg = c.info }
	hl.MiniDepsMsgBreaking = { fg = c.red, bold = true }
	hl.MiniDepsTitle = { fg = c.yellow, bold = true }
	hl.MiniDepsTitleError = { fg = c.red, bold = true }
	hl.MiniDepsTitleSame = { fg = c.fg_dim }
	hl.MiniDepsTitleUpdate = { fg = c.green, bold = true }

	-- diff: sign column (sidebar-aware) and buffer overlay (float-aware)
	hl.MiniDiffSignAdd = { fg = c.green, bg = bg_sidebar }
	hl.MiniDiffSignChange = { fg = c.yellow, bg = bg_sidebar }
	hl.MiniDiffSignDelete = { fg = c.red, bg = bg_sidebar }
	hl.MiniDiffOverAdd = { bg = bg_float }
	hl.MiniDiffOverChange = { bg = bg_float }
	hl.MiniDiffOverContext = { bg = bg_float }
	hl.MiniDiffOverDelete = { bg = bg_float }

	-- files: file browser float
	hl.MiniFilesBorder = { fg = c.sel, bg = bg_float }
	hl.MiniFilesBorderModified = { fg = c.yellow, bg = bg_float }
	hl.MiniFilesDirectory = { fg = c.blue }
	hl.MiniFilesFile = { fg = c.fg }
	hl.MiniFilesNormal = { fg = c.fg, bg = bg_float }
	hl.MiniFilesTitle = { fg = c.yellow, bg = bg_float, bold = true }
	hl.MiniFilesTitleFocused = { fg = c.bright_yellow, bg = bg_float, bold = true }

	-- hipatterns: comment keyword badges (inverted: dark text on category color)
	hl.MiniHipatternsFixme = { fg = c.bg, bg = c.red, bold = true }
	hl.MiniHipatternsHack = { fg = c.bg, bg = c.yellow, bold = true }
	hl.MiniHipatternsNote = { fg = c.bg, bg = c.cyan, bold = true }
	hl.MiniHipatternsTodo = { fg = c.bg, bg = c.blue, bold = true }

	-- icons: named color groups for icon tinting
	hl.MiniIconsAzure = { fg = c.cyan }
	hl.MiniIconsBlue = { fg = c.blue }
	hl.MiniIconsCyan = { fg = c.cyan }
	hl.MiniIconsGreen = { fg = c.green }
	hl.MiniIconsGrey = { fg = c.fg_dim }
	hl.MiniIconsOrange = { fg = c.orange }
	hl.MiniIconsPurple = { fg = c.purple }
	hl.MiniIconsRed = { fg = c.red }
	hl.MiniIconsYellow = { fg = c.yellow }

	-- indentscope: active scope indicator
	hl.MiniIndentscopeSymbol = { fg = c.fg_dim }
	hl.MiniIndentscopePrefix = { nocombine = true }

	-- jump / jump2d: navigation highlights (inverted badges)
	hl.MiniJump = { fg = c.bg, bg = c.yellow }
	hl.MiniJump2dDim = { fg = c.fg_dim }
	hl.MiniJump2dSpot = { fg = c.bg, bg = c.pink, bold = true }
	hl.MiniJump2dSpotAhead = { fg = c.bg, bg = c.orange }
	hl.MiniJump2dSpotUnique = { fg = c.bg, bg = c.cyan, bold = true }

	-- map: minimap sidebar — intentionally always dark (bg_dark) for visual distinction
	hl.MiniMapNormal = { fg = c.fg_dim, bg = c.bg_dark }
	hl.MiniMapSymbolCount = { fg = c.cyan }
	hl.MiniMapSymbolLine = { fg = c.fg }
	hl.MiniMapSymbolView = { fg = c.fg_dim }

	-- notify: notification float
	hl.MiniNotifyBorder = { fg = c.sel, bg = bg_float }
	hl.MiniNotifyNormal = { fg = c.fg, bg = bg_float }
	hl.MiniNotifyTitle = { fg = c.yellow, bg = bg_float, bold = true }

	-- operator: exchange source region
	hl.MiniOperatorExchangeFrom = { bg = c.sel }

	-- pick: file/command picker float
	hl.MiniPickBorder = { fg = c.sel, bg = bg_float }
	hl.MiniPickBorderBusy = { fg = c.yellow, bg = bg_float }
	hl.MiniPickBorderText = { fg = c.blue, bg = bg_float, bold = true }
	hl.MiniPickHeader = { fg = c.bg, bg = c.blue, bold = true }
	hl.MiniPickIconDirectory = { fg = c.blue }
	hl.MiniPickIconFile = { fg = c.fg }
	hl.MiniPickMatchCurrent = { bg = c.sel }
	hl.MiniPickMatchMarked = { bg = bg_float, bold = true }
	hl.MiniPickMatchRanges = { fg = c.yellow, bold = true }
	hl.MiniPickNormal = { fg = c.fg, bg = bg_float }
	hl.MiniPickPreviewLine = { bg = bg_float }
	hl.MiniPickPreviewRegion = { bg = c.sel }
	hl.MiniPickPrompt = { fg = c.cyan, bg = bg_float }

	-- starter: start screen (home page)
	hl.MiniStarterCurrent = { fg = c.yellow }
	hl.MiniStarterFooter = { fg = c.fg_dim, italic = opts.italic_comments }
	hl.MiniStarterHeader = { fg = c.blue }
	hl.MiniStarterInactive = { fg = c.fg_dim }
	hl.MiniStarterItem = { fg = c.fg }
	hl.MiniStarterItemBullet = { fg = c.fg_dim }
	hl.MiniStarterItemPrefix = { fg = c.yellow }
	hl.MiniStarterQuery = { fg = c.cyan }
	hl.MiniStarterSection = { fg = c.blue, bold = true }

	-- statusline: mode pills and section backgrounds
	hl.MiniStatuslineDevinfo = { fg = c.fg, bg = c.sel }
	hl.MiniStatuslineFileinfo = { fg = c.fg, bg = c.sel }
	hl.MiniStatuslineFilename = { fg = c.fg, bg = bg_float }
	hl.MiniStatuslineFilenameModified = { fg = c.yellow, bg = bg_float, bold = true }
	hl.MiniStatuslineInactive = { fg = c.fg_dim, bg = bg_float }
	hl.MiniStatuslineModeCommand = { fg = c.bg, bg = c.yellow, bold = true }
	hl.MiniStatuslineModeInsert = { fg = c.bg, bg = c.green, bold = true }
	hl.MiniStatuslineModeNormal = { fg = c.bg, bg = c.blue, bold = true }
	hl.MiniStatuslineModeOther = { fg = c.bg, bg = c.cyan, bold = true }
	hl.MiniStatuslineModeReplace = { fg = c.bg, bg = c.red, bold = true }
	hl.MiniStatuslineModeVisual = { fg = c.bg, bg = c.purple, bold = true }

	-- surround: operator highlight
	hl.MiniSurround = { fg = c.bg, bg = c.orange }

	-- tabline: buffer tabs and tab pages section
	hl.MiniTablineCurrent = { fg = c.fg, bg = bg_sidebar, bold = true }
	hl.MiniTablineFill = { bg = bg_float }
	hl.MiniTablineHidden = { fg = c.fg_dim, bg = bg_float }
	hl.MiniTablineModifiedCurrent = { fg = c.yellow, bg = bg_sidebar, bold = true }
	hl.MiniTablineModifiedHidden = { fg = c.yellow, bg = bg_float }
	hl.MiniTablineModifiedVisible = { fg = c.yellow, bg = bg_float }
	hl.MiniTablineTabpagesection = { fg = c.bg, bg = c.blue, bold = true }
	hl.MiniTablineVisible = { fg = c.fg, bg = bg_float }

	-- test: test result indicators
	hl.MiniTestEmphasis = { bold = true }
	hl.MiniTestFail = { fg = c.red, bold = true }
	hl.MiniTestPass = { fg = c.green, bold = true }

	-- trailspace: trailing whitespace marker
	hl.MiniTrailspace = { bg = c.red }

	return hl
end

return M
