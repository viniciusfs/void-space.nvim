-- void-space: cosmic_dawn palette (light background variant)

local M = {}

-- ------------
-- Named colors
-- ------------
local _alice_blue    = "#EEF1F7"  -- main background
local _lavender_mist = "#E4E8F2"  -- floats / sidebar
local _steel_mist    = "#DDE3EE"  -- darkest background (inactive windows)
local _periwinkle    = "#D0D8E8"  -- selection
local _slate         = "#5A6880"  -- dimmed text, comments
local _dark_indigo   = "#283048"  -- main foreground / inverted text

local _crimson       = "#A02040"
local _forest        = "#2E7834"
local _golden        = "#C09010"  -- see note in spec: yellow is a light-theme compromise
local _royal         = "#2850B0"
local _teal          = "#1E6888"
local _violet        = "#6040A8"
local _rose          = "#983080"
local _sienna        = "#8A5020"
local _bright_gold   = "#D4A820"
local _bright_forest = "#33A53D"
local _cobalt        = "#2F62DC"
local _pacific       = "#1E8BBA"
local _scarlet       = "#D41F4C"

-- -------------------------
-- Semantic colors
-- -------------------------
-- Backgrounds & foregrounds
M.bg_dark    = _steel_mist
M.bg         = _alice_blue
M.bg_float   = _lavender_mist
M.sel        = _periwinkle
M.fg_dim     = _slate
M.fg         = _dark_indigo
M.bg_inverted = _dark_indigo
M.background  = "light"

-- Accent colors
M.red          = _crimson
M.green        = _forest
M.yellow       = _golden
M.blue         = _royal
M.cyan         = _teal
M.purple       = _violet
M.pink         = _rose
M.orange       = _sienna
M.bright_yellow = _bright_gold
M.bright_green  = _bright_forest
M.bright_blue   = _cobalt
M.bright_cyan   = _pacific
M.bright_red    = _scarlet

-- Syntax roles
M.comment    = M.fg_dim
M.keyword    = M.blue
M.func       = M.purple
M.type_name  = M.cyan
M.string_lit = M.green
M.constant   = M.orange
M.operator   = M.fg
M.type       = M.cyan
M.builtin    = M.purple
M.special    = M.yellow

-- Diagnostics
M.error   = M.red
M.warning = M.yellow
M.info    = M.cyan
M.hint    = M.purple

M.none = "NONE"

return M
