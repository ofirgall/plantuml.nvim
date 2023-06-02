local M = {}

M.Runner = {}

function M.Runner:new(cmd, codes)
  self.__index = self
  return setmetatable({ cmd = cmd, codes = codes or { [0] = true } }, self)
end

function M.Runner:run(on_success)
  local stderr
  local stdout

  local id = vim.fn.jobstart(self.cmd, {
    detach = true,
    on_exit = function(_, code, _)
      if next(self.codes) ~= nil and not self.codes[code] then
        local msg = table.concat(stderr)
        error(string.format('exit job for command "%s"\n%s\ncode: %d', self.cmd, msg, code))
      end

      if on_success then
        on_success(stdout)
      end
    end,
    on_stderr = function(_, data, _)
      stderr = data
    end,
    on_stdout = function(_, data, _)
      stdout = data
    end,
    stderr_buffered = true,
    stdout_buffered = true,
  })
  assert(id > 0, string.format('start job for command "%s"', self.cmd))

  return vim.fn.jobpid(id)
end

return M
