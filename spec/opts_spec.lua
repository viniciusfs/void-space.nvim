local palette = require("void-space.palette").get("default")

local function make_opts(overrides)
	local base = {
		italic_comments = true,
		italic_keywords = false,
		transparent = false,
		dim_inactive = false,
	}
	for k, v in pairs(overrides or {}) do
		base[k] = v
	end
	return base
end

describe("option flags", function()
	describe("italic_comments = false", function()
		local opts = make_opts({ italic_comments = false })

		it("Comment has italic = false", function()
			local hl = require("void-space.highlights.syntax").get(palette, opts)
			assert.equals(false, hl.Comment.italic)
		end)

		it("@comment has italic = false", function()
			local hl = require("void-space.highlights.treesitter").get(palette, opts)
			assert.equals(false, hl["@comment"].italic)
		end)

		it("gitcommitComment has italic = false", function()
			local hl = require("void-space.highlights.legacy").get(palette, opts)
			assert.equals(false, hl.gitcommitComment.italic)
		end)

		it("SnacksDashboardFooter has italic = false", function()
			local hl = require("void-space.highlights.snacks").get(palette, opts)
			assert.equals(false, hl.SnacksDashboardFooter.italic)
		end)
	end)

	describe("italic_keywords = true", function()
		local opts = make_opts({ italic_keywords = true })

		it("Keyword has italic = true", function()
			local hl = require("void-space.highlights.syntax").get(palette, opts)
			assert.equals(true, hl.Keyword.italic)
		end)

		it("Conditional has italic = true", function()
			local hl = require("void-space.highlights.syntax").get(palette, opts)
			assert.equals(true, hl.Conditional.italic)
		end)

		it("@keyword has italic = true", function()
			local hl = require("void-space.highlights.treesitter").get(palette, opts)
			assert.equals(true, hl["@keyword"].italic)
		end)
	end)

	describe("transparent = true", function()
		local opts = make_opts({ transparent = true })

		it("Normal.bg is NONE", function()
			local hl = require("void-space.highlights.editor").get(palette, opts)
			assert.equals(palette.none, hl.Normal.bg)
		end)

		it("NormalFloat.bg is NONE", function()
			local hl = require("void-space.highlights.editor").get(palette, opts)
			assert.equals(palette.none, hl.NormalFloat.bg)
		end)

		it("TelescopeNormal.bg is NONE", function()
			local hl = require("void-space.highlights.telescope").get(palette, opts)
			assert.equals(palette.none, hl.TelescopeNormal.bg)
		end)

		it("GitSignsAdd.bg is NONE", function()
			local hl = require("void-space.highlights.gitsigns").get(palette, opts)
			assert.equals(palette.none, hl.GitSignsAdd.bg)
		end)
	end)

	describe("dim_inactive = true", function()
		local opts = make_opts({ dim_inactive = true })

		it("NormalNC has fg=fg_dim and bg=bg_dark", function()
			local hl = require("void-space.highlights.editor").get(palette, opts)
			assert.equals(palette.fg_dim, hl.NormalNC.fg)
			assert.equals(palette.bg_dark, hl.NormalNC.bg)
		end)
	end)

	describe("dim_inactive = false", function()
		local opts = make_opts({ dim_inactive = false })

		it("NormalNC links to Normal", function()
			local hl = require("void-space.highlights.editor").get(palette, opts)
			assert.equals("Normal", hl.NormalNC.link)
		end)
	end)
end)
