local M = {}

function M.get(c, opts)
	local hl = {}

	hl.IblIndent = { fg = c.sel }
	hl.IblScope = { fg = c.fg_dim }
	hl.IblWhitespace = { fg = c.sel }

	hl.IndentBlanklineChar = { fg = c.sel }
	hl.IndentBlanklineContextChar = { fg = c.fg_dim }
	hl.IndentBlanklineContextStart = { sp = c.fg_dim, underline = true }
	hl.IndentBlanklineSpaceChar = { link = "Whitespace" }

	return hl
end

return M
