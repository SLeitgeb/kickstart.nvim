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
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        filtered_items = {
          hide_dotfiles = false,
        }
      },
      components = {
        harpoon_index = function(config, node, state)
          -- local Marked = require("harpoon.mark")
          local harpoon = require("harpoon")
          local path = node:get_id()
          local success, index = pcall(function(p) harpoon:list():get_by_display(p) end, path)
          if success and index and index > 0 then
            return {
              text = string.format(" → %d", index), -- <-- Add your favorite harpoon like arrow here
              highlight = config.highlight or "NeoTreeDirectoryIcon",
            }
          else
            return {}
          end
        end
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
    if vim.fn.argc() == 0 then
      vim.api.nvim_create_autocmd("VimEnter", {
        -- command = "set nornu nonu | Neotree position=current",
        command = "set cursorline | Neotree position=current",
      })
      -- vim.api.nvim_create_autocmd("BufEnter", {
      --   command = "set rnu nu",
      -- })
    end
  end,
}
