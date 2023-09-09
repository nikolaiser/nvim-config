{pkgs, lib, conifg, ...}:

with lib;

with builtins;

{

  vim.startPlugins = with pkgs.neovimPlugins; [ nvim-luasnip ];

  vim.luaConfigRC = ''
  '';
}
