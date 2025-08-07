return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
  },
  config = function()
    local null_ls = require 'null-ls'

    -- FORMATTING ON SAVE
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    local lsp_formatting = function(bufnr)
      vim.lsp.buf.format {
        filter = function(client)
          -- apply whatever logic you want (in this example, we'll only use null-ls)
          return client.name == 'null-ls'
        end,
        bufnr = bufnr,
      }
    end
    local on_attach = function(client, bufnr)
      if client.supports_method 'textDocument/formatting' then
        vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = augroup,
          buffer = bufnr,
          callback = function()
            lsp_formatting(bufnr)
          end,
        })
      end
    end

    null_ls.setup {
      on_attach = on_attach,
      sources = {
        null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.completion.spell,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.black,
        require 'none-ls.formatting.jq',
      },
    }
  end,
}
