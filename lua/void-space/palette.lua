-- void-space palette router
-- Returns the resolved color table for a given variant name.
-- All highlight modules receive this table as `c`.

local M = {}

---@param variant string|nil  Palette variant name
---@return table
function M.get(variant)
	return require("void-space.palettes." .. (variant or "default"))
end

return M
