local image = require('plantuml.image')
local imv = require('plantuml.imv')
local text = require('plantuml.text')

local M = {}

local function merge_config(dst, src)
  return vim.tbl_extend('force', dst, src or {})
end

local function render_file(renderer, file)
  local status, result = pcall(renderer.render, renderer, file)
  if not status then
    print(string.format('[plantuml.nvim] Failed to render file "%s"\n%s', file, result))
  end
end

local function create_renderer(renderer_config)
  local type = renderer_config.type
  local options = renderer_config.options

  local renderer
  if type == 'text' then
    renderer = text.Renderer:new(options)
  elseif type == 'image' then
    renderer = image.Renderer:new(options)
  elseif type == 'imv' then
    renderer = imv.Renderer:new(options)
  else
    print(string.format('[plantuml.nvim] Invalid renderer type "%s"', type))
  end

  return renderer
end

local function create_autocmd(group, renderer)
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = { '*.iuml', '*.plantuml', '*.pu', '*.puml', '*.wsd' },
    callback = function(args)
      render_file(renderer, args.file)
    end,
    group = group,
  })
end

local function create_user_command(renderer)
  local function match_extension(file, ext)
    return file:find(string.format('^(.+).%s$', ext))
  end

  vim.api.nvim_create_user_command('PlantUMLRun', function(_)
    local file = vim.api.nvim_buf_get_name(0)
    if
      match_extension(file, 'iuml')
      or match_extension(file, 'plantuml')
      or match_extension(file, 'pu')
      or match_extension(file, 'puml')
      or match_extension(file, 'wsd')
    then
      render_file(renderer, file)
    end
  end, {})
end

function M.setup(config)
  local default_config = {
    renderer = {
      type = 'imv',
    },
  }

  config = merge_config(default_config, config)

  local group = vim.api.nvim_create_augroup('PlantUMLGroup', {})

  local renderer = create_renderer(config.renderer)
  if renderer then
    create_autocmd(group, renderer)
    create_user_command(renderer)
  end
end

return M
