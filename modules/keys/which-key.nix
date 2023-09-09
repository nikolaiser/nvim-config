{ pkgs, config, lib, ... }:

with lib;
with builtins;

let
  cfg = config.vim.keys;
in
{
  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [
      which-key
    ];

    vim.startLuaConfigRC = ''
      -- Set variable so other plugins can register mappings
      local wk = require("which-key")
      opts = {
          plugins = { spelling = true },
          defaults = {
            mode = { "n", "v" },
            ["g"] = { name = "+goto" },
            ["gz"] = { name = "+surround" },
            ["]"] = { name = "+next" },
            ["["] = { name = "+prev" },
            ["<leader><tab>"] = { name = "+tabs" },
            ["<leader>b"] = { name = "+buffer" },
            ["<leader>c"] = { name = "+code" },
            ["<leader>f"] = { name = "+file/find" },
            ["<leader>g"] = { name = "+git" },
            ["<leader>gh"] = { name = "+hunks" },
            ["<leader>q"] = { name = "+quit/session" },
            ["<leader>s"] = { name = "+search" },
            ["<leader>u"] = { name = "+ui" },
            ["<leader>w"] = { name = "+windows" },
            ["<leader>x"] = { name = "+diagnostics/quickfix" },
          },
        }
      wk.setup(opts)
      wk.register(opts.defaults)

    '';

  };
}
