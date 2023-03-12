local utils = require('plantuml.utils')

local M = {}

M.Renderer = {}

function M.Renderer:new()
  self.__index = self
  return setmetatable({ tmp_file = vim.fn.tempname(), pid = 0 }, self)
end

function M.Renderer:render(file)
  self:_start_server()
  self:_refresh_image(file)
end

function M.Renderer:_start_server()
  -- Use imv server's PID to check if it already has started:
  -- Set the PID the first time imv starts and only clear it when it exits.
  if self.pid == 0 then
    self.pid = utils.Command:new('imv'):start(function(_)
      self.pid = 0
    end)
  end
end

function M.Renderer:_refresh_image(file)
  -- 1. Run PlantUML to generate an image file from the current file.
  local puml_cmd = string.format('plantuml -darkmode -pipe < %s > %s', file, self.tmp_file)
  utils.Command:new(puml_cmd):start(function(_)
    -- 2. Tell imv to close all previously opened files.
    local imv_close_cmd = string.format('imv-msg %d close all', self.pid)
    utils.Command:new(imv_close_cmd):start(function(_)
      -- 3. Tell imv to open the file we want.
      local imv_open_cmd = string.format('imv-msg %d open %s', self.pid, self.tmp_file)
      utils.Command:new(imv_open_cmd):start()
    end)
  end)
end

return M
