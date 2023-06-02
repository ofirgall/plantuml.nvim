local utils = require('plantuml.utils')

local M = {}

M.Renderer = {}

function M.Renderer:new(options)
  local buf = vim.api.nvim_create_buf(false, true)
  assert(buf ~= 0, string.format('create buffer'))

  self.__index = self
  return setmetatable({ buf = buf, win = nil, split_cmd = options.split_cmd }, self)
end

function M.Renderer:render(file)
  local puml_runner = utils.Runner:new(
    string.format('plantuml -pipe -tutxt < %s', file),
    { [0] = true, [200] = true }
  )
  puml_runner:run(function(output)
    self:_write_output(output)
    self:_create_split()
  end)
end

function M.Renderer:_write_output(output)
  vim.api.nvim_buf_set_lines(self.buf, 0, -1, true, output)
end

function M.Renderer:_create_split()
  -- Only create the window if it wasn't already created.
  if not (self.win and vim.api.nvim_win_is_valid(self.win)) then
    vim.cmd(self.split_cmd)
    self.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(self.win, self.buf)
  end
end

return M
