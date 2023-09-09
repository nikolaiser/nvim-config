{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.filetree.neotree;
in
{
  #options.vim.filetree.neotree = {
  #  enable = mkOption {
  #    type = types.bool;
  #    default = true;
  #    description = "Enable neotree";
  #  };
  #};

  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [
      neotree
      plenary
      nvim-web-devicons
      nui
    ];

    vim.nmap = {
      "<leader>fe" = {
        callback = "function() require(\"neo-tree.command\").execute({toggle = true}) end";
        desc = "Explorer NeoTree (root dir)";
      };
      "<leader>fE" = {
        callback = "function() require(\"neo-tree.command\").execute({toggle = true, dir = vim.loop.cwd() }) end";
        desc = "Explorer NeoTree (cwd)";
      };
      "<leader>e" = {
        command = "<leader>fe";
        desc = "Explorer NeoTree (root dir)";
      };
      "<leader>E" = {
        command = "<leader>fE";
        desc = "Explorer NeoTree (cwd)";
      };
    };

    vim.luaConfigRC = ''
      require("neo-tree").setup {
        filesystem = {
          bind_to_cwd = false,
          follow_current_file = true,
          use_libuv_file_watcher = true,
        },
        window = {
          mappings = {
            ["<space>"] = "none",
          },
        },
        default_component_configs = {
          indent = {
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
        },
      }
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    
    '';

  };
}
