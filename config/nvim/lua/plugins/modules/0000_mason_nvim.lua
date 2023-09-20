return {
    'williamboman/mason.nvim',
    lazy = false,
    dependencies = {
      'williamboman/mason-lspconfig.nvim', --tie mason to nvim-lspconfig
      'WhoIsSethDaniel/mason-tool-installer.nvim', -- require list of tools
      'RubixDev/mason-update-all', -- update all mason tools at once
      'mfussenegger/nvim-lint', -- linting
      'mhartington/formatter.nvim', -- format runner
      'm4xshen/autoclose.nvim', -- autoclose pairs
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'pyright',
          'lua_ls',
          'ruby_ls',
          'rubocop',
        },
      })
      -- the following is set up in nvim-lspconfig
      --[[require('mason-lspconfig').setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function (server_name) -- default handler (optional)
            require('lspconfig')[server_name].setup {}
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, a handler override for the `rust_analyzer`:
        ['pyright'] = function ()
            require('pyright').setup {}
            require('lua-language-server').setup {}
        end
      }]]--
    end,
}
