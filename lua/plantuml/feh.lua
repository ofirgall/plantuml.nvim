local utils = require('plantuml.utils')

local M = {}

M.Renderer = {}

function M.Renderer:new()
  self.__index = self
  return setmetatable({ tmp_file = vim.fn.tempname(), started = false }, self)
end

function M.Renderer:render(file)
  local puml_cmd = string.format('plantuml -darkmode -pipe < %s > %s', file, self.tmp_file)
  utils.Command:new(puml_cmd):start(function()
    self:_start_viewer()
  end)
end

function M.Renderer:_start_viewer()
  -- Only start feh if it wasn't already started.
  if not self.started then
    utils.Command:new(string.format('feh %s', self.tmp_file)):start(function(_)
      self.started = false
    end)
    self.started = true
  end
end

return M
