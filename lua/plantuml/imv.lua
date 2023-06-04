local plantuml = require('plantuml.plantuml')
local utils = require('plantuml.utils')

local M = {}

M.Renderer = {}

function M.Renderer:new(options)
  options = options or { dark_mode = true }

  self.__index = self
  return setmetatable({
    tmp_file = vim.fn.tempname(),
    pid = 0,
    dark_mode = options.dark_mode,
  }, self)
end

function M.Renderer:render(file)
  -- We must run imv as a server because imv cannot handle file changes properly.
  -- See: https://todo.sr.ht/~exec64/imv/45
  self:_start_server()
  self:_refresh_image(file)
end

function M.Renderer:_start_server()
  -- Use imv server's PID to check if it already has started:
  -- Set the PID the first time imv starts and only clear it when it exits.
  if self.pid == 0 then
    self.pid = utils.Runner:new('imv', {}):run(function(_)
      self.pid = 0
    end)
  end
end

function M.Renderer:_refresh_image(file)
  -- 1. Run PlantUML to generate an image file from the current file.
  plantuml.create_image_runner(file, self.tmp_file, self.dark_mode):run(function(_)
    -- 2. Tell imv to close all previously opened files.
    local imv_close_cmd = string.format('imv-msg %d close all', self.pid)
    utils.Runner:new(imv_close_cmd):run(function(_)
      -- 3. Tell imv to open the file we want.
      local imv_open_cmd = string.format('imv-msg %d open %s', self.pid, self.tmp_file)
      utils.Runner:new(imv_open_cmd):run()
    end)
  end)
end

return M
