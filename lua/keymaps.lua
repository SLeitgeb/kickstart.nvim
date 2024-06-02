-- [[ Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Custom keymaps
vim.keymap.set('n', '<leader><leader>', '<C-^>')
vim.keymap.set('n', '<leader>/', ':noh<CR>:<backspace>')
-- vim.keymap.set('n', '<C-j>', '<C-w>j')
-- vim.keymap.set('n', '<C-k>', '<C-w>k')
-- vim.keymap.set('n', '<C-h>', '<C-w>h')
-- vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<Leader>Y', [["*y]])
vim.keymap.set('n', '<Leader>P', [["*p]])
vim.keymap.set('n', '<Leader>y', [["+y]])
vim.keymap.set('n', '<Leader>p', [["+p]])

vim.keymap.set('n', '<F9>', ':Neotree filesystem reveal float<CR>')
vim.keymap.set('n', '<F10>', ':Neotree toggle left<CR>')

-- Use X in visual mode to search for selected text
-- taken from: http://vimdoc.sourceforge.net/htmldoc/visual.html#visual-search
-- and https://stackoverflow.com/questions/4848254/vim-search-pattern-for-a-piece-of-text-line-yanked-in-visual-mode
vim.keymap.set('v', 'X', 'y/<C-r>"<CR>')

vim.keymap.set('n', '<leader>d', ':set background=dark<CR>')
vim.keymap.set('n', '<leader>l', ':set background=light<CR>')

-- proper key sequence needs to be sent by terminal emulator, see
-- https://stackoverflow.com/questions/16359878/how-to-map-shift-enter
vim.keymap.set('i', '<S-CR>', '<Esc>O')
-- vim.keymap.set('i', '<C-\\>', '<Esc>O')

-- harpoon config
-- local harpoon_mark = require("harpoon.mark")
-- local harpoon_ui = require("harpoon.ui")
local harpoon = require("harpoon")
-- harpoon:setup() -- called in lua/custom/plugins/init.lua

vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end, { desc = '[H]arpoon [a]dd file' })
vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<A-1>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<A-2>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<A-3>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<A-4>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<A-5>", function() harpoon:list():select(5) end)

-- Yoink from ThePrimeagen
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set({ "n", "v" }, "<leader>u", vim.cmd.UndotreeToggle)

-- TODO: Map these
-- vim.keymap.set("x", "<leader>p", [["_dP]])
-- vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>F", "<cmd>Format<CR>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>git", vim.cmd.Git)
-- from: https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
vim.keymap.set("n", "<leader>cd", "<cmd>cd %:p:h<CR>:pwd<CR>", { desc = "[c]hange [d]irectory to the current file" })

vim.keymap.set("n", "<leader>zz", function()
  require("zen-mode").setup {
    window = {
      width = 90,
      options = {
        number = true,
        relativenumber = true,
      }
    },
  }
  require("zen-mode").toggle()
  vim.opt.colorcolumn = "0"
end)

vim.keymap.set("n", "<leader>zn", function()
  require("zen-mode").setup {
    window = {
      width = 80,
      options = {
        number = false,
        relativenumber = true,
      }
    },
    plugins = {
      kitty = {
        enabled = true,
        font = "+4",
      },
    },
  }
  require("zen-mode").toggle()
  -- vim.opt.colorcolumn = "0"
end)

-- vim: ts=2 sts=2 sw=2 et
