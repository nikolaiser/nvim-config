{ pkgs, lib, config, ... }:

with lib;
with builtins;
{
  config = {

    vim.nnoremap = {
      "<space>" = {
        command = "<nop>";
      };
    };

    vim.startConfigRC = ''
      set encoding=utf-8
      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
      set expandtab
      set cmdheight=1
      set mouse=a
      set noerrorbells
      set number relativenumber
      set clipboard=unnamedplus
      syntax on
    '';

    vim.startLuaConfigRC = ''
      vim.o.termguicolors=true
      vim.g.mapleader=" "
      vim.g.maplocalleader=" "
    '';
  };
}
