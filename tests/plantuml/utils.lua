local assert = require('luassert.assert')

local M = {}

---@class utils.CallbackTracker
---@field callbacks function[]
---@field total_calls number
---@field err string
M.CallbackTracker = {}

---@param total_calls? number
---@param err? string
---@return utils.CallbackTracker
function M.CallbackTracker:new(total_calls, err)
  self.__index = self
  return setmetatable({
    callbacks = {},
    total_calls = total_calls,
    err = err,
  }, self)
end

---@param call_nr number
---@param callback function
---@return nil
function M.CallbackTracker:track(call_nr, callback)
  -- Defer the callback's execution by inserting it into `calls`.
  if self.err and call_nr > self.total_calls then
    table.insert(self.callbacks, function()
      error(self.err)
    end)
  else
    table.insert(self.callbacks, callback)
  end
end

---@return nil
function M.CallbackTracker:invoke_all()
  for _, callback in ipairs(self.callbacks) do
    callback()
  end
end

---@return nil
function M.CallbackTracker:assert_one_has_error()
  assert.has_error(function()
    for _, callback in ipairs(self.callbacks) do
      callback()
    end
  end, self.err)
end

---@return nil
function M.CallbackTracker:assert_all_have_error()
  for _, callback in ipairs(self.callbacks) do
    assert.has_error(function()
      callback()
    end, self.err)
  end
end

return M
