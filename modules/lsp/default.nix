{ pkgs, lib, ... }:

with lib;
with builtins;


{

  vim.startPlugins = with pkgs.neovimPlugins; [ nvim-lspconfig trouble-nvim lsp-format cmp-nvim-lsp nvim-lspconfig nvim-metals ];
  vim.nnoremap = {
    "<leader>xx" = {
      command = "<cmd>TroubleToggle document_diagnostics<cr>";
      desc = "Document Diagnostics (Trouble)";
    };
    "<leader>xX" = {
      command = "<cmd>TroubleToggle workspace_diagnostics<cr>";
      desc = "Workspace Diagnostics (Trouble)";
    };
    "<leader>xL" = {
      command = "<cmd>TroubleToggle loclist<cr>";
      desc = "Location List (Trouble)";
    };
    "<leader>xQ" = {
      command = "<cmd>TroubleToggle quickfix<cr>";
      desc = "Quickfix List (Trouble)";
    };
    "[q" = {
      callback = "function() if require('trouble').is_open() then require('trouble').previous({ skip_groups = true, jump = true }) else vim.cmd.cprev() end end";
      desc = "Previous trouble/quickfix item";
    };
    "]q" = {
      callback = "function() if require('trouble').is_open() then require('trouble').next({ skip_groups = true, jump = true }) else vim.cmd.cnext() end end";
      desc = "Next trouble/quickfix item";
    };
    "<leader>cd" = { callback = "vim.diagnostic.open_float"; desc = "Line Diagnostics"; };
    "<leader>cl" = { command = "<cmd>LspInfo<cr>"; desc = "Lsp Info"; };
    "gd" = { command = "<cmd>Telescope lsp_definitions<cr>"; desc = "Goto Definition"; };
    "gr" = { command = "<cmd>Telescope lsp_references<cr>"; desc = "References"; };
    "gD" = { callback = "vim.lsp.buf.declaration"; desc = "Goto Declaration"; };
    "gI" = { command = "<cmd>Telescope lsp_implementations<cr>"; desc = "Goto Implementation"; };
    "gy" = { command = "<cmd>Telescope lsp_type_definitions<cr>"; desc = "Goto T[y]pe Definition"; };
    "K" = { callback = "vim.lsp.buf.hover"; desc = "Hover"; };
    "<leader>cf" = { callback = "function() require('lsp-format').format({ force = true }) end"; desc = "Format Document"; };
    "<leader>ca" = { callback = "vim.lsp.buf.code_action"; desc = "Code Action"; };
    "<leader>cA" = {
      callback = "function() vim.lsp.buf.code_action({ context = { only = { 'source' }, diagnostics = {} } }) end";
      desc = "Source Action";
    };
    "<leader>me" = {
      callback = "function() require('telescope').extensions.metals.commands() end";
      desc = "Metals comands";
    };
  };

  vim.vnoremap = {

    "<leader>cf" = { callback = "function() require('lsp-format').format({ force = true }) end"; desc = "Format Range"; };
    "<leader>ca" = { callback = "vim.lsp.buf.code_action"; desc = "Code Action"; };
  };


  vim.luaConfigRC = ''

    vim.g.formatsave = "true"


    local lspconfig = require('lspconfig')
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    format_callback = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            if vim.g.formatsave then
                local params = require'vim.lsp.util'.make_formatting_params({})
                client.request('textDocument/formatting', params, nil, bufnr)
            end
          end
        })
      end

    default_on_attach = function(client, bufnr)
        format_callback(client, bufnr)
      end

    -- Nix config
        lspconfig.nil_ls.setup{
          capabilities = capabilities;
          on_attach = default_on_attach,
          settings = {
            ['nil'] = {
              formatting = {
                command = {"${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"}
              },
              diagnostics = {
                ignored = { "uri_literal" },
                excludedFiles = { }
              }
            }
          };
          cmd = {"${pkgs.nil}/bin/nil"}
        }

    -- Scala nvim-metals config
        metals_config = require('metals').bare_config()
        metals_config.capabilities = capabilities
        metals_config.on_attach = default_on_attach

        metals_config.settings = {
           metalsBinaryPath = "${pkgs.metals}/bin/metals",
           showImplicitArguments = true,
           showImplicitConversionsAndClasses = true,
           showInferredType = true,
           excludedPackages = {
           }
        }

        metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = {
              prefix = '',
            }
          }
        )

        metals_config.init_options.statusBarProvider = "on"

        -- without doing this, autocommands that deal with filetypes prohibit messages from being shown
        vim.opt_global.shortmess:remove("F")

        vim.cmd([[augroup lsp]])
        vim.cmd([[autocmd!]])
        vim.cmd([[autocmd FileType java,scala,sbt lua require('metals').initialize_or_attach(metals_config)]])
        vim.cmd([[augroup end]])

    -- Haskell config
        lspconfig.hls.setup {
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = { "${pkgs.haskellPackages.haskell-language-server}/bin/haskell-language-server", "--lsp" };
          root_dir = lspconfig.util.root_pattern("hie.yaml", "stack.yaml", ".cabal", "cabal.project", "package.yaml");
        }

    -- Rust config 
        lspconfig.rust_analyzer.setup{
          capabilities = capabilities;
          on_attach = default_on_attach;
          cmd = { "${pkgs.rust-analyzer}/bin/rust-analyzer"};
          settings = {
            ["rust-analyzer"] = {
                imports = {
                    granularity = {
                        group = "module",
                    },
                    prefix = "self",
                },
                cargo = {
                    buildScripts = {
                        enable = true,
                    },
                },
                procMacro = {
                    enable = true
                },
            }
          }
        }

  '';
}
