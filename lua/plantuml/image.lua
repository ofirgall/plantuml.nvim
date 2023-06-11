local plantuml = require('plantuml.plantuml')
local utils = require('plantuml.utils')

local M = {}

M.Renderer = {}

function M.Renderer:new(options)
  options = options or { prog = 'feh', dark_mode = true }

  self.__index = self
  return setmetatable({
    prog = options.prog,
    dark_mode = options.dark_mode,
    tmp_file = vim.fn.tempname(),
    started = false,
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
    local cmd = string.format('%s %s', self.prog, self.tmp_file)
    utils.Runner:new(cmd, {}):run(function(_)
      self.started = false
    end)
    self.started = true
  end
end

return M
