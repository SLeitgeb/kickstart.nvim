-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- IMPORTANT: install `fd` make the fuzzy finder work correctly on hidden files.
-- sudo pacman -S fd

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim",
  },
  config = function()
    require('neo-tree').setup({
      close_if_last_window = true,
      filesystem = {
        -- hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        filtered_items = {
          hide_dotfiles = false,
        }
      },
      renderers = {
        file = {
          { "icon" },
          { "name",         use_git_status_colors = true },
          { "harpoon_index" }, --> This is what actually adds the component in where you want it
          { "diagnostics" },
          { "git_status",   highlight = "NeoTreeDimText" },
        }
      }
    })
    -- if vim.fn.argc() == 0 then
    --   vim.api.nvim_create_autocmd("VimEnter", {
    --     command = "set cursorline | Neotree position=current",
    --   })
    --   vim.api.nvim_create_autocmd("BufEnter", {
    --     command = "set wrap",
    --   })
    -- end
  end,
}
