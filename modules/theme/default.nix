{ pkgs, config, lib, ... }:

with lib;
with builtins;

{
  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [ material-nvim ];

    vim.luaConfigRC = ''
      vim.g.material_style="palenight"
      vim.cmd'colorscheme material'

      vim.g.VM_Mono_hl = 'Cursor'
      vim.g.VM_Extend_hl = 'Visual'
      vim.g.VM_Cursor_hl = 'Cursor'
      vim.g.VM_Insert_hl = 'Cursor'
    '';
  };
}
