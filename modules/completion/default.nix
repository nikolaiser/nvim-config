{pkgs, lib, conifg, ...}:

with lib;

with builtins;

{

  config = {

    vim.startPlugins = with pkgs.neovimPlugins; [ nvim-cmp cmp-buffer cmp-luasnip cmp-path cmp-treesitter ];


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
    '';

  };
}
