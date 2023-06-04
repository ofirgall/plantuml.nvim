local utils = require('plantuml.utils')

local M = {}

local success_codes = { [0] = true, [200] = true }

function M.create_image_runner(file, tmp_file, dark_mode)
  return utils.Runner:new(
    string.format('plantuml %s -pipe < %s > %s', dark_mode and '-darkmode' or '', file, tmp_file),
    success_codes
  )
end

function M.create_text_runner(file)
  return utils.Runner:new(string.format('plantuml -pipe -tutxt < %s', file), success_codes)
end

return M
