local job = require('plantuml.job')

local M = {}

---@type { [number]: boolean }
M.success_exit_codes = { [0] = true, [200] = true }

---@param file string
---@param tmp_file string
---@param dark_mode boolean
---@param format? string
---@return job.Runner
function M.create_image_runner(file, tmp_file, dark_mode, format)
  local cmd_builder = {
    'plantuml',
    dark_mode and ' -darkmode -Smonochrome=reverse' or '',
    format and ' -t' .. format or '',
    ' -pipe < ',
    vim.fn.shellescape(file),
    ' > ',
    tmp_file,
  }

  return job.Runner:new(
    table.concat(cmd_builder),
    M.success_exit_codes
  )
end

---@param file string
---@return job.Runner
function M.create_text_runner(file)
  return job.Runner:new(
    string.format('plantuml -tutxt -pipe < %s', vim.fn.shellescape(file)),
    M.success_exit_codes
  )
end

return M
