return {
  --
  -- A bunch of nice eye candy!
  --
  { -- Monokai color scheme
    'loctvl842/monokai-pro.nvim',
    --event = 'VeryLazy',
    lazy = true,
    config = function()
      require('monokai-pro').setup {
        transparent_background = true,
        terminal_colors = true,
        devicons = true, -- highlight the icons of `nvim-web-devicons`
        styles = {
          comment = { italic = true },
          keyword = { italic = true }, -- any other keyword
          type = { italic = true }, -- (preferred) int, long, char, etc
          storageclass = { italic = true }, -- static, register, volatile, etc
          structure = { italic = true }, -- struct, union, enum, etc
          parameter = { italic = true }, -- parameter pass in function
          annotation = { italic = true },
          tag_attribute = { italic = true }, -- attribute of tag in reactjs
        },
        filter = 'pro', -- classic | octagon | pro | machine | ristretto | spectrum
        -- Enable this will disable filter option
        day_night = {
          enable = false, -- turn off by default
          day_filter = 'pro', -- classic | octagon | pro | machine | ristretto | spectrum
          night_filter = 'spectrum', -- classic | octagon | pro | machine | ristretto | spectrum
        },
        inc_search = 'background', -- underline | background
        background_clear = {
          'toggleterm',
          'telescope',
          'which-key',
          'renamer',
          'notify',
        },
        plugins = {
          indent_blankline = {
            context_highlight = 'default',
            context_start_underline = true,
          },
        },
        override = function(_) end,
      }

      vim.cmd [[colorscheme monokai-pro-classic]]
    end,
  },
  { -- indent guides for scope this
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'VeryLazy',
    opts = {},
    config = function()
--      local highlight = {
--        'indent_guide_nonhl',
--      }
--      local hooks = require 'ibl.hooks'
--      -- create the highlight groups in the highlight setup hook, so they are
--      -- reset every time the color scheme changes
--      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
--        vim.api.nvim_set_hl(0, 'indent_guide_nonhl', { fg = '#777777' })
--      end)
--      require('ibl').setup {
--        enabled = true,
--        scope = { enabled = true },
--        indent = { highlight = highlight },
--      }
      local highlight = {
        --"Whitespace",
        "indent_guide_nonhl",
      }
      local hooks = require 'ibl.hooks'
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'indent_guide_nonhl', { fg = '#222222' })
      end)
      require('ibl').setup {
        indent = { highlight = highlight },
        whitespace = {
          highlight = highlight,
          remove_blankline_trail = false,
        },
        scope = { enabled = false },
      }
    end,
  },
  { -- Comment highlighter for notes and to-dos
    'folke/todo-comments.nvim',
    --event = 'VimEnter',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  { -- Lower status line of file
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'loctvl842/monokai-pro.nvim',
    },
    lazy = false,
    --event = 'VeryLazy',
    config = function()
      require('lualine').setup {
        options = {
          --theme = 'monokai-pro',
          --theme = 'ayu_dark',
          disabled_filetypes = {
            --statusline = { 'neo-tree', 'lazy', 'notes', 'Avante', 'AvanteInput', 'AvanteSelectedFiles' },
            statusline = { },
            winbar = { 'neo-tree', 'lazy', 'notes', 'Avante', 'AvanteInput', 'AvanteSelectedFiles' },
            --winbar = { },
          },
          global_status = true, -- need to also set vim.o.lastatus=3 in set.lua
        },
        sections = {
          lualine_a = { 'mode' },
          --lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_b = {},
          lualine_c = { { 'filename', path = 3 , symbols = { readonly = '[-]' } } },
          lualine_x = { { 'searchcount', maxcount = 999, timeout = 500 }, 'encoding', 'filetype' },
          --lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        winbar = {
          lualine_a = { { 'filename', path = 0, symbols = { }  } },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        inactive_winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { 'filename', path = 0  } },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {
          lualine_a = { { 'tabs', mode = 2, path = 0, show_modified_status = true } },
          lualine_b = {},
          lualine_c = { function() vim.o.showtabline = 1; return '' end }, -- hack to hide tabline when no tabs
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        }
      }
    end,
  },
--  { -- Upper line of breadcrumb for feature signature
--    'utilyre/barbecue.nvim',
--    name = 'barbecue',
--    event = 'VeryLazy',
--    version = '*',
--    dependencies = { 'SmiteshP/nvim-navic', 'nvim-tree/nvim-web-devicons' },
--    config = function()
--      require('barbecue').setup {
--        theme = 'monokai-pro',
--      }
--    end,
--  },
  { -- Moving command line to center, messages to top right
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {},
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      require('noice').setup {}
      require('notify').setup { background_colour = '#000000', stages = 'static' }
    end,
  },
}
