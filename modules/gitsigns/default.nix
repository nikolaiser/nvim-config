{ pkgs, lib, config, ... }:

with lib;
with builtins;



{
  config = {

    vim.startPlugins = with pkgs.neovimPlugins; [ gitsigns-nvim ];

    vim.nnoremap = {
      "]h" = { callback = "require('gitsigns').next_hunk"; desc = "Next Hunk"; };
      "[h" = { callback = "require('gitsigns').prev_hunk"; desc = "Prev Hunk"; };
      "<leader>ghs" = { command = ":Gitsigns stage_hunk<CR>"; desc = "Stage Hunk"; };
      "<leader>ghr" = { command = ":Gitsigns reset_hunk<CR>"; desc = "Reset Hunk"; };
      "<leader>ghS" = { callback = "require('gitsigns').stage_buffer"; desc = "Stage Buffer"; };
      "<leader>ghu" = { callback = "require('gitsigns').undo_stage_hunk"; desc = "Undo Stage Hunk"; };
      "<leader>ghR" = { callback = "require('gitsigns').reset_buffer"; desc = "Reset Buffer"; };
      "<leader>ghp" = { callback = "require('gitsigns').preview_hunk"; desc = "Preview Hunk"; };
      "<leader>ghb" = { callback = "require('gitsigns').blame_line({ full = true })"; desc = "Blame Line"; };
      "<leader>ghd" = { callback = "require('gitsigns').diffthis"; desc = "Diff This"; };
      "<leader>ghD" = { callback = "require('gitsigns').diffthis('~')"; desc = "Diff This ~"; };
    };

    vim.vnoremap = {
      "<leader>ghs" = { command = ":Gitsigns stage_hunk<CR>"; desc = "Stage Hunk"; };
      "<leader>ghr" = { command = ":Gitsigns reset_hunk<CR>"; desc = "Reset Hunk"; };
    };

    vim.onoremap = {
      "ih" = { command = ":<C-U>Gitsigns select_hunk<CR>"; desc = "GitSigns Select Hunk"; };
    };

    vim.xnoremap = {
      "ih" = { command = ":<C-U>Gitsigns select_hunk<CR>"; desc = "GitSigns Select Hunk"; };
    };


    vim.startLuaConfigRC = ''
      require('gitsigns').setup({signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      }})
    '';
  };
}
