local M = {}

function M.get(c, opts)
	local hl = {}

	hl.BufferLineFill = { bg = c.bg_dark }
	hl.BufferLineBackground = { fg = c.fg_dim, bg = c.bg_dark }
	hl.BufferLineSeparator = { fg = c.bg_dark, bg = c.bg_dark }
	hl.BufferLineSeparatorVisible = { fg = c.bg_dark, bg = c.bg_dark }
	hl.BufferLineSeparatorSelected = { fg = c.bg_dark, bg = c.bg }
	hl.BufferLineIndicatorSelected = { fg = c.blue, bg = c.bg }
	hl.BufferLineOffsetSeparator = { fg = c.sel, bg = c.bg_dark }

	hl.BufferLineBufferVisible = { fg = c.fg_dim, bg = c.bg_dark }
	hl.BufferLineBufferSelected = { fg = c.fg, bg = c.bg, bold = true, italic = false }

	hl.BufferLineTab = { fg = c.fg_dim, bg = c.bg_dark }
	hl.BufferLineTabSelected = { fg = c.fg, bg = c.bg, bold = true }
	hl.BufferLineTabClose = { fg = c.red, bg = c.bg_dark }
	hl.BufferLineTabSeparator = { fg = c.bg_dark, bg = c.bg_dark }
	hl.BufferLineTabSeparatorSelected = { fg = c.bg_dark, bg = c.bg }

	hl.BufferLineNumbers = { fg = c.fg_dim, bg = c.bg_dark }
	hl.BufferLineNumbersVisible = { fg = c.fg_dim, bg = c.bg_dark }
	hl.BufferLineNumbersSelected = { fg = c.fg, bg = c.bg, bold = true }

	hl.BufferLineModified = { fg = c.yellow, bg = c.bg_dark }
	hl.BufferLineModifiedVisible = { fg = c.yellow, bg = c.bg_dark }
	hl.BufferLineModifiedSelected = { fg = c.yellow, bg = c.bg }

	hl.BufferLineError = { fg = c.red, bg = c.bg_dark }
	hl.BufferLineErrorVisible = { fg = c.red, bg = c.bg_dark }
	hl.BufferLineErrorSelected = { fg = c.red, bg = c.bg }
	hl.BufferLineErrorDiagnostic = { fg = c.red, bg = c.bg_dark }
	hl.BufferLineErrorDiagnosticSelected = { fg = c.red, bg = c.bg }

	hl.BufferLineWarning = { fg = c.yellow, bg = c.bg_dark }
	hl.BufferLineWarningVisible = { fg = c.yellow, bg = c.bg_dark }
	hl.BufferLineWarningSelected = { fg = c.yellow, bg = c.bg }
	hl.BufferLineWarningDiagnostic = { fg = c.yellow, bg = c.bg_dark }
	hl.BufferLineWarningDiagnosticSelected = { fg = c.yellow, bg = c.bg }

	hl.BufferLineInfo = { fg = c.blue, bg = c.bg_dark }
	hl.BufferLineInfoSelected = { fg = c.blue, bg = c.bg }
	hl.BufferLineInfoDiagnostic = { fg = c.blue, bg = c.bg_dark }
	hl.BufferLineInfoDiagnosticSelected = { fg = c.blue, bg = c.bg }

	hl.BufferLineHint = { fg = c.cyan, bg = c.bg_dark }
	hl.BufferLineHintSelected = { fg = c.cyan, bg = c.bg }
	hl.BufferLineHintDiagnostic = { fg = c.cyan, bg = c.bg_dark }
	hl.BufferLineHintDiagnosticSelected = { fg = c.cyan, bg = c.bg }

	hl.BufferLineClose = { fg = c.fg_dim, bg = c.bg_dark }
	hl.BufferLineCloseVisible = { fg = c.fg_dim, bg = c.bg_dark }
	hl.BufferLineCloseSelected = { fg = c.red, bg = c.bg }

	hl.BufferLinePickSelected = { fg = c.pink, bg = c.bg, bold = true, italic = true }
	hl.BufferLinePick = { fg = c.pink, bg = c.bg_dark, bold = true, italic = true }
	hl.BufferLinePickVisible = { fg = c.pink, bg = c.bg_dark, bold = true, italic = true }

	hl.BufferLineGroupLabel = { fg = c.bg_dark, bg = c.purple }
	hl.BufferLineGroupSeparator = { fg = c.purple, bg = c.bg_dark }

	hl.BufferLineDuplicate = { fg = c.sel, bg = c.bg_dark }
	hl.BufferLineDuplicateVisible = { fg = c.sel, bg = c.bg_dark }
	hl.BufferLineDuplicateSelected = { fg = c.fg_dim, bg = c.bg }

	return hl
end

return M
