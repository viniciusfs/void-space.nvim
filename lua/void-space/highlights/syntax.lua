local M = {}

function M.get(c, opts)
	local hl = {}

	local bg_normal = opts.transparent and c.none or c.bg

	-- Comments
	hl.Comment = { fg = c.comment, italic = opts.italic_comments }
	hl.SpecialComment = { fg = c.comment, italic = opts.italic_comments }

	-- Literals
	hl.Constant = { fg = c.constant }
	hl.String = { fg = c.string_lit }
	hl.Character = { fg = c.string_lit }
	hl.Number = { fg = c.constant }
	hl.Float = { fg = c.constant }
	hl.Boolean = { fg = c.constant }

	-- Identifiers & functions
	-- Identifier uses fg (plain text) — c.type_name is reserved for type names only.
	hl.Identifier = { fg = c.fg }
	hl.Function = { fg = c.func }

	-- Keywords & control flow
	hl.Statement = { fg = c.keyword }
	hl.Conditional = { fg = c.keyword, italic = opts.italic_keywords }
	hl.Repeat = { fg = c.keyword, italic = opts.italic_keywords }
	hl.Label = { fg = c.keyword }
	hl.Keyword = { fg = c.keyword, italic = opts.italic_keywords }
	-- Exception uses keyword color (blue): try/catch/throw are control flow keywords
	hl.Exception = { fg = c.keyword }
	hl.Operator = { fg = c.operator }

	-- Preprocessor
	hl.PreProc = { fg = c.special }
	hl.Include = { fg = c.special }
	hl.Define = { fg = c.keyword }
	hl.Macro = { fg = c.keyword }
	hl.PreCondit = { fg = c.special }

	-- Types
	hl.Type = { fg = c.type }
	hl.StorageClass = { fg = c.keyword }
	hl.Structure = { fg = c.keyword }
	hl.Typedef = { fg = c.type }

	-- Special characters & tags
	hl.Special = { fg = c.special }
	hl.SpecialChar = { fg = c.special }
	hl.Tag = { fg = c.yellow }
	-- Delimiter uses plain fg to stay low-noise — punctuation should not distract.
	hl.Delimiter = { fg = c.fg }

	-- Formatting
	hl.Underlined = { fg = c.blue, underline = true }
	hl.Bold = { bold = true }
	hl.Italic = { italic = true }
	hl.Error = { fg = c.error, bold = true }
	hl.Todo = { fg = c.pink, bg = bg_normal, bold = true }

	return hl
end

return M
