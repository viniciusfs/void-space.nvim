<p align="center">
  <img src="assets/void_space_logo.svg" width="894" >
</p>

A dark color scheme for Neovim based on [vim-deep-space](https://github.com/tyrannicaltoucan/vim-deep-space) palette. Original low contrast and dark navy palette extended with full TreeSitter, LSP, diagnostics, and [LazyVim](https://wwww.lazyvim.org/) plugin coverage.

## Motivation

I used deep-space for years and when I migrated from vim to Neovim I found that deep-space missed a lot of highlights for wide used plugins. I started void-space to fill the gaps I found on deep-space running on my LazyVim setup and also add personal touches.

## Examples

<p align="center">
  <img src="assets/demo.png" width="894" >

  <img src="assets/demo2.png" width="894" >
</p>

## Palette

| Swatch | Hex | HSL | Color Name | Semantic | Role |
|--------|-----|-----|------------|----------|------|
| ![bg_dark](assets/swatches/default/bg_dark.png)             | `#141820` | 220° 23% 10% | Black Russian #1 | `bg_dark`       | Darkest bg (borders, inactive)    |
| ![bg](assets/swatches/default/bg.png)                       | `#1a1f28` | 219° 21% 13% | Black Russian #2 | `bg`            | Main background                   |
| ![bg_float](assets/swatches/default/bg_float.png)           | `#232936` | 221° 21% 17% | Midnight Express | `bg_float`      | Cursor line / popup background    |
| ![sel](assets/swatches/default/sel.png)                     | `#323c4d` | 218° 21% 25% | Cloud Burst      | `sel`           | Selection / border                |
| ![fg_dim](assets/swatches/default/fg_dim.png)               | `#52627f` | 219° 22% 41% | Chambray         | `fg_dim`        | Comments / dimmed text            |
| ![fg](assets/swatches/default/fg.png)                       | `#99a7be` | 217° 22% 67% | Rock Blue        | `fg`            | Main foreground, operators        |
| ![red](assets/swatches/default/red.png)                     | `#c68b8f` | 356° 34% 66% | Tapestry         | `red`           | Errors                            |
| ![green](assets/swatches/default/green.png)                 | `#94b592` | 117° 19% 64% | Amulet           | `green`         | Strings / added                   |
| ![yellow](assets/swatches/default/yellow.png)               | `#b39b64` |  42° 34% 55% | Barley Corn      | `yellow`        | Special                           |
| ![blue](assets/swatches/default/blue.png)                   | `#618bc2` | 214° 44% 57% | Danube           | `blue`          | Keywords / built-ins              |
| ![purple](assets/swatches/default/purple.png)               | `#9e87c5` | 262° 35% 65% | Lilac Bush       | `purple`        | Functions / hints                 |
| ![cyan](assets/swatches/default/cyan.png)                   | `#59abb4` | 186° 38% 53% | Fountain Blue    | `cyan`          | Type names                        |
| ![orange](assets/swatches/default/orange.png)               | `#ba8873` |  18° 34% 59% | Medium Wood      | `orange`        | Constants                         |
| ![pink](assets/swatches/default/pink.png)                   | `#c47ec4` | 300° 37% 63% | Orchid           | `pink`          | Match paren / attention           |
| ![bright_yellow](assets/swatches/default/bright_yellow.png) | `#d5ad75` |  35° 53% 65% | Putty            | `bright_yellow` | Emphasis (deep-space terminal 11) |

## Requirements

- Neovim >= 0.8
- `termguicolors` enabled

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'viniciusfs/void-space.nvim',
  lazy = false,    -- must be loaded at startup
  priority = 1000, -- load before other UI plugins
  opts = {
    italic_comments  = true,
    italic_keywords  = false,
    transparent      = false,
    dim_inactive     = false,
    -- override any highlight group after the theme loads:
    -- on_highlights = function(hl, c)
    --   hl.CursorLine = { bg = c.gray3 }
    -- end,
  },
  config = function(_, opts)
    require('void-space').setup(opts)
    vim.cmd('colorscheme void-space')
  end,
}
```

## Usage

### Minimal (just activate it)

```lua
vim.cmd('colorscheme void-space')
```

### With setup (call before `colorscheme`)

```lua
require('void-space').setup({
  italic_comments  = true,   -- italicize comments
  italic_keywords  = false,  -- italicize keywords / conditionals
  transparent      = false,  -- transparent Normal background
  dim_inactive     = false,  -- dim inactive windows
})

vim.cmd('colorscheme void-space')
```

### LazyVim integration

```lua
-- In your lazy.nvim spec:
{
  'viniciusfs/void-space.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    italic_comments = true,
    italic_keywords = false,
  },
  config = function(_, opts)
    require('void-space').setup(opts)
    vim.cmd('colorscheme void-space')
  end,
},

-- Tell LazyVim which colorscheme to use (in your LazyVim options):
{
  'LazyVim/LazyVim',
  opts = { colorscheme = 'void-space' },
},
```

### Overriding specific highlights

Use the `on_highlights` callback to tweak any group after the theme loads. The callback receives the full highlights table and the palette so you can reference any color:

```lua
require('void-space').setup({
  on_highlights = function(hl, c)
    -- Make the cursor line more visible
    hl.CursorLine = { bg = c.sel }

    -- Use a brighter yellow for search
    hl.Search = { fg = c.bg, bg = c.bright_yellow }

    -- Transparent floating windows
    hl.NormalFloat = { fg = c.fg, bg = c.none }
    hl.FloatBorder = { fg = c.fg_dim, bg = c.none }
  end,
})
```

### Lualine

The theme is picked up automatically when lualine's `theme` option is set:

```lua
require('lualine').setup({
  options = { theme = 'void-space' },
})
```

## Plugin support

| Plugin | Highlight definition |
|--------|----------------------|
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | [highlights/bufferline.lua](lua/void-space/highlights/bufferline.lua) |
| [blink.cmp](https://github.com/Saghen/blink.cmp) | [highlights/cmp.lua](lua/void-space/highlights/cmp.lua) |
| [dashboard-nvim](https://github.com/nvimdev/dashboard-nvim) | [highlights/dashboard.lua](lua/void-space/highlights/dashboard.lua) |
| [fidget.nvim](https://github.com/j-hui/fidget.nvim) | [highlights/fidget.lua](lua/void-space/highlights/fidget.lua) |
| [flash.nvim](https://github.com/folke/flash.nvim) | [highlights/flash.lua](lua/void-space/highlights/flash.lua) |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | [highlights/gitsigns.lua](lua/void-space/highlights/gitsigns.lua) |
| [illuminate.nvim](https://github.com/RRethy/vim-illuminate) | [highlights/illuminate.lua](lua/void-space/highlights/illuminate.lua) |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | [highlights/indent.lua](lua/void-space/highlights/indent.lua) |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | [highlights/lazy.lua](lua/void-space/highlights/lazy.lua) |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | [lualine/themes/void-space.lua](lua/lualine/themes/void-space.lua) |
| [mini.nvim](https://github.com/echasnovski/mini.nvim) | [highlights/mini.lua](lua/void-space/highlights/mini.lua) |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | [highlights/neo\_tree.lua](lua/void-space/highlights/neo_tree.lua) |
| [noice.nvim](https://github.com/folke/noice.nvim) | [highlights/noice.lua](lua/void-space/highlights/noice.lua) |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | [highlights/cmp.lua](lua/void-space/highlights/cmp.lua) |
| [nvim-notify](https://github.com/rcarriga/nvim-notify) | [highlights/notify.lua](lua/void-space/highlights/notify.lua) |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | [highlights/render\_markdown.lua](lua/void-space/highlights/render_markdown.lua) |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | [highlights/snacks.lua](lua/void-space/highlights/snacks.lua) |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | [highlights/telescope.lua](lua/void-space/highlights/telescope.lua) |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | [highlights/todo\_comments.lua](lua/void-space/highlights/todo_comments.lua) |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | [highlights/trouble.lua](lua/void-space/highlights/trouble.lua) |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | [highlights/editor.lua](lua/void-space/highlights/editor.lua) |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | [highlights/which\_key.lua](lua/void-space/highlights/which_key.lua) |

## License

[MIT](LICENSE)
