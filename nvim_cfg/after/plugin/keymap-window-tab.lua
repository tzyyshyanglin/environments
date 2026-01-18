-- Tab manipulation
local wk = require 'which-key'
wk.add {
  { '<leader><Tab>', group = 'tab' },
  { '<leader><Tab><Tab>', ':tabnext<cr>', desc = 'next tab' },
  { '<leader><Tab><S-Tab>', ':tabprevious<cr>', desc = 'previous tab' },
  { '<leader><Tab>n', ':tabnew<cr>', desc = 'new tab (empty file)' },
  --{ '<leader><Tab>t', ':tab sp | e .<cr>', desc = 'new tab (current work directory)' },
  { '<leader><Tab>b', function()
      local dir = vim.fn.expand('%:p:h')
      vim.cmd("tabnew")
      vim.cmd("Neotree filesystem dir=" .. dir .. " float")
    end,
    desc = 'new tab (buffer directory)'
  },
  { '<leader><Tab>t', function()
      local dir = vim.fn.getcwd()
      vim.cmd("tabnew")
      vim.cmd("Neotree filesystem dir=" .. dir .. " float")
    end,
    desc = 'new tab (current work directory)'
  },
  { '<leader><Tab>1', '1gt', desc = 'go to tab 1' },
  { '<leader><Tab>2', '2gt', desc = 'go to tab 2' },
  { '<leader><Tab>3', '3gt', desc = 'go to tab 3' },
  { '<leader><Tab>4', '4gt', desc = 'go to tab 4' },
  { '<leader><Tab>5', '5gt', desc = 'go to tab 5' },
  { '<leader><Tab>6', '6gt', desc = 'go to tab 6' },
  { '<leader><Tab>7', '7gt', desc = 'go to tab 7' },
  { '<leader><Tab>8', '8gt', desc = 'go to tab 8' },
  { '<leader><Tab>9', ':tablast<cr>', desc = 'go to last tab' },
  { '<leader><Tab>q', ':tabclose<cr>', desc = 'close tab' },
  { '<leader><Tab>Q', ':tabonly<cr>', desc = 'close all other tabs' },
}

-- Window manipulation
local resize_window_according_to_pos = function(resize_amount)
  return function()
    local vim_row_bottom = vim.o.lines - 1
    local current_win = vim.api.nvim_get_current_win()
    local current_pos = vim.api.nvim_win_get_position(current_win)
    local row_top = current_pos[1]
    local win_height = vim.api.nvim_win_get_height(current_win)
    local row_bottom = row_top + win_height
    if row_bottom >= vim_row_bottom then
      -- vim.cmd('resize -' .. resize_amount)
      if row_top > 1 then -- no need to resize if window spans the entire vim screen, top is 1 when tab is open, or 0 if no tab row
        vim.api.nvim_win_set_height(current_win, win_height - resize_amount)
      end
    else
      -- vim.cmd('resize +' .. resize_amount)
      vim.api.nvim_win_set_height(current_win, win_height + resize_amount)
    end
  end
end

local vertical_resize_window_according_to_pos = function(resize_amount)
  return function()
    local vim_col_right = vim.o.columns - 1
    local current_win = vim.api.nvim_get_current_win()
    local current_pos = vim.api.nvim_win_get_position(current_win)
    local col_left = current_pos[2]
    local win_width = vim.api.nvim_win_get_width(current_win)
    local col_right = col_left + win_width
    if col_right >= vim_col_right then
      -- vim.cmd('vertical resize -' .. resize_amount)
      if col_left > 0 then -- no need to resize if window spans the entire vim screen
        vim.api.nvim_win_set_width(current_win, win_width - resize_amount)
      end
    else
      -- vim.cmd('vertical resize +' .. resize_amount)
      vim.api.nvim_win_set_width(current_win, win_width + resize_amount)
    end
  end
end

wk.add {
  { '<C-w>H', vertical_resize_window_according_to_pos(-10), desc = 'move window border to the left (x10)' },
  { '<C-w>L', vertical_resize_window_according_to_pos(10), desc = 'move window border to the right (x10)' },
  { '<C-w>J', resize_window_according_to_pos(10), desc = 'move window border to the bottom (x10)' },
  { '<C-w>K', resize_window_according_to_pos(-10), desc = 'move window border to the top (x10)' },
  { '<C-w><C-Left>', vertical_resize_window_according_to_pos(-1), desc = 'move window border to the left (x1)' },
  { '<C-w><C-Right>', vertical_resize_window_according_to_pos(1), desc = 'move window border to the right (x1)' },
  { '<C-w><C-Down>', resize_window_according_to_pos(1), desc = 'move window border down (x1)' },
  { '<C-w><C-Up>', resize_window_according_to_pos(-1), desc = 'move window border up (x1)' },
 }

-- Somehow which-key settings in lazy/keymap.lua does not work, set it here again --
wk.add {
  {
    '<leader>?',
    function()
      require("which-key").show({ global = true })
    end,
    desc = 'Keymap explorer (which-key)'
  },
}
