local M = {}

function M.get(c, opts)
	local hl = {}

	hl.gitcommitComment = { fg = c.fg_dim, italic = opts.italic_comments }
	hl.gitcommitOnBranch = { fg = c.fg_dim, italic = opts.italic_comments }
	hl.gitcommitFile = { fg = c.cyan }
	hl.gitcommitHeader = { fg = c.purple }
	hl.gitcommitBranch = { fg = c.orange }
	hl.gitcommitUnmerged = { fg = c.green }
	hl.gitcommitUntrackedFile = { fg = c.cyan }
	hl.gitcommitSelectedFile = { fg = c.green }
	hl.gitcommitDiscardedFile = { fg = c.red }
	hl.gitcommitUnmergedFile = { fg = c.yellow }
	hl.gitcommitSelectedType = { fg = c.green }
	hl.gitcommitDiscardedType = { fg = c.red }

	hl.cssAttrComma = { fg = c.green }
	hl.cssAttributeSelector = { fg = c.green }
	hl.cssBraces = { fg = c.fg }
	hl.cssClassName = { fg = c.orange }
	hl.cssClassNameDot = { fg = c.orange }
	hl.cssIdentifier = { fg = c.yellow }
	hl.cssImportant = { fg = c.purple }
	hl.cssMediaType = { fg = c.purple }
	hl.cssProp = { fg = c.fg }
	hl.cssSelectorOp = { fg = c.blue }
	hl.cssSelectorOp2 = { fg = c.blue }
	hl.sassAmpersand = { fg = c.blue }
	hl.sassClass = { fg = c.orange }
	hl.sassClassChar = { fg = c.orange }
	hl.lessAmpersand = { fg = c.blue }
	hl.lessClass = { fg = c.orange }
	hl.lessClassChar = { fg = c.orange }
	hl.lessFunction = { fg = c.yellow }
	hl.lessCssAttribute = { fg = c.fg }

	hl.htmlArg = { fg = c.yellow }
	hl.htmlEndTag = { fg = c.purple }
	hl.htmlTag = { fg = c.purple }
	hl.htmlTagName = { fg = c.blue }
	hl.htmlTitle = { fg = c.fg }

	hl.javaScriptBraces = { fg = c.fg }
	hl.javaScriptIdentifier = { fg = c.blue }
	hl.javaScriptFunction = { fg = c.blue }
	hl.javaScriptNumber = { fg = c.red }
	hl.javaScriptReserved = { fg = c.blue }
	hl.javaScriptRequire = { fg = c.cyan }
	hl.javaScriptNull = { fg = c.red }

	hl.rubyBlockParameterList = { fg = c.purple }
	hl.rubyInterpolationDelimiter = { fg = c.purple }
	hl.rubyStringDelimiter = { fg = c.green }
	hl.rubyRegexpSpecial = { fg = c.cyan }

	return hl
end

return M
