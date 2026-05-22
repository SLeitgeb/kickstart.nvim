-- [[ Configure Treesitter (main branch) ]]
-- See `:help nvim-treesitter`

local ensure_installed = {
  'c', 'cpp', 'go', 'lua', 'python', 'rust', 'r', 'tsx',
  'javascript', 'typescript', 'vimdoc', 'vim', 'bash',
}

require('nvim-treesitter').install(ensure_installed)

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf = args.buf
    local ft = vim.bo[buf].filetype
    local lang = vim.treesitter.language.get_lang(ft) or ft
    if not pcall(vim.treesitter.start, buf, lang) then return end

    if ft ~= 'python' then
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- [[ Textobjects (main branch) ]]
require('nvim-treesitter-textobjects').setup {
  select = {
    lookahead = true,
  },
  move = {
    set_jumps = true,
  },
}

local select = require('nvim-treesitter-textobjects.select')
local move = require('nvim-treesitter-textobjects.move')
local swap = require('nvim-treesitter-textobjects.swap')

local function map(mode, lhs, fn, desc)
  vim.keymap.set(mode, lhs, fn, { silent = true, desc = desc })
end

for _, mode in ipairs({ 'x', 'o' }) do
  map(mode, 'aa', function() select.select_textobject('@parameter.outer', 'textobjects') end, 'parameter outer')
  map(mode, 'ia', function() select.select_textobject('@parameter.inner', 'textobjects') end, 'parameter inner')
  map(mode, 'af', function() select.select_textobject('@function.outer', 'textobjects') end, 'function outer')
  map(mode, 'if', function() select.select_textobject('@function.inner', 'textobjects') end, 'function inner')
  map(mode, 'ac', function() select.select_textobject('@class.outer', 'textobjects') end, 'class outer')
  map(mode, 'ic', function() select.select_textobject('@class.inner', 'textobjects') end, 'class inner')
end

map({ 'n', 'x', 'o' }, ']m', function() move.goto_next_start('@function.outer', 'textobjects') end, 'next function start')
map({ 'n', 'x', 'o' }, ']]', function() move.goto_next_start('@class.outer', 'textobjects') end, 'next class start')
map({ 'n', 'x', 'o' }, ']M', function() move.goto_next_end('@function.outer', 'textobjects') end, 'next function end')
map({ 'n', 'x', 'o' }, '][', function() move.goto_next_end('@class.outer', 'textobjects') end, 'next class end')
map({ 'n', 'x', 'o' }, '[m', function() move.goto_previous_start('@function.outer', 'textobjects') end, 'prev function start')
map({ 'n', 'x', 'o' }, '[[', function() move.goto_previous_start('@class.outer', 'textobjects') end, 'prev class start')
map({ 'n', 'x', 'o' }, '[M', function() move.goto_previous_end('@function.outer', 'textobjects') end, 'prev function end')
map({ 'n', 'x', 'o' }, '[]', function() move.goto_previous_end('@class.outer', 'textobjects') end, 'prev class end')

map('n', '<leader>a', function() swap.swap_next('@parameter.inner') end, 'swap param next')
map('n', '<leader>A', function() swap.swap_previous('@parameter.inner') end, 'swap param prev')

-- NOTE: incremental_selection module removed in nvim-treesitter `main` branch.
-- No drop-in replacement; would need custom impl via `vim.treesitter.get_node()`
-- or a third-party plugin. Original config kept below for reference.
--
-- incremental_selection = {
--   enable = true,
--   keymaps = {
--     init_selection = '<C-space>',
--     node_incremental = '<C-space>',
--     scope_incremental = '<C-s>',
--     node_decremental = '<A-space>',
--   },
-- },

-- NOTE: nvim-treesitter-refactor has no `main` branch and is incompatible
-- with the rewritten nvim-treesitter. Remove it from the plugin deps or
-- pin it to `master` on its own spec. Original config kept below.
--
-- refactor = {
--   navigation = {
--     enable = true,
--     keymaps = {
--       goto_next_usage = '<A-n>',
--       goto_previous_usage = '<A-p>',
--     },
--   },
-- },

-- vim: ts=2 sts=2 sw=2 et
