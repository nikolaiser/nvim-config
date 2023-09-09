{ pkgs, config, lib, ... }:

with lib;
with builtins;

{
  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [ material-nvim ];

    vim.luaConfigRC = ''
      vim.g.material_style="palenight"
      vim.cmd'colorscheme material'
    '';
  };
}
