local rt = require('rust-tools')
local mason_registry = require('mason-registry')
local codelldb = mason_registry.get_package('codelldb')
local extension_path = codelldb:get_install_path() .. '/extension/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

local M = {}

function M.get_opts(capabilities, on_attach)
  return {
    dap = {
      adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
    },
    server = {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.keymap.set("n", "<Leader>rh", rt.hover_actions.hover_actions, { buffer = bufnr, desc = 'Rust hover actions' })
        vim.keymap.set("n", "<Leader>ra", rt.code_action_group.code_action_group,
          { buffer = bufnr, desc = 'Rust code actions' })
      end,
      settings = {
        ['rust-analyzer'] = {
          checkOnSave = {
            enable = true,
            command = 'clippy',
          },
          cargo = {
            allFeatures = true,
          },
        },
      },
    },
    tools = {
      inlay_hints = {
        auto = true,
        only_current_line = true,
      },
      hover_actions = {
        auto_focus = true,
      },
    },
  }
end

return M
