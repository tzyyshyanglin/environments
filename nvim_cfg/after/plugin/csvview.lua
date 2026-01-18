local _enable_csvview = function(delimiter)
  return function()
    local csvview = require('csvview')
    curr_buf = vim.api.nvim_get_current_buf()
    if csvview.is_enabled(curr_buf) then
      csvview.disable()
    end
    csvview.enable(curr_buf, {
      delimiter=delimiter,
      parser = {
        delimiter = delimiter,
        ft = {
          csv = delimiter,
          tsv = delimiter,
        },
      },
    })
  end
end

local _use_custom_delimiter = function()
  return function()
    vim.ui.input({ prompt = "Enter custom delimiter: " }, function(input)
      if input == nil or input == "" then
        return
      else
        local unescaped_input = loadstring("return \""..input.."\"")()
        local delimiter = string.sub(unescaped_input, 1, 1)
        _enable_csvview(delimiter)()
      end
    end)
  end
end

local wk = require 'which-key'
wk.add {
  { '<leader>v', group = 'csvview' },
  { '<leader>vT', '<cmd>CsvViewToggle<cr>', desc = 'toggle CsvView' },
  { '<leader>vd', '<cmd>CsvViewDisable<cr>', desc = 'disable CsvView' },
  { '<leader>ve', '<cmd>CsvViewEnable<cr>', desc = 'enable CsvView' },
  { '<leader>v<Tab>', _enable_csvview("\t"), desc = 'use Tab as delimiter' },
  { '<leader>v ', _enable_csvview(" "), desc = 'use Space as delimiter' },
  { '<leader>v,', _enable_csvview(","), desc = 'use Comma as delimiter' },
  { '<leader>v?', _use_custom_delimiter(), desc = 'specify delimiter to use' },

}
