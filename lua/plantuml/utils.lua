local M = {}

function M.run_command(cmd, on_exit, on_success)
  local stderr
  local stdout

  local id = vim.fn.jobstart(cmd, {
    detach = true,
    on_exit = function(_, code, _)
      if on_exit then
        on_exit()
      end

      local msg = table.concat(stderr)
      assert(code == 0, string.format('exit job for command "%s"\n%s\ncode: %d', cmd, msg, code))

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
  assert(id > 0, string.format('start job for command "%s"', cmd))

  return vim.fn.jobpid(id)
end

return M
