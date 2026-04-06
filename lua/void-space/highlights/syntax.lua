local M = {}

function M.get(c, opts)
	local hl = {}

	local bg_normal = opts.transparent and c.none or c.bg

	hl.Comment = { fg = c.comment, italic = opts.italic_comments }
	hl.SpecialComment = { fg = c.comment, italic = opts.italic_comments }

	hl.Constant = { fg = c.constant }
	hl.String = { fg = c.string_lit }
	hl.Character = { fg = c.string_lit }
	hl.Number = { fg = c.constant }
	hl.Float = { fg = c.constant }
	hl.Boolean = { fg = c.constant }

	hl.Identifier = { fg = c.type_name }
	hl.Function = { fg = c.func }

	hl.Statement = { fg = c.keyword }
	hl.Conditional = { fg = c.keyword, italic = opts.italic_keywords }
	hl.Repeat = { fg = c.keyword, italic = opts.italic_keywords }
	hl.Label = { fg = c.keyword }
	hl.Keyword = { fg = c.keyword, italic = opts.italic_keywords }
	hl.Exception = { fg = c.purple }
	hl.Operator = { fg = c.operator }

	hl.PreProc = { fg = c.special }
	hl.Include = { fg = c.special }
	hl.Define = { fg = c.keyword }
	hl.Macro = { fg = c.keyword }
	hl.PreCondit = { fg = c.special }

	hl.Type = { fg = c.type }
	hl.StorageClass = { fg = c.keyword }
	hl.Structure = { fg = c.keyword }
	hl.Typedef = { fg = c.type }

	hl.Special = { fg = c.special }
	hl.SpecialChar = { fg = c.special }
	hl.Tag = { fg = c.yellow }
	hl.Delimiter = { fg = c.fg }

	hl.Underlined = { fg = c.blue, underline = true }
	hl.Bold = { bold = true }
	hl.Italic = { italic = true }
	hl.Error = { fg = c.error, bold = true }
	hl.Todo = { fg = c.pink, bg = bg_normal, bold = true }

	return hl
end

return M
