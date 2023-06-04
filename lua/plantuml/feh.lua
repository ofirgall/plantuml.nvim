local plantuml = require('plantuml.plantuml')
local utils = require('plantuml.utils')

local M = {}

M.Renderer = {}

function M.Renderer:new(options)
  options = options or { dark_mode = true }

  self.__index = self
  return setmetatable({
    tmp_file = vim.fn.tempname(),
    started = false,
    dark_mode = options.dark_mode,
  }, self)
end

function M.Renderer:render(file)
  plantuml.create_image_runner(file, self.tmp_file, self.dark_mode):run(function(_)
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
