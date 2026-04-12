local M = {}

function M.get(c, opts)
	local hl = {}

	-- LSP reference highlighting (set by vim.lsp.buf.document_highlight)
	-- All three use sel background so highlights are subtle, not distracting.
	hl.LspReferenceText = { bg = c.sel }
	hl.LspReferenceRead = { bg = c.sel }
	-- Write reference gets bold to distinguish mutation from reads.
	hl.LspReferenceWrite = { bg = c.sel, bold = true }

	-- Signature & hints
	hl.LspSignatureActiveParameter = { fg = c.yellow, bold = true }
	-- LspInlayHint: fg_dim + bg_float creates a "ghost text" appearance.
	-- italic follows opts.italic_comments (same toggle as code comments).
	hl.LspInlayHint = { fg = c.fg_dim, bg = c.bg_float, italic = opts.italic_comments }
	hl.LspCodeLens = { fg = c.fg_dim, italic = opts.italic_comments }
	hl.LspCodeLensSeparator = { fg = c.sel }

	-- Semantic tokens — override treesitter for LSP-aware buffers.
	-- Most entries link to their syntax.lua equivalent for palette consistency.
	hl["@lsp.type.class"] = { link = "Type" }
	hl["@lsp.type.decorator"] = { fg = c.yellow }
	hl["@lsp.type.enum"] = { link = "Type" }
	hl["@lsp.type.enumMember"] = { link = "Constant" }
	hl["@lsp.type.function"] = { link = "Function" }
	hl["@lsp.type.interface"] = { fg = c.type }
	hl["@lsp.type.macro"] = { link = "Macro" }
	hl["@lsp.type.method"] = { link = "Function" }
	-- @lsp.type.namespace uses type color (cyan), consistent with @module in treesitter —
	-- both treat namespaces/modules as type-like constructs.
	hl["@lsp.type.namespace"] = { fg = c.type }
	hl["@lsp.type.parameter"] = { fg = c.fg }
	hl["@lsp.type.property"] = { fg = c.fg } -- aligns with @property (fg); property access is not a type
	hl["@lsp.type.struct"] = { link = "Structure" }
	hl["@lsp.type.type"] = { link = "Type" }
	hl["@lsp.type.typeParameter"] = { fg = c.type }
	hl["@lsp.type.variable"] = { fg = c.fg }
	hl["@lsp.mod.deprecated"] = { strikethrough = true }
	hl["@lsp.mod.readonly"] = { fg = c.constant }

	return hl
end

return M
