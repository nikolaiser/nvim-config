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

      icons = {
          dap = {
            Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
            Breakpoint = " ",
            BreakpointCondition = " ",
            BreakpointRejected = { " ", "DiagnosticError" },
            LogPoint = ".>",
          },
          diagnostics = {
            Error = " ",
            Warn = " ",
            Hint = " ",
            Info = " ",
          },
          git = {
            added = " ",
            modified = " ",
            removed = " ",
          },
          kinds = {
            Array = " ",
            Boolean = " ",
            Class = " ",
            Color = " ",
            Constant = " ",
            Constructor = " ",
            Copilot = " ",
            Enum = " ",
            EnumMember = " ",
            Event = " ",
            Field = " ",
            File = " ",
            Folder = " ",
            Function = " ",
            Interface = " ",
            Key = " ",
            Keyword = " ",
            Method = " ",
            Module = " ",
            Namespace = " ",
            Null = " ",
            Number = " ",
            Object = " ",
            Operator = " ",
            Package = " ",
            Property = " ",
            Reference = " ",
            Snippet = " ",
            String = " ",
            Struct = " ",
            Text = " ",
            TypeParameter = " ",
            Unit = " ",
            Value = " ",
            Variable = " ",
          },
        }

      function fg(name)
        ---@type {foreground?:number}?
        local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
        local fg = hl and hl.fg or hl.foreground
        return fg and { fg = string.format("#%06x", fg) }
      end
    '';
  };
}
