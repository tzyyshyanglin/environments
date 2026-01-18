-- COMMON GLOBAL SETTINGS

-- Using the default fat cursor
vim.opt.guicursor = ''
vim.opt.cursorline = true -- Highlight the current line
vim.opt.cursorcolumn = false -- Highlight the current column

-- Left bar numbering
vim.opt.nu = true
vim.opt.relativenumber = true

-- Status bar setting
vim.o.laststatus = 3

-- Default tab in nothing is set
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Displaying problematic white space characters
vim.opt.list = true
vim.opt.listchars = { tab = '> ', trail = '▨', extends = '>', precedes = '<' }

-- Do not attempt to wrap the text on display
vim.opt.wrap = false

-- Back up information
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv 'HOME' .. '/.nvim/undodir'
vim.opt.undofile = true

-- Some additional search setting
vim.opt.hlsearch = true --false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append '@-@'

-- Window splits
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.showtabline = 1

-- Fast time interval
vim.opt.updatetime = 50

-- Set the warning column
vim.opt.colorcolumn = '100'

-- Setting the folding expression
vim.opt.foldmethod = 'expr' -- Folding using tree-sitter syntax parser
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 20 -- Expand everything by default

-- Adding some additional key mappings for vim in-built functions
vim.g.mapleader = ' ' -- leader key for custom mapping

-- Highlighting text on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Yank to clipboard as well --
-- This is not recommended for remote connections
--vim.opt.clipboard = 'unnamedplus'
--vim.api.nvim_set_keymap('n', 'y', '"+y', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('v', 'y', '"+y', { noremap = true, silent = true })
-- Recommended for remote connections
vim.opt.clipboard = '' -- to avoid long startup time, it takes 5 seconds to start nvim
                       -- with clipboard enabled when using ssh -Y to connect remotedly!
--vim.api.nvim_create_autocmd({ "FocusGained" }, {
--  pattern = { "*" },
--  command = [[call setreg("@", getreg("+"))]],
--})
-- Use the default yank registers instead of the clipboard
-- because it is faster
-- (unacceptablely slow when using ssh -Y to connect remotedly)
vim.api.nvim_set_keymap('n', 'y', 'y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'y', 'y', { noremap = true, silent = true })
-- sync with system clipboard on focus
vim.api.nvim_create_autocmd('FocusGained', {
  desc = 'Sync tmux buffer to vim register',
  group = vim.api.nvim_create_augroup('sync-tmux-nvim-copy-paste', { clear = true }),
  callback = function()
    if vim.fn.exists('$TMUX') == 1 then
      -- Get the tmux buffer
      local tmux_buffer = vim.fn.system('tmux show-buffer')
      -- Set the vim register to the tmux buffer
      if vim.v.shell_error == 0 then
        -- Use the default register '@' instead of '+' to avoid conflicts with clipboard
        vim.fn.setreg('"', tmux_buffer)
      end
    end
  end,
})
-- Sync with tmux buffer when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Sync yanked text to tmux buffer',
  group = vim.api.nvim_create_augroup('sync-tmux-nvim-copy-paste', { clear = false }),
  callback = function()
    -- Sync with tmux buffer
    if vim.fn.exists('$TMUX') == 1 then
      -- Get the yanked text
      --local yanked_text = vim.fn.getreg('+')
      local yanked_text = vim.fn.getreg('"')
      local tmux_command = string.format('tmux set-buffer %s', vim.fn.shellescape(yanked_text))
      vim.fn.system(tmux_command)
    end
  end,
})

-- Delete trailing whitespaces whenever saving a file
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Remove trailing whitespaces',
  group = vim.api.nvim_create_augroup('auto-format', { clear = true }),
  pattern = {"*"},
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]]) -- Remove trailing whitespaces
    -- Restore the cursor position after removing trailing whitespaces
    vim.fn.setpos('.', save_cursor)
--    print("Removed trailing whitespaces")
  end,
})

-- Setting the spelling checking for single words
vim.opt.spelllang = 'en_us'
vim.opt.spell = false
vim.opt.spelloptions = 'camel'
vim.cmd('syntax off')

-- Stop generating diagnostic updates when inserting (ltex-ls)
vim.diagnostic.config { update_in_insert = false }
