-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<M-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:FormatLsp` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(event.buf, 'FormatLsp', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities(capabilities))

-- Enable (broadcasting) snippet capability for completion
local jsonls_capabilities = vim.lsp.protocol.make_client_capabilities()
jsonls_capabilities = vim.tbl_deep_extend('force', jsonls_capabilities,
  require('cmp_nvim_lsp').default_capabilities(jsonls_capabilities))
jsonls_capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  gopls = {},
  -- pylsp = {
  --   -- cmd = { 'pylsp', '~/.local/share/nvim/mason/bin/pylsp' },
  --   -- cmd = { '/home/simon/.local/share/virtualenvs/navman-LwpPW6_1/bin/pylsp' },
  --   cmd = { 'pylsp' },
  --   -- cmd = { vim.fn.system('/usr/bin/env', 'pylsp') },
  --   settings = {
  --     pylsp = {
  --       -- Install 3rd party plugins with:
  --       -- :PylspInstall pylsp-mypy pyls-isort python-lsp-black python-lsp-ruff pylsp-rope
  --       -- try experimenting with auto install:
  --       -- https://github.com/williamboman/mason-lspconfig.nvim/issues/58#issuecomment-1521738021
  --       plugins = {
  --         -- formatter options
  --         black = { enabled = true },
  --         autopep8 = { enabled = false },
  --         yapf = { enabled = false },
  --         -- import sorting
  --         pyls_isort = { enabled = true },
  --         -- linter options
  --         pylint = { enabled = true },
  --         pyflakes = { enabled = false },
  --         pycodestyle = { enabled = false },
  --         -- type checker
  --         pylsp_mypy = { enabled = true },
  --         -- auto-completion options
  --         jedi_completion = { fuzzy = true },
  --       },
  --     }
  --   }
  -- },
  ruff_lsp = {},
  tsserver = {},
  eslint = {},
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  jsonls = {
    capabilities = jsonls_capabilities,
  },
  ltex = {
    settings = {
      ltex = {
        language = "en-GB",
        additionalRules = {
          -- dependency: `paru -S languagetool-ngrams-en`
          languageModel = "/usr/share/ngrams/",
        },
      },
    }
  },
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        diagnostics = { disable = { 'missing-fields' } },
      },
    }
  },
  yamlls = {},
}

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  'stylua',
})

-- Ensure the servers above are installed
require('mason-tool-installer').setup {
  ensure_installed = ensure_installed
}

require('mason-lspconfig').setup {
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      require('lspconfig')[server_name].setup(server)
    end,
    ['rust_analyzer'] = function()
      local opts = require('settings.rust-tools').get_opts(capabilities)
      require('rust-tools').setup(opts)
    end,
  }
}

require('lspconfig').pylsp.setup {
  capabilities = capabilities,
  -- cmd = { 'pylsp' },
  settings = {
    pylsp = {
      plugins = {
        -- formatter options
        black = { enabled = false },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        -- import sorting
        pyls_isort = { enabled = false },
        -- linter options
        pylint = { enabled = false },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        -- auto-completion options
        rope_autoimport = { enabled = false },
        rope_completion = { enabled = false },
        jedi_completion = { enabled = true, fuzzy = true },
        mccabe = { threshold = 30 },
      },
    }
  },
}

-- Setup neovim lua configuration
require('neodev').setup({
  library = { plugins = { 'nvim-dap-ui' }, types = true },
})

require('nlspsettings').setup({
  config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
  local_settings_dir = '.nlsp-settings',
  local_settings_root_markers_fallback = { '.git' },
  append_default_schemas = true,
  loader = 'json'
})

-- vim: ts=2 sts=2 sw=2 et
