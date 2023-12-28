-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Set incremental search highlighting
vim.o.incsearch = true

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.o.clipboard = 'unnamedplus'

-- Yoink from ThePrimeagen
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- I like word wrap, sue me
vim.o.wrap = true
vim.o.linebreak = true

-- Enable break indent
vim.o.breakindent = true

vim.o.tabstop = 4

-- Don't allow less than 8 lines above or below cursor for file context
vim.o.scrolloff = 8

-- Highlight column 80 for optimal line length
vim.o.colorcolumn = "80"

-- Open new split panes to right and bottom, which feels more natural
vim.o.splitbelow = true
vim.o.splitright = true

-- fuzzy find for :find
vim.o.path = vim.o.path .. '**'
vim.o.wildmenu = true

-- vim: ts=2 sts=2 sw=2 et
