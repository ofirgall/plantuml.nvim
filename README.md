# plantuml.nvim

This Neovim plugin allows using [PlantUML](https://plantuml.com/) to render diagrams in real time.

This plugin supports different renderers to display PlantUML's output. Currently,
the following renderers are implemented:
- **text** renderer: An ASCII art renderer using PlantUML's text output.
- **imv** renderer: Using the [imv](https://sr.ht/~exec64/imv/) image viewer.
- **feh** renderer: Using the [feh](https://feh.finalrewind.org/) image viewer.

## Installation

Install with [packer](https://github.com/wbthomason/packer.nvim):

```lua
use { 'https://gitlab.com/itaranto/plantuml.nvim', tag = '*' }
```

## Dependencies

To use this plugin, you'll need PlantUML installed. If using any of the external renderers, you'll
need to have them installed as well.

You should be able to install any of these with your system's package manager, for example, on Arch
Linux:

```sh
sudo pacman -S plantuml imv feh
```

## Configuration

To use the default configuration, do:

```lua
require('plantuml').setup()
```

The default values are:

```lua
local default_config = {
  renderer = {
    type = 'imv',
  },
}
```

Alternatively, you can change some of the settings:

```lua
require('plantuml').setup({
  renderer = {
    type = 'text',
    options = {
      split_cmd = 'split',
    },
  },
})
```

## Usage

Open a file with a supported extension and then write it. A new window will be opened
with the resulting diagram.

Alternatively, the `PlantUML` command can be run. It will only render files with a supported
extension.

The supported file extensions are:

- `.iuml`
- `.plantuml`
- `.pu`
- `.puml`
- `.wsd`

## Contributing

*"If your commit message sucks, I'm not going to accept your pull request."*
