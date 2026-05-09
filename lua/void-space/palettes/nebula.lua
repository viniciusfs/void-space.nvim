-- void-space: nebula palette (electric void variant)

local M = {}

-- ------------
-- Named colors
-- ------------
local _void_black      = "#080618"  -- darkest background
local _dark_nebula     = "#0E0A20"  -- main background
local _nebula_deep     = "#180E30"  -- floats / sidebar
local _nebula_violet   = "#301858"  -- selection
local _stardust        = "#7860A8"  -- dimmed text, comments
local _starlight       = "#DDD0F8"  -- main foreground

local _nova_rose       = "#E04070"  -- red
local _teal_stardust   = "#38D4A8"  -- green / strings
local _pale_gold       = "#E8D070"  -- yellow
local _blue_giant      = "#5870E8"  -- blue
local _electric_cyan   = "#40D0F0"  -- cyan / type names
local _electric_violet = "#9060E8"  -- purple / keywords
local _magenta_nebula  = "#C847D9"  -- functions
local _orchid_cloud    = "#A840B8"  -- types
local _hot_magenta     = "#E060C8"  -- pink
local _amber_star      = "#E0902A"  -- orange / constants
local _heliotrope      = "#C87EFF"  -- operators
local _bright_gold     = "#F0D880"  -- bright yellow

-- -------------------------
-- Semantic colors
-- -------------------------
-- Backgrounds & foregrounds
M.bg_dark     = _void_black
M.bg          = _dark_nebula
M.bg_float    = _nebula_deep
M.sel         = _nebula_violet
M.fg_dim      = _stardust
M.fg          = _starlight
M.bg_inverted = M.bg

-- Accent colors
M.red          = _nova_rose
M.green        = _teal_stardust
M.yellow       = _pale_gold
M.blue         = _blue_giant
M.cyan         = _electric_cyan
M.purple       = _electric_violet
M.pink         = _hot_magenta
M.orange       = _amber_star
M.bright_yellow = _bright_gold

-- Syntax roles (magenta dominant)
M.comment    = M.fg_dim
M.keyword    = M.purple        -- electric violet
M.func       = _magenta_nebula -- hot magenta
M.type_name  = M.cyan          -- electric cyan (distinct from func)
M.string_lit = M.green         -- teal-mint
M.constant   = M.orange        -- amber
M.operator   = _heliotrope     -- pale violet
M.type       = _orchid_cloud   -- orchid
M.builtin    = M.purple        -- same as keyword
M.special    = M.yellow        -- pale gold

-- Diagnostics
M.error   = M.red
M.warning = M.yellow
M.info    = M.cyan
M.hint    = M.purple

M.none = "NONE"

return M
