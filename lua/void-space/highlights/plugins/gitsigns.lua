local M = {}

function M.get(c, opts)
	local hl = {}

	local bg_sidebar = opts.transparent and c.none or c.bg
	local bg_ln = opts.transparent and c.none or c.bg_float

	hl.GitSignsAdd = { fg = c.green, bg = bg_sidebar }
	hl.GitSignsChange = { fg = c.yellow, bg = bg_sidebar }
	hl.GitSignsDelete = { fg = c.red, bg = bg_sidebar }
	hl.GitSignsTopdelete = { fg = c.red, bg = bg_sidebar }
	hl.GitSignsChangedelete = { fg = c.orange, bg = bg_sidebar }
	hl.GitSignsUntracked = { fg = c.fg_dim, bg = bg_sidebar }
	hl.GitSignsAddNr = { link = "GitSignsAdd" }
	hl.GitSignsChangeNr = { link = "GitSignsChange" }
	hl.GitSignsDeleteNr = { link = "GitSignsDelete" }
	hl.GitSignsAddLn = { bg = bg_ln }
	hl.GitSignsChangeLn = { bg = bg_ln }
	hl.GitSignsDeleteLn = { bg = bg_ln }
	hl.GitSignsCurrentLineBlame = { fg = c.fg_dim, italic = opts.italic_comments }

	return hl
end

return M
