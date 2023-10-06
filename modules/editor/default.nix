{ pkgs, lib, config, ... }:

with lib;
with builtins;

{
  config = {

    vim.startPlugins = with pkgs.neovimPlugins; [ vim-tmux-navigator nvim-spectre leap mini-bufremove nui-nvim vim-illuminate nvim-persistence vim-visual-multi ];

    vim.nnoremap = {
      "<leader>sr" = {
        callback = "function() require('spectre').open() end";
        desc = "Replace in files (Spectre)";
      };
      "<leader>bd" = {
        callback = "function() require('mini.bufremove').delete(0, false) end";
        desc = "Delete Buffer";
      };
      "<leader>bD" = {
        callback = "function() require('mini.bufremove').delete(0, true) end";
        desc = "Delete Buffer (Force)";
      };
      "<leader>qs" = {
        callback = "function() require('persistence').load() end";
        desc = "Restore Session";
      };
      "<leader>ql" = {
        callback = "function() require('persistence').load({ last = true }) end";
        desc = "Restore Last Session";
      };
      "<leader>qd" = {
        callback = "function() require('persistence').stop() end";
        desc = "Stop Persistence";
      };
      "<leader>qq" = {
        command = "<cmd>qa<cr>";
        desc = "Quit all";
      };
      "<C-Up>" = {
        command = "<cmd>resize +2<cr>";
        desc = "Increase window height";
      };
      "<C-Down>" = {
        command = "<cmd>resize -2<cr>";
        desc = "Decrease window height";
      };
      "<C-Left>" = {
        command = "<cmd>vertical resize -2<cr>";
        desc = "Decrease window width";
      };
      "<C-Right>" = {
        command = "<cmd>vertical resize +2<cr>";
        desc = "Increase window width";
      };
    };

    vim.nmap = {
      "<C-s>" = {
        command = "<cmd>w<cr><esc>";
        desc = "Save file";
      };
      "<leader>wd" = {
        command = "<C-W>c";
        desc = "Delete window";
      };
      "<leader>w-" = {
        command = "<C-W>s";
        desc = "Split window below";
      };
      "<leader>w|" = {
        command = "<C-W>s";
        desc = "Split window right";
      };
      "<leader>-" = {
        command = "<C-W>s";
        desc = "Split window below";
      };
      "<leader>|" = {
        command = "<C-W>s";
        desc = "Split window right";
      };
    };

    vim.imap = {
      "<C-s>" = {
        command = "<cmd>w<cr><esc>";
        desc = "Save file";
      };
    };

    vim.vmap = {
      "<C-s>" = {
        command = "<cmd>w<cr><esc>";
        desc = "Save file";
      };
    };



    vim.startLuaConfigRC = ''
      require('leap').add_default_mappings()

      opts = { delay = 200 }
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })

      persistenceOpts = {
        dir = "/home/nikolaiser/.local/share/persistence.nvim/sessions", -- directory where session files are saved
        options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
        pre_save = nil, -- a function to call before saving the session
      }

      require('persistence').setup(persistenceOpts)
    '';
  };
}
