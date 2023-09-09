{ pkgs, inputs, plugins, lib ? pkgs.lib, ... }:

final: prev:

with lib;
with builtins;

let
  inherit (prev.vimUtils) buildVimPluginFrom2Nix;

  ts = prev.tree-sitter.override {
    extraGrammars = {
      tree-sitter-scala = final.tree-sitter-scala-master;
    };
  };
  treesitterGrammars = ts.withPlugins (p: [
    p.tree-sitter-scala
    p.tree-sitter-nix
    p.tree-sitter-haskell
    p.tree-sitter-python
    p.tree-sitter-rust
    p.tree-sitter-markdown
    p.tree-sitter-comment
    p.tree-sitter-toml
    p.tree-sitter-make
    p.tree-sitter-html
    p.tree-sitter-javascript
    p.tree-sitter-json
    p.tree-sitter-proto
  ]);

  # sync queries of tree-sitter scala and nvim-treesitter
  queriesHook = ''
    cp ${inputs.tree-sitter-scala}/queries/scala/* $out/queries/scala
  '';

  telescopeFixupHook = ''
    substituteInPlace $out/scripts/vimg \
      --replace "ueberzug layer" "${pkgs.ueberzug}/bin/ueberzug layer"
    substituteInPlace $out/lua/telescope/_extensions/media_files.lua \
      --replace "M.base_directory .. '/scripts/vimg'" "'$out/scripts/vimg'"
  '';



  tsPostPatchHook = ''
    rm -r parser
    ln -s ${treesitterGrammars} parser
  '';

  buildPlug = name:
    buildVimPluginFrom2Nix {
      pname = name;
      version = "master";
      src = builtins.getAttr name inputs;
      preFixup = ''
        ${writeIf (name == "nvim-treesitter") queriesHook}
        ${writeIf (name == "telescope-media-files") telescopeFixupHook}
      '';
      postPatch = ''
        ${writeIf (name == "nvim-treesitter") tsPostPatchHook}
      '';
    };

  vimPlugins = {
    inherit (pkgs.vimPlugins) nerdcommenter;
  };

in
{
  neovimPlugins =
    let
      xs = listToAttrs (map (n: nameValuePair n (buildPlug n)) plugins);
    in
    xs // vimPlugins;
}
