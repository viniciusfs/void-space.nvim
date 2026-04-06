local M = {}

function M.get(c, opts)
	local hl = {}

	local bg_float = opts.transparent and c.none or c.bg_float

	hl.CmpItemAbbr = { fg = c.fg }
	hl.CmpItemAbbrDeprecated = { fg = c.fg_dim, strikethrough = true }
	hl.CmpItemAbbrMatch = { fg = c.yellow, bold = true }
	hl.CmpItemAbbrMatchFuzzy = { fg = c.yellow }
	hl.CmpItemKind = { fg = c.cyan }
	hl.CmpItemKindDefault = { fg = c.cyan }
	hl.CmpItemMenu = { fg = c.fg_dim }
	hl.CmpGhostText = { fg = c.fg_dim, italic = true }

	hl.CmpItemKindText = { fg = c.fg }
	hl.CmpItemKindMethod = { fg = c.yellow }
	hl.CmpItemKindFunction = { fg = c.yellow }
	hl.CmpItemKindConstructor = { fg = c.blue }
	hl.CmpItemKindField = { fg = c.purple }
	hl.CmpItemKindVariable = { fg = c.fg }
	hl.CmpItemKindClass = { fg = c.orange }
	hl.CmpItemKindInterface = { fg = c.orange }
	hl.CmpItemKindModule = { fg = c.orange }
	hl.CmpItemKindProperty = { fg = c.purple }
	hl.CmpItemKindUnit = { fg = c.red }
	hl.CmpItemKindValue = { fg = c.green }
	hl.CmpItemKindEnum = { fg = c.orange }
	hl.CmpItemKindKeyword = { fg = c.blue }
	hl.CmpItemKindSnippet = { fg = c.pink }
	hl.CmpItemKindColor = { fg = c.pink }
	hl.CmpItemKindFile = { fg = c.blue }
	hl.CmpItemKindReference = { fg = c.red }
	hl.CmpItemKindFolder = { fg = c.blue }
	hl.CmpItemKindEnumMember = { fg = c.red }
	hl.CmpItemKindConstant = { fg = c.red }
	hl.CmpItemKindStruct = { fg = c.orange }
	hl.CmpItemKindEvent = { fg = c.yellow }
	hl.CmpItemKindOperator = { fg = c.cyan }
	hl.CmpItemKindTypeParameter = { fg = c.orange }
	hl.CmpItemKindCopilot = { fg = c.green }

	hl.BlinkCmpMenu = { fg = c.fg, bg = c.sel }
	hl.BlinkCmpMenuBorder = { fg = c.sel, bg = c.sel }
	hl.BlinkCmpMenuSelection = { fg = c.bg, bg = c.blue }
	hl.BlinkCmpScrollBarThumb = { bg = c.fg }
	hl.BlinkCmpScrollBarGutter = { bg = c.sel }
	hl.BlinkCmpLabel = { fg = c.fg }
	hl.BlinkCmpLabelDeprecated = { fg = c.fg_dim, strikethrough = true }
	hl.BlinkCmpLabelMatch = { fg = c.yellow, bold = true }
	hl.BlinkCmpLabelDetail = { fg = c.fg_dim }
	hl.BlinkCmpLabelDescription = { fg = c.fg_dim }
	hl.BlinkCmpKind = { fg = c.cyan }
	hl.BlinkCmpKindText = { link = "CmpItemKindText" }
	hl.BlinkCmpKindMethod = { link = "CmpItemKindMethod" }
	hl.BlinkCmpKindFunction = { link = "CmpItemKindFunction" }
	hl.BlinkCmpKindConstructor = { link = "CmpItemKindConstructor" }
	hl.BlinkCmpKindField = { link = "CmpItemKindField" }
	hl.BlinkCmpKindVariable = { link = "CmpItemKindVariable" }
	hl.BlinkCmpKindClass = { link = "CmpItemKindClass" }
	hl.BlinkCmpKindInterface = { link = "CmpItemKindInterface" }
	hl.BlinkCmpKindModule = { link = "CmpItemKindModule" }
	hl.BlinkCmpKindProperty = { link = "CmpItemKindProperty" }
	hl.BlinkCmpKindUnit = { link = "CmpItemKindUnit" }
	hl.BlinkCmpKindValue = { link = "CmpItemKindValue" }
	hl.BlinkCmpKindEnum = { link = "CmpItemKindEnum" }
	hl.BlinkCmpKindKeyword = { link = "CmpItemKindKeyword" }
	hl.BlinkCmpKindSnippet = { link = "CmpItemKindSnippet" }
	hl.BlinkCmpKindColor = { link = "CmpItemKindColor" }
	hl.BlinkCmpKindFile = { link = "CmpItemKindFile" }
	hl.BlinkCmpKindReference = { link = "CmpItemKindReference" }
	hl.BlinkCmpKindFolder = { link = "CmpItemKindFolder" }
	hl.BlinkCmpKindEnumMember = { link = "CmpItemKindEnumMember" }
	hl.BlinkCmpKindConstant = { link = "CmpItemKindConstant" }
	hl.BlinkCmpKindStruct = { link = "CmpItemKindStruct" }
	hl.BlinkCmpKindEvent = { link = "CmpItemKindEvent" }
	hl.BlinkCmpKindOperator = { link = "CmpItemKindOperator" }
	hl.BlinkCmpKindTypeParameter = { link = "CmpItemKindTypeParameter" }
	hl.BlinkCmpKindCopilot = { link = "CmpItemKindCopilot" }
	hl.BlinkCmpSource = { fg = c.fg_dim }
	hl.BlinkCmpGhostText = { fg = c.fg_dim, italic = true }
	hl.BlinkCmpDoc = { fg = c.fg, bg = bg_float }
	hl.BlinkCmpDocBorder = { fg = c.sel, bg = bg_float }
	hl.BlinkCmpDocSeparator = { fg = c.sel }
	hl.BlinkCmpDocCursorLine = { bg = c.bg_float }
	hl.BlinkCmpSignatureHelp = { fg = c.fg, bg = bg_float }
	hl.BlinkCmpSignatureHelpBorder = { fg = c.sel, bg = bg_float }
	hl.BlinkCmpSignatureHelpActiveParameter = { fg = c.yellow, bold = true }

	return hl
end

return M
