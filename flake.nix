{
  description = "Nix neovim configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    tree-sitter-scala = {
      url = "github:tree-sitter/tree-sitter-scala";
      flake = false;
    };

    # Plugins
    leap = {
      url = "github:ggandor/leap.nvim";
      flake = false;
    };
    glow = {
      url = "github:ellisonleao/glow.nvim";
      flake = false;
    };
    neotree = {
      url = "github:nvim-neo-tree/neo-tree.nvim";
      flake = false;
    };
    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };
    nui = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };
    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
    material-nvim = {
      url = "github:marko-cerovac/material.nvim";
      flake = false;
    };
    vim-tmux-navigator = {
      url = "github:christoomey/vim-tmux-navigator";
      flake = false;
    };
    nvim-spectre = {
      url = "github:nvim-pack/nvim-spectre";
      flake = false;
    };
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    trouble-nvim = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };

    mini-bufremove = {
      url = "github:echasnovski/mini.bufremove";
      flake = false;
    };

    dressing-nvim = {
      url = "github:stevearc/dressing.nvim";
      flake = false;
    };

    bufferline-nvim = {
      url = "github:akinsho/bufferline.nvim";
      flake = false;
    };

    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    nui-nvim =
      {
        url = "github:MunifTanjim/nui.nvim";
        flake = false;
      };

    noice-nvim = {
      url = "github:folke/noice.nvim";
      flake = false;
    };
    telescope-media-files = {
      url = "github:gvolpe/telescope-media-files.nvim";
      flake = false;
    };
    lsp-format = {
      url = "github:lukas-reineke/format.nvim";
      flake = false;
    };
    gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    vim-illuminate = {
      url = "github:RRethy/vim-illuminate";
      flake = false;
    };
    nvim-notify = {
      url = "github:rcarriga/nvim-notify";
      flake = false;
    };
    nvim-lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
    nvim-persistence = {
      url = "github:folke/persistence.nvim";
      flake = false;
    };

    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-treesitter = {
      url = "github:ray-x/cmp-treesitter";
      flake = false;
    };

    nvim-luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };

    nvim-metals = {
      url = "github:scalameta/nvim-metals";
      flake = false;
    };
  };

  outputs = inputs @ { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          plugins =
            let
              f = xs: pkgs.lib.attrsets.filterAttrs (k: v: !builtins.elem k xs);

              nonPluginInputNames = [
                "self"
                "nixpkgs"
                "flake-utils"
                "neovim-nightly-overlay"
                "tree-sitter-scala"
              ];
            in
            builtins.attrNames (f nonPluginInputNames inputs);

          lib = import ./lib { inherit pkgs inputs plugins; };

          inherit (lib) metalsBuilder metalsOverlay neovimBuilder;

          pluginOverlay = lib.buildPluginOverlay;

          libOverlay = f: p: {
            lib = p.lib.extend (_: _: {
              inherit (lib) mkVimBool withAttrSet withPlugins writeIf;
            });
          };

          tsOverlay = f: p: {
            tree-sitter-scala-master = p.tree-sitter.buildGrammar {
              language = "scala";
              version = inputs.tree-sitter-scala.rev;
              src = inputs.tree-sitter-scala;
            };
          };

          neovimOverlay = f: p: {
            neovim-nightly = inputs.neovim-nightly-overlay.packages.${system}.neovim;
          };

          pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
            overlays = [ libOverlay pluginOverlay metalsOverlay neovimOverlay tsOverlay ];
          };

          default-ide = pkgs.callPackage ./lib/ide.nix {
            inherit pkgs neovimBuilder;
          };


        in
        rec {
          apps = rec {
            nvim = {
              type = "app";
              program = "${packages.default}/bin/nvim";
            };
            default = nvim;
          };
          packages = {
            default = default-ide.full.neovim;
          };
          overlays.default = f: p: {
            inherit neovimBuilder;
          };
          nixosModules.hm = {
            imports = [
              ./lib/hm.nix
              { nixpkgs.overlays = [ overlays.default ]; }
            ];
          };
        }
      );
}
