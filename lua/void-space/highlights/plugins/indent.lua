local M = {}

function M.get(c, opts)
	local hl = {}

	-- indent-blankline v3 API groups
	hl.IblIndent = { fg = c.sel }
	hl.IblScope = { fg = c.fg_dim }
	hl.IblWhitespace = { fg = c.sel }

	-- indent-blankline v2 legacy API groups (kept for compatibility)
	hl.IndentBlanklineChar = { fg = c.sel }
	hl.IndentBlanklineContextChar = { fg = c.fg_dim }
	hl.IndentBlanklineContextStart = { sp = c.fg_dim, underline = true }
	hl.IndentBlanklineSpaceChar = { link = "Whitespace" }

	return hl
end

return M
