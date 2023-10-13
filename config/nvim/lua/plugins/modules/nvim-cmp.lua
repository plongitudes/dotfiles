return {
  -- following the help laid out in:
  -- https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/

  'hrsh7th/nvim-cmp',
  lazy = false,

  dependencies = {
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',

    --the following two plugins both start popups for documentation while in function parens
    --'hrsh7th/cmp-nvim-lsp-signature-help',
    'ray-x/lsp_signature.nvim',

    'L3MON4D3/LuaSnip',
    'windwp/nvim-autopairs',
    -- font glyphs for completion popups
    'onsails/lspkind.nvim',
  },

  config = function()
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    local lspkind = require('lspkind')
    cmp.setup({
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },

      preselect = {
        cmp.PreselectMode.Item,
      },

      completion = {
        completeopt = 'menu,menuone,preview',
      },

      window = {
        completion = cmp.config.window.bordered({
          -- rounded, shadow, 
          border = 'rounded',
          pumblend = 50,
          winhighlight = "Normal:CmpNormal",
        }),
        documentation = cmp.config.window.bordered({
          border = 'rounded',
          pumblend = 50,
          winhighlight = "Normal:CmpDocNormal",
        }),
      },

      formatting = {
        format = lspkind.cmp_format({
          -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
          mode = 'symbol_text',
          -- prevent the popup from showing more than provided characters (e.g 50 will not show
          -- more than 50 characters)
          maxwidth = 160,
          -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
          -- (must define maxwidth first)
          ellipsis_char = '...',

          -- The function below will be called before any actual modifications from lspkind
          -- so that you can provide more controls on popup customization.
          -- (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          --before = function (entry, vim_item)
          --  ...
          --  return vim_item
          --end
        })
      },

      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<M-f>'] = cmp.mapping.complete(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<C-e>'] = cmp.mapping.abort(),
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        --['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        --['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
        --['<Tab>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
      }),


      sources = cmp.config.sources(
      {
        { name = 'nvim_lsp', max_item_count = 10 },
      }, {
        { name = 'luasnip' },
      }, {
        { name = 'buffer', max_item_count = 5 },
      }, {
        { name = 'path' },
      }, {
        { name = 'nvim_lsp_signature_help' },
      }, {
        { name = 'cmdline' },
      }),
    })

    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )
    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
        { name = 'git' },
      }, {
        { name = 'buffer' },
      })
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      })
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      })
    })

    -- Set up lspconfig.
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
    require('lspconfig')['pyright'].setup {
      capabilities = capabilities
    }
    require('lspconfig')['lua_ls'].setup {
      capabilities = capabilities
    }
    require('lspconfig')['ruby_ls'].setup {
      capabilities = capabilities
    }
  end
}

