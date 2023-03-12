local M = {}

M.Command = {}

function M.Command:new(cmd)
  self.__index = self
  return setmetatable({ cmd = cmd, stderr = {}, stdout = {} }, self)
end

function M.Command:start(process_output)
  local options = self:_get_job_options(function(_, code, _)
    self:_check_exit_code(code)
    if process_output then
      process_output(self.stdout)
    end
  end)

  local id = self:_start_job(options)
  return vim.fn.jobpid(id)
end

function M.Command:_get_job_options(on_exit)
  return {
    detach = true,
    on_exit = on_exit,
    on_stderr = function(_, data, _)
      self.stderr = data
    end,
    on_stdout = function(_, data, _)
      self.stdout = data
    end,
    stderr_buffered = true,
    stdout_buffered = true,
  }
end

function M.Command:_start_job(options)
  local id = vim.fn.jobstart(self.cmd, options)
  self:_assert_valid_job_id(id)
  return id
end

function M.Command:_check_exit_code(code)
  if code ~= 0 then
    local msg = table.concat(self.stderr)
    print(
      string.format('[plantuml.nvim] Failed to run command "%s"\n%s\ncode: %d', self.cmd, msg, code)
    )
  end
end

function M.Command:_assert_valid_job_id(id)
  assert(id > 0, string.format('start job for command "%s"', self.cmd))
end

return M
