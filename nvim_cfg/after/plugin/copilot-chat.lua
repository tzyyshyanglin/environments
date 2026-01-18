local wk = require 'which-key'

local selection_config = function(opts, buffer)
  opts = opts or {}
  local is_buffer = buffer or false -- if true, then selection is from buffer, otherwise from visual selection
  local chat = require("CopilotChat")
  chat.open(opts) -- switch to chat window and trigger source/selection updates
  local select = require("CopilotChat.select")
  local source = chat.get_source()

  local selection_func = select.visual
  selection = selection_func(source)
  if is_buffer or selection == nil then
    chat.set_selection(source.bufnr, 0, -1, true) -- clear selection
    selection_func = select.buffer
    selection = selection_func(source)
  end
  local sel_config = {
    sticky = string.format("#file: %s: line: %s-%s", selection.filename, selection.start_line, selection.end_line),
    selection = selection_func,
  }
  config = vim.tbl_deep_extend("force", opts, sel_config)
  return config
end

local resize_window = function(width, win_id)
  local win_id = win_id or vim.api.nvim_get_current_win()
  local width = width or 70
  vim.cmd('vertical resize ' .. width)
  vim.cmd('set winfixwidth')
  vim.cmd('horizontal wincmd =')
  vim.cmd('set winfixwidth!')
end

wk.add{
  { '<leader>c', group = '[C]opilot' },
  { '<leader>c', group = '[C]opilot', mode = 'v' },
  { '<leader>cs',
    function()
      vim.api.nvim_input(':Copilot status\r')
    end,
    desc = 'show [s]tatus',
  },
  { '<leader>cv',
    function()
      vim.api.nvim_input(':Copilot version\r')
    end,
    desc = 'show [v]ersion',
  },
  { '<leader>cl',
    function()
      vim.api.nvim_input(':Copilot log\r')
    end,
    desc = 'show [l]og',
  },
  { '<leader>ce',
    function()
      vim.api.nvim_input(':Copilot enable\r')
    end,
    desc = '[e]nable copilot',
  },
  { '<leader>cd',
    function()
      vim.api.nvim_input(':Copilot disable\r')
    end,
    desc = '[d]isable copilot',
  },
  { '<leader>ch',
    function()
      vim.api.nvim_input(':Copilot help\r')
    end,
    desc = '[h]elp',
  },
  { '<leader>cr',
    function()
      vim.api.nvim_input(':Copilot restart\r')
    end,
    desc = '[r]estart copilot',
  },
  { '<leader>cc', group = 'Copilot[C]hat' },
  { '<leader>cc', group = 'Copilot[C]hat', mode = 'v' },
  -- toggle chat on/off --
  { '<leader>ccT',
    function()
      local chat = require("CopilotChat")
      if require("CopilotChat").chat:visible() then
        chat.close()
      else
        chat.open({
          window = {
            layout = "vertical",
          },
        })
        resize_window()
      end
    end,
    desc = "[T]oggle chat window on/off",
  },
  -- resize copilot chat window --
  { '<leader>ccR',
    function()
      local chat = require("CopilotChat")
      local focused = chat.chat:focused()
      if chat.chat:visible() then
        chat.open()
        resize_window()
        if focused ~= true then
          vim.cmd('wincmd p')
        end
      else
        vim.api.nvim_echo({{"Copilot chat window is not open", "WarningMsg"}}, false, {})
      end
    end,
    desc = "[R]esize chat window",
  },

  -- quick chat with entire buffer as context
  { '<leader>ccq',
    function()
      local input = vim.fn.input("Quick Chat: (whole buffer selected) ")
      if input ~="" then
        local config = selection_config({
          highlight_selection = false,
        }, true)
        require("CopilotChat").ask(input, config)
      end
    end,
    desc = "[q]uick chat",
  },
  -- for selected code, quick chat with only the selected snippet
  { '<leader>ccq',
    function()
      local input = vim.fn.input("Quick Chat (visual selected): ")
      if input ~="" then
        local config = selection_config({
          highlight_selection = true,
        }, false)
        require("CopilotChat").ask(input, config)
      end
    end,
    desc = "[q]uick chat",
    mode = 'v',
  },
  -- add documentation --
  { '<leader>ccd',
    function()
      local chat = require("CopilotChat")
      local prompts = chat.prompts()
      local config = selection_config({
        highlight_selection = false,
      }, true)
      chat.ask(prompts.Docs.prompt, config)
    end,
    desc = "add [d]ocumentation",
  },
  { '<leader>ccd',
    function()
      local chat = require("CopilotChat")
      local prompts = chat.prompts()
      local config = selection_config({
        highlight_selection = true,
      }, false)
      chat.ask(prompts.Docs.prompt, config)
      print('hl: ', config.highlight_selection)
    end,
    desc = "add [d]ocumentation",
    mode = 'v',
  },
  -- explain --
  { '<leader>ccx',
    function()
      local chat = require("CopilotChat")
      local prompts = chat.prompts()
      local config = selection_config({
        highlight_selection = false,
        system_prompt = "COPILOT_EXPLAIN",
      }, true)
      chat.ask(prompts.Explain.prompt, config)
    end,
    desc = "e[x]plain code",
  },
  { '<leader>ccx',
    function()
      local chat = require("CopilotChat")
      local prompts = chat.prompts()
      local config = selection_config({
        highlight_selection = true,
        system_prompt = "COPILOT_EXPLAIN",
      }, false)
      chat.ask(prompts.Explain.prompt, config)
    end,
    desc = "e[x]plain code",
    mode = 'v',
  },
  -- fix --
  { '<leader>ccf',
    function()
      local chat = require("CopilotChat")
      local prompts = chat.prompts()
      local config = selection_config({
        highlight_selection = false,
      }, true)
      chat.ask(prompts.Fix.prompt, config)
    end,
    desc = "[f]ix code",
  },
  { '<leader>ccf',
    function()
      local chat = require("CopilotChat")
      local prompts = chat.prompts()
      local config = selection_config({
        highlight_selection = true,
      }, false)
      chat.ask(prompts.Fix.prompt, config)
    end,
    desc = "[f]ix code",
    mode = 'v',
  },
  -- review --
  { '<leader>ccr',
    function()
      local chat = require("CopilotChat")
      local prompts = chat.prompts()
      local config = selection_config({
        highlight_selection = false,
        system_prompt = "COPILOT_REVIEW",
      }, true)
      chat.ask(prompts.Review.prompt, config)
    end,
    desc = "[r]eview code",
  },
  { '<leader>ccr',
    function()
      local chat = require("CopilotChat")
      local prompts = chat.prompts()
      local config = selection_config({
        highlight_selection = true,
        system_prompt = "COPILOT_REVIEW",
      }, false)
      chat.ask(prompts.Review.prompt, config)
    end,
    desc = "[r]eview code",
    mode = 'v',
  },
  -- optimize --
  { '<leader>cco',
    function()
      local chat = require("CopilotChat")
      local prompts = chat.prompts()
      local config = selection_config({
        highlight_selection = false,
      }, true)
      chat.ask(prompts.Optimize.prompt, config)
    end,
    desc = "[o]ptimize code",
  },
  { '<leader>cco',
    function()
      local chat = require("CopilotChat")
      local prompts = chat.prompts()
      local config = selection_config({
        highlight_selection = true,
      }, false)
      chat.ask(prompts.Optimize.prompt, config)
    end,
    desc = "[o]ptimize code",
    mode = 'v',
  },
  -- generate test --
  { '<leader>cct',
    function()
      local chat = require("CopilotChat")
      local prompts = chat.prompts()
      local config = selection_config({
        highlight_selection = false,
      }, true)
      chat.ask(prompts.Tests.prompt, config)
    end,
    desc = "generate [t]ests",
  },
  { '<leader>cct',
    function()
      local chat = require("CopilotChat")
      local prompts = chat.prompts()
      local config = selection_config({
        highlight_selection = true,
      }, false)
      chat.ask(prompts.Tests.prompt, config)
    end,
    desc = "generate [t]ests",
    mode = 'v',
  },
  -- bring up copilot chat prompt window --
  { '<leader>ccp', "<cmd>CopilotChatPrompt<cr>",
    desc = "CopilotChat [p]rompts",
    mode = {'n', 'v'},
  },
}
