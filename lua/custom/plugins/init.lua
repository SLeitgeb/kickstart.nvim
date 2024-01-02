-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- TODO: consider finding alternative for the following plugins
-- Plug 'godlygeek/tabular'
-- Plug 'suy/vim-context-commentstring'
-- maybe: https://github.com/folke/todo-comments.nvim
return {
  'christoomey/vim-sort-motion',
  -- 'christoomey/vim-tmux-navigator',
  'knubie/vim-kitty-navigator',
  'tpope/vim-surround',
  'tpope/vim-abolish',
  {
    'theprimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {},
  },
  'mbbill/undotree',
  'folke/zen-mode.nvim',
  -- 'folke/trouble.nvim',
  -- 'nvim-treesitter/playground',
  { 'tummetott/unimpaired.nvim',    opts = {} },
  { 'simrat39/rust-tools.nvim',     ft = 'rust' },
  { 'mfussenegger/nvim-dap-python', ft = 'python' },
  {
    'saecki/crates.nvim',
    ft = { 'rust', 'toml' },
    config = function(_, opts)
      local crates = require('crates')
      crates.setup(opts)
      crates.show()
    end,
  },
  'theHamsta/nvim-dap-virtual-text',
  'farmergreg/vim-lastplace',
}
