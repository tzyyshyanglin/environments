local window_width = 30
local note_filename = 'todo.note'
local neotree_note_pane_state = {}
local _open_note_pane = function ()
  -- check if the neotree pane is already open
  manager = require('neo-tree.sources.manager')
  renderer = require('neo-tree.ui.renderer')
  state = manager.get_state('filesystem', nil, nil)
  neotree_window_exists = renderer.window_exists(state)
  --

  if neotree_window_exists then
    vim.api.nvim_set_current_win(state.winid)
  else
    vim.cmd("Neotree focus")
  end
  vim.cmd("split " .. note_filename)
  neotree_note_pane_state.winid = vim.api.nvim_get_current_win()
  vim.wo.fillchars='eob: '
  vim.wo.nu = false
  vim.wo.relativenumber = false
  vim.wo.spell = false
  vim.wo.wrap = true
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    --lazy = true,
    event = 'VeryLazy',
    ---@module "neo-tree"
    ---@type neotree.Config?
    --opts = {
      -- fill any options here
    --},
    config = function()
      local wk = require("which-key")
      wk.add {
        { '<leader>b', group = 'browse' },
        { '<leader>bb', "<cmd>Neotree buffers dir=/<cr><cmd>Neotree buffers left focus<cr>", desc = 'buffers' }, -- double tap to focrce select Neotree pane
        { '<leader>bf', "<cmd>Neotree filesystem<cr><cmd>Neotree filesystem left focus<cr>", desc = 'filesystem' },
        { '<leader>bw', "<cmd>Neotree filesystem dir=`=getcwd()`<cr><cmd>Neotree filesystem left focus<cr>", desc = 'current work directory' },
        { '<leader>bd', "<cmd>Neotree filesystem dir=%:p:h<cr><cmd>Neotree filesystem left focus<cr>", desc = 'current file directory' },
        { '<leader>bn', _open_note_pane, desc = 'notes' },
      }

      require("neo-tree").setup({
        add_blank_line_at_top = false,
        enable_git_status = false,
        enable_diagnostics = false,
        close_if_last_window = true,
        sources = {
          "filesystem",
          "buffers",
        },
        source_selector = {
          winbar = true,
          statusline = false,
        },
        window = {
          position = 'left',
          width = window_width,
        },
        filesystem = {
          bind_to_cwd = false,
          filtered_items = {
            hide_dotfiles = true,
          },
          follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
          },
        },
        buffers = {
          leave_dirs_open = true,
          follow_curent_file = {
            enabled = true,
            leave_dirs_open = true,
          },
          bind_to_cwd = false,
        },
      })

    end,
    --config = function()
    --local wk = require("which-key")
    --wk.add {
    --  { '<leader>b', "<cmd>Neotree<cr>", desc = 'file [B]rowser (current working directory)' },
    --}
  --end,
  },
}
