{ pkgs, lib, neovimBuilder, ... }:

let
  deepMerge = lib.attrsets.recursiveUpdate;
  cfg = {
    vim = {
      viAlias = false;
      vimAlias = true;
    };
  };
in
{
  full = neovimBuilder {
    config = cfg;
  };
}
