{ pkgs, config, lib, ... }:

with lib;
with builtins;


{
  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [ dressing-nvim bufferline-nvim noice-nvim nvim-notify nvim-lualine ];

    vim.nnoremap = {
      "<leader>bp" = {
        command = "<Cmd>BufferLineTogglePin<CR>";
        desc = "Toggle pin";
      };
      "<leader>bP" = {
        command = "<Cmd>BufferLineGroupClose ungrouped<CR>";
        desc = "Delete non-pinned buffers";
      };
      "<leader>un" = {
        callback = "function() require('notify').dismiss({silent = true, pending = true}) end";
        desc = "Dismiss all Notifications";
      };
    };

    vim.luaConfigRC = ''
      vim.g.material_style="palenight"
      vim.cmd'colorscheme material'
      require('bufferline').setup{
          options = {
            -- stylua: ignore
            close_command = function(n) require("mini.bufremove").delete(n, false) end,
            -- stylua: ignore
            right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
            diagnostics = "nvim_lsp",
            always_show_bufferline = false,
            offsets = {
              {
                filetype = "neo-tree",
                text = "Neo-tree",
                highlight = "Directory",
                text_align = "left",
              },
            },
        }
      }

      require('noice').setup{
          lsp = {
            override = {
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true,
            },
          },
          routes = {
            {
              filter = {
                event = "msg_show",
                find = "%d+L, %d+B",
              },
              view = "mini",
            },
          },
          presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
            inc_rename = true,
          },
        }

        require('lualine').setup{
          options = {
            theme = "material-nvim",
            section_separators = "",
            component_separators = "",
            icons_enabled = true,
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch" },
            lualine_c = { "filename" },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
          },
          inactive_sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch" },
            lualine_c = { "filename" },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
          },
        }
    '';
  };
}
