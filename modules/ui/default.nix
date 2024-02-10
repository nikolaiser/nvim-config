{ pkgs, config, lib, ... }:

with lib;
with builtins;


{
  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [ dressing-nvim bufferline-nvim noice-nvim nvim-notify nvim-lualine indent-blankline mini-indentscope nvim-navic ];

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
            theme = "auto",
            globalstatus = true,
            disabled_filetypes = { statusline = { "dashboard", "alpha" } },
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch" },
            lualine_c = {
              {
                "diagnostics",
                symbols = {
                  error = icons.diagnostics.Error,
                  warn = icons.diagnostics.Warn,
                  info = icons.diagnostics.Info,
                  hint = icons.diagnostics.Hint,
                },
              },
              { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
              { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
              -- stylua: ignore
              {
                function() return require("nvim-navic").get_location() end,
                cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
              },
            },
            lualine_x = {
              {
                "g:metals_status"
              };
              -- stylua: ignore
              {
                function() return require("noice").api.status.command.get() end,
                cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
                color = fg("Statement"),
              },
              -- stylua: ignore
              {
                function() return require("noice").api.status.mode.get() end,
                cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                color = fg("Constant"),
              },
              -- stylua: ignore
              {
                function() return "  " .. require("dap").status() end,
                cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
                color = fg("Debug"),
              },
              {
                "diff",
                symbols = {
                  added = icons.git.added,
                  modified = icons.git.modified,
                  removed = icons.git.removed,
                },
              },
            },
            lualine_y = {
              { "progress", separator = " ", padding = { left = 1, right = 0 } },
              { "location", padding = { left = 0, right = 1 } },
            },
            lualine_z = {
              function()
                return " " .. os.date("%R")
              end,
            },
          },
          extensions = { "neo-tree" },
        }

        require('ibl').setup()

        require("mini.indentscope").setup{
          symbol = "│",
          options = { try_as_border = true },
        }

        vim.api.nvim_create_autocmd("FileType", {
          pattern = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
          },
          callback = function()
            vim.b.miniindentscope_disable = true
          end,
        })
    '';
  };
}
