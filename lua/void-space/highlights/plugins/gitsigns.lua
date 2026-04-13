local M = {}

function M.get(c, opts)
	local hl = {}

	-- Sign column backgrounds (transparent-aware)
	local bg_sidebar = opts.transparent and c.none or c.bg
	-- Line background tints for changed lines (transparent-aware)
	local bg_ln = opts.transparent and c.none or c.bg_float

	-- Sign column markers
	hl.GitSignsAdd = { fg = c.green, bg = bg_sidebar }
	hl.GitSignsChange = { fg = c.yellow, bg = bg_sidebar }
	hl.GitSignsDelete = { fg = c.red, bg = bg_sidebar }
	hl.GitSignsTopdelete = { fg = c.red, bg = bg_sidebar }
	-- Changedelete: line was modified then partially deleted — orange sits between change and delete
	hl.GitSignsChangedelete = { fg = c.orange, bg = bg_sidebar }
	-- Untracked files are dim in the gutter
	hl.GitSignsUntracked = { fg = c.fg_dim, bg = bg_sidebar }
	-- Number column variants (link to base sign groups)
	hl.GitSignsAddNr = { link = "GitSignsAdd" }
	hl.GitSignsChangeNr = { link = "GitSignsChange" }
	hl.GitSignsDeleteNr = { link = "GitSignsDelete" }
	-- Line background tints (full-line highlight on changed lines)
	hl.GitSignsAddLn = { bg = bg_ln }
	hl.GitSignsChangeLn = { bg = bg_ln }
	hl.GitSignsDeleteLn = { bg = bg_ln }
	-- Inline blame annotation — italic follows opts.italic_comments
	hl.GitSignsCurrentLineBlame = { fg = c.fg_dim, italic = opts.italic_comments }

	return hl
end

return M
