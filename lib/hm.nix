{ config, pkgs, lib ? pkgs.lib, ... }:

let 
  cfg = config.programs.neovim-ide;
  set = pkgs.neovimBuilder { config = cfg.settings; };
in
with lib; {
  options.programs.neovim-ide = {
    enable = options.mkEnableOption "NeoVim";
    settings = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      example = literalExpression ''{}'';
      description = "";
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ set.neovim ];
  };
}
