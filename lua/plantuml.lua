local image = require('plantuml.image')
local imv = require('plantuml.imv')
local text = require('plantuml.text')
local utils = require('plantuml.utils')

local M = {}

local file_extensions = {
  'iuml',
  'plantuml',
  'pu',
  'puml',
  'wsd',
}

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
  local pattern = {}
  for _, ext in ipairs(file_extensions) do
    table.insert(pattern, '*' .. ext)
  end

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    pattern = pattern,
    callback = function(args)
      render_file(renderer, args.file)
    end,
  })
end

local function create_user_command(renderer)
  vim.api.nvim_create_user_command('PlantUML', function(_)
    local file = vim.api.nvim_buf_get_name(0)

    for _, ext in ipairs(file_extensions) do
      if file:find(string.format('^(.+).%s$', ext)) then
        render_file(renderer, file)
        break
      end
    end
  end, {})
end

function M.setup(config)
  local default_config = {
    renderer = {
      type = 'text',
    },
  }

  config = utils.merge_tables(default_config, config)

  local group = vim.api.nvim_create_augroup('PlantUMLGroup', {})

  local renderer = create_renderer(config.renderer)
  if renderer then
    create_autocmd(group, renderer)
    create_user_command(renderer)
  end
end

return M
