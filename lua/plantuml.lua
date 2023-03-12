local imv = require('plantuml.imv')
local text = require('plantuml.text')

local M = {}

local function merge_config(dst, src)
  for key, value in pairs(src) do
    dst[key] = value
  end
end

local function render_file(renderer, file)
  local status, result = pcall(renderer.render, renderer, file)
  if not status then
    print(string.format('[plantuml.nvim] Failed to render file "%s"\n%s', file, result))
  end
end

local function create_renderer(type)
  local renderer
  if type == 'text' then
    renderer = text.Renderer:new()
  elseif type == 'imv' then
    renderer = imv.Renderer:new()
  else
    print(string.format('[plantuml.nvim] Invalid renderer type "%s"', type))
  end

  return renderer
end

local function create_autocmd(group, renderer)
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = '*.puml',
    callback = function(args)
      render_file(renderer, args.file)
    end,
    group = group,
  })
end

local function create_user_command(renderer)
  vim.api.nvim_create_user_command('PlantUMLRun', function(_)
    local file = vim.api.nvim_buf_get_name(0)
    if file:find('^(.+).puml$') then
      render_file(renderer, file)
    end
  end, {})
end

function M.setup(config)
  local _config = { renderer = 'imv' }
  merge_config(_config, config or {})

  local group = vim.api.nvim_create_augroup('PlantUMLGroup', {})

  local renderer = create_renderer(_config.renderer)
  if renderer then
    create_autocmd(group, renderer)
    create_user_command(renderer)
  end
end

return M
