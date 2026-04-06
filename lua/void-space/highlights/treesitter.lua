local M = {}

function M.get(c, opts)
	local hl = {}

	local bg_normal = opts.transparent and c.none or c.bg

	-- Variables
	hl["@variable"] = { fg = c.fg }
	hl["@variable.builtin"] = { fg = c.builtin }
	hl["@variable.parameter"] = { fg = c.fg }
	hl["@variable.parameter.builtin"] = { fg = c.builtin }
	hl["@variable.member"] = { fg = c.type_name }

	-- Constants
	hl["@constant"] = { link = "Constant" }
	hl["@constant.builtin"] = { fg = c.constant, bold = true }
	hl["@constant.macro"] = { link = "Constant" }

	-- Modules / namespaces
	hl["@module"] = { fg = c.purple }
	hl["@module.builtin"] = { fg = c.builtin, bold = true }
	hl["@label"] = { fg = c.keyword }

	-- Strings
	hl["@string"] = { link = "String" }
	hl["@string.documentation"] = { fg = c.comment, italic = opts.italic_comments }
	hl["@string.regexp"] = { fg = c.special }
	hl["@string.escape"] = { fg = c.special }
	hl["@string.special"] = { fg = c.special }
	hl["@string.special.symbol"] = { fg = c.type_name }
	hl["@string.special.url"] = { fg = c.blue, underline = true }
	hl["@string.special.path"] = { fg = c.blue }

	-- Characters / Numbers / Booleans
	hl["@character"] = { link = "Character" }
	hl["@character.special"] = { link = "SpecialChar" }
	hl["@boolean"] = { link = "Boolean" }
	hl["@number"] = { link = "Number" }
	hl["@number.float"] = { link = "Float" }

	-- Types
	hl["@type"] = { link = "Type" }
	hl["@type.builtin"] = { fg = c.type, italic = opts.italic_keywords }
	hl["@type.definition"] = { link = "Type" }
	hl["@type.qualifier"] = { fg = c.keyword, italic = opts.italic_keywords }

	-- Attributes / Properties
	hl["@attribute"] = { fg = c.yellow }
	hl["@attribute.builtin"] = { fg = c.yellow }
	hl["@property"] = { fg = c.type_name }

	-- Functions
	hl["@function"] = { link = "Function" }
	hl["@function.builtin"] = { fg = c.builtin }
	hl["@function.call"] = { link = "Function" }
	hl["@function.macro"] = { fg = c.builtin }
	hl["@function.method"] = { link = "Function" }
	hl["@function.method.call"] = { link = "Function" }
	hl["@constructor"] = { fg = c.builtin }

	-- Keywords
	hl["@keyword"] = { fg = c.keyword, italic = opts.italic_keywords }
	hl["@keyword.coroutine"] = { fg = c.keyword, italic = opts.italic_keywords }
	hl["@keyword.function"] = { fg = c.keyword, italic = opts.italic_keywords }
	hl["@keyword.operator"] = { fg = c.keyword }
	hl["@keyword.import"] = { fg = c.keyword }
	hl["@keyword.storage"] = { fg = c.keyword }
	hl["@keyword.repeat"] = { fg = c.keyword, italic = opts.italic_keywords }
	hl["@keyword.return"] = { fg = c.keyword }
	hl["@keyword.debug"] = { fg = c.error }
	hl["@keyword.exception"] = { fg = c.type_name }
	hl["@keyword.conditional"] = { fg = c.keyword, italic = opts.italic_keywords }
	hl["@keyword.conditional.ternary"] = { fg = c.operator }
	hl["@keyword.directive"] = { fg = c.special }
	hl["@keyword.directive.define"] = { fg = c.keyword }

	-- Operators / Punctuation
	hl["@operator"] = { link = "Operator" }
	hl["@punctuation.delimiter"] = { fg = c.fg }
	hl["@punctuation.bracket"] = { fg = c.fg }
	hl["@punctuation.special"] = { fg = c.special }

	-- Comments
	hl["@comment"] = { fg = c.comment, italic = opts.italic_comments }
	hl["@comment.documentation"] = { fg = c.comment, italic = opts.italic_comments }
	hl["@comment.error"] = { fg = c.error, bold = true }
	hl["@comment.warning"] = { fg = c.warning, bold = true }
	hl["@comment.todo"] = { fg = c.pink, bg = bg_normal, bold = true }
	hl["@comment.note"] = { fg = c.cyan, bold = true }

	-- Tags (HTML / JSX / etc.)
	hl["@tag"] = { fg = c.keyword }
	hl["@tag.builtin"] = { fg = c.keyword }
	hl["@tag.attribute"] = { fg = c.yellow }
	hl["@tag.delimiter"] = { fg = c.type_name }

	-- Markup (Markdown, RST, etc.)
	hl["@markup.strong"] = { bold = true }
	hl["@markup.italic"] = { italic = true }
	hl["@markup.strikethrough"] = { strikethrough = true }
	hl["@markup.underline"] = { underline = true }
	hl["@markup.heading"] = { fg = c.yellow, bold = true }
	hl["@markup.heading.1"] = { fg = c.yellow, bold = true }
	hl["@markup.heading.2"] = { fg = c.blue, bold = true }
	hl["@markup.heading.3"] = { fg = c.cyan, bold = true }
	hl["@markup.heading.4"] = { fg = c.green, bold = true }
	hl["@markup.heading.5"] = { fg = c.orange, bold = true }
	hl["@markup.heading.6"] = { fg = c.type_name, bold = true }
	hl["@markup.quote"] = { fg = c.comment, italic = opts.italic_comments }
	hl["@markup.math"] = { fg = c.cyan }
	hl["@markup.link"] = { fg = c.blue, underline = true }
	hl["@markup.link.label"] = { fg = c.type_name }
	hl["@markup.link.url"] = { fg = c.cyan, underline = true }
	hl["@markup.raw"] = { fg = c.string_lit }
	hl["@markup.raw.block"] = { fg = c.string_lit }
	hl["@markup.list"] = { fg = c.constant }
	hl["@markup.list.checked"] = { fg = c.string_lit }
	hl["@markup.list.unchecked"] = { fg = c.comment }

	-- Diff
	hl["@diff.plus"] = { link = "diffAdded" }
	hl["@diff.minus"] = { link = "diffRemoved" }
	hl["@diff.delta"] = { link = "diffChanged" }

	return hl
end

return M
