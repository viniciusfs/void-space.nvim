local M = {}

function M.get(c, opts)
	local hl = {}

	hl.LspReferenceText = { bg = c.sel }
	hl.LspReferenceRead = { bg = c.sel }
	hl.LspReferenceWrite = { bg = c.sel, bold = true }
	hl.LspSignatureActiveParameter = { fg = c.yellow, bold = true }
	hl.LspInlayHint = { fg = c.fg_dim, bg = c.bg_float, italic = true }
	hl.LspCodeLens = { fg = c.fg_dim, italic = true }
	hl.LspCodeLensSeparator = { fg = c.sel }

	-- Semantic tokens
	hl["@lsp.type.class"] = { link = "Type" }
	hl["@lsp.type.decorator"] = { fg = c.yellow }
	hl["@lsp.type.enum"] = { link = "Type" }
	hl["@lsp.type.enumMember"] = { link = "Constant" }
	hl["@lsp.type.function"] = { link = "Function" }
	hl["@lsp.type.interface"] = { fg = c.type }
	hl["@lsp.type.macro"] = { link = "Macro" }
	hl["@lsp.type.method"] = { link = "Function" }
	hl["@lsp.type.namespace"] = { fg = c.type }
	hl["@lsp.type.parameter"] = { fg = c.fg }
	hl["@lsp.type.property"] = { fg = c.type_name }
	hl["@lsp.type.struct"] = { link = "Structure" }
	hl["@lsp.type.type"] = { link = "Type" }
	hl["@lsp.type.typeParameter"] = { fg = c.type }
	hl["@lsp.type.variable"] = { fg = c.fg }
	hl["@lsp.mod.deprecated"] = { strikethrough = true }
	hl["@lsp.mod.readonly"] = { fg = c.constant }

	return hl
end

return M
