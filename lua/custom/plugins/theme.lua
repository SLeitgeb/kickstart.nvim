local function reload_theme()
  local bg = vim.o.background
  local opts = {
    style = 'deep',
    toggle_style_key = '<leader>ts',
    toggle_style_list = { 'deep', 'light' },
  }
  if bg == "light" then
    opts.style = 'light'
  end
  local onedark = require 'onedark'
  onedark.setup(opts)
  onedark.load()
  require('ibl').setup()
end

local augroup = vim.api.nvim_create_augroup("DarkmanIntegration", { clear = true })

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  group = augroup,
  callback = reload_theme,
})

return {
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    dependencies = {
      'nvim-lualine/lualine.nvim'
    },
    lazy = false,
    priority = 1000,
    config = function()
      reload_theme()
    end,
  },

  -- {
  --   'folke/tokyonight.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('tokyonight').setup({
  --       day_brightness = 0.3,
  --     })
  --     vim.cmd.colorscheme('tokyonight-day')
  --   end,
  -- },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        -- theme = 'tokyonight',
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  {
    '4e554c4c/darkman.nvim',
    build = 'go build -o bin/darkman.nvim',
    config = function()
      require 'darkman'.setup({
        change_background = true,
        send_user_event = true,
        -- change_background = true,
        -- send_user_event = false,
        -- colorscheme = { dark = 'tokyonight-moon', light = 'tokyonight-day' },
      })
      require 'onedark'.load()
    end,
  }
}
