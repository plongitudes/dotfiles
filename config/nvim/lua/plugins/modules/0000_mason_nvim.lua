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
    end,
}
