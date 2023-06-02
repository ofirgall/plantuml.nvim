local utils = require('plantuml.utils')

local M = {}

M.Renderer = {}

function M.Renderer:new()
  self.__index = self
  return setmetatable({ tmp_file = vim.fn.tempname(), started = false }, self)
end

function M.Renderer:render(file)
  local puml_runner = utils.Runner:new(
    string.format('plantuml -darkmode -pipe < %s > %s', file, self.tmp_file),
    { [0] = true, [200] = true }
  )
  puml_runner:run(function(_)
    self:_start_viewer()
  end)
end

function M.Renderer:_start_viewer()
  -- Only start feh if it wasn't already started.
  if not self.started then
    local feh_cmd = string.format('feh %s', self.tmp_file)
    utils.Runner:new(feh_cmd, {}):run(function(_)
      self.started = false
    end)
    self.started = true
  end
end

return M
