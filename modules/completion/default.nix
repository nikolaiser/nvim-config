{ pkgs, lib, conifg, ... }:

with lib;

with builtins;
let
  copilotNodeCommand = "${lib.getExe pkgs.nodejs-slim}";
in

{

  config = {

    vim.startPlugins = with pkgs.neovimPlugins; [ nvim-cmp cmp-buffer cmp-luasnip cmp-path cmp-treesitter copilot-lua copilot-cmp ];


    vim.luaConfigRC = ''
      local cmp = require("cmp")
      local compare = require("cmp.config.compare")
      local defaults = require("cmp.config.default")()
      cmpOpts = {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            compare.offset, -- we still want offset to be higher to order after 3rd letter
            compare.score, -- same as above
            compare.sort_text, -- add higher precedence for sort_text, it must be above `kind`
            compare.recently_used,
            compare.kind,
            compare.length,
            compare.order,
          },
        },
      }
      cmp.setup(cmpOpts)

      require("copilot").setup({
        -- available options: https://github.com/zbirenbaum/copilot.lua
        copilot_node_command = "${copilotNodeCommand}",
        panel = {
          enabled = false,
          keymap = {
            jump_prev = false,
            jump_next = false,
            accept = false,
            refresh = false,
            open = false,
          },
          layout = {
            position = "bottom",
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = false,
          keymap = {
            accept = false,
            accept_word = false,
            accept_line = false,
            next = false,
            prev = false,
            dismiss = false,
          },
        },
      })

        require("copilot_cmp").setup()
    '';

  };
}
