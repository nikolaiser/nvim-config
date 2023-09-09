{ pkgs, config, lib, ... }:

with lib;
with builtins;
{

  vim.startPlugins = with pkgs.neovimPlugins; [ telescope telescope-media-files ];
  vim.nnoremap = {
    "<leader>," = { command = "<cmd>Telescope buffers show_all_buffers=true<cr>"; desc = "Switch Buffer"; };
    "<leader>/" = { callback = "require('telescope.builtin').live_grep"; desc = "Grep (root dir)"; };
    "<leader>:" = { command = "<cmd>Telescope command_history<cr>"; desc = "Command History"; };
    "<leader><space>" = { callback = "require('telescope.builtin').find_files"; desc = "Find Files (root dir)"; };
    "<leader>fb" = { command = "<cmd>Telescope buffers<cr>"; desc = "Buffers"; };
    "<leader>ff" = { callback = "require('telescope.builtin').find_files"; desc = "Find Files (root dir)"; };
    "<leader>fF" = { callback = "function() require('telescope.builtin').find_files({ cwd = false }) end"; desc = "Find Files (cwd)"; };
    "<leader>fr" = { command = "<cmd>Telescope oldfiles<cr>"; desc = "Recent"; };
    "<leader>fR" = { callback = "function() require('telescope.builtin').oldfiles({ cwd = vim.loop.cwd() }) end"; desc = "Recent (cwd)"; };
    "<leader>gc" = { command = "<cmd>Telescope git_commits<CR>"; desc = "commits"; };
    "<leader>gs" = { command = "<cmd>Telescope git_status<CR>"; desc = "status"; };
    "<leader>sa" = { command = "<cmd>Telescope autocommands<cr>"; desc = "Auto Commands"; };
    "<leader>sb" = { command = "<cmd>Telescope current_buffer_fuzzy_find<cr>"; desc = "Buffer"; };
    "<leader>sc" = { command = "<cmd>Telescope command_history<cr>"; desc = "Command History"; };
    "<leader>sC" = { command = "<cmd>Telescope commands<cr>"; desc = "Commands"; };
    "<leader>sd" = { command = "<cmd>Telescope diagnostics bufnr=0<cr>"; desc = "Document diagnostics"; };
    "<leader>sD" = { command = "<cmd>Telescope diagnostics<cr>"; desc = "Workspace diagnostics"; };
    "<leader>sg" = { callback = "require('telescope.builtin').live_grep"; desc = "Grep (root dir)"; };
    "<leader>sG" = { callback = "function() require('telescope.builtin').live_grep({ cwd = false }) end"; desc = "Grep (cwd)"; };
    "<leader>sh" = { command = "<cmd>Telescope help_tags<cr>"; desc = "Help Pages"; };
    "<leader>sH" = { command = "<cmd>Telescope highlights<cr>"; desc = "Search Highlight Groups"; };
    "<leader>sk" = { command = "<cmd>Telescope keymaps<cr>"; desc = "Key Maps"; };
    "<leader>sM" = { command = "<cmd>Telescope man_pages<cr>"; desc = "Man pages"; };
    "<leader>sm" = { command = "<cmd>Telescope marks<cr>"; desc = "Jump to Mark"; };
    "<leader>so" = { command = "<cmd>Telescope vim_options<cr>"; desc = "Options"; };
    "<leader>sR" = { command = "<cmd>Telescope resume<cr>"; desc = "Resume"; };
    "<leader>sw" = { callback = "require('telescope.builtin').grep_string"; desc = "Word (root dir)"; };
    "<leader>sW" = { callback = "function() require('telescope.builtin').grep_string({ cwd = false }) end"; desc = "Word (cwd)"; };
    "<leader>ss" = { callback = "require('telescope.builtin').lsp_document_symbols"; desc = "Goto Symbol"; };
    "<leader>sS" = { callback = "require('telescope.builtin').lsp_dynamic_workspace_symbols"; desc = "Workspace Symbols"; };
  };

  vim.luaConfigRC = ''
    require("telescope").load_extension("media_files")
    require('telescope').setup{
      defaults = {
          vimgrep_arguments = {
              "${pkgs.ripgrep}/bin/rg",
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case"
            },
            pickers = {
              find_command = {
                "${pkgs.fd}/bin/fd",
              },
            },
          extensions = {
            media_files = {
              filetypes = {"png", "webp", "jpg", "jpeg"},
              find_cmd = "${pkgs.fd}/bin/fd",
            }
          },
          prompt_prefix = " ",
          selection_caret = " ",
          mappings = {
            i = {
              ["<c-t>"] = function(...)
                return require("trouble.providers.telescope").open_with_trouble(...)
              end,
              ["<a-t>"] = function(...)
                return require("trouble.providers.telescope").open_selected_with_trouble(...)
              end,
              ["<a-i>"] = function()
                local action_state = require("telescope.actions.state")
                local line = action_state.get_current_line()
                Util.telescope("find_files", { no_ignore = true, default_text = line })()
              end,
              ["<a-h>"] = function()
                local action_state = require("telescope.actions.state")
                local line = action_state.get_current_line()
                Util.telescope("find_files", { hidden = true, default_text = line })()
              end,
              ["<C-Down>"] = function(...)
                return require("telescope.actions").cycle_history_next(...)
              end,
              ["<C-Up>"] = function(...)
                return require("telescope.actions").cycle_history_prev(...)
              end,
              ["<C-f>"] = function(...)
                return require("telescope.actions").preview_scrolling_down(...)
              end,
              ["<C-b>"] = function(...)
                return require("telescope.actions").preview_scrolling_up(...)
              end,
            },
            n = {
              ["q"] = function(...)
                return require("telescope.actions").close(...)
              end,
            },
          },
        },  
      }
  '';

}
