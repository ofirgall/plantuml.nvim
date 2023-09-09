local utils = require('plantuml.utils')

local M = {}

--- PlantUML success exit codes.
---@type { [number]: boolean }
local success_codes = { [0] = true, [200] = true }

--- Creates a PlantUML command runner in image mode.
---@param file string
---@param tmp_file string
---@param dark_mode boolean
---@return utils.Runner
function M.create_image_runner(file, tmp_file, dark_mode)
  return utils.Runner:new(
    string.format('plantuml %s -pipe < %s > %s', dark_mode and '-darkmode' or '', file, tmp_file),
    success_codes
  )
end

--- Creates a PlantUML command runner in text mode.
---@param file string
---@return utils.Runner
function M.create_text_runner(file)
  return utils.Runner:new(string.format('plantuml -pipe -tutxt < %s', file), success_codes)
end

return M
