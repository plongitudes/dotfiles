return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'neovim/nvim-lspconfig', -- lsp server configuration
  },
  config = function()
    require('lspconfig').pyright.setup({
      cmd = {'pyright-langserver', '--stdio'},
      filetypes = {'python'},
      settings = {
        pyright = {
          disableLanguageServices = true,
        },
        python = {
          analysis = {
            autoImportCompletions = true,
            autoSearchPaths = true,
            diagnosticMode = 'workspace',
            useLibraryCodeForTypes = true,
            extraPaths = {},
            pylintPath = {},
          },
          good_names_rgxs = {'[a-z]{1,3}'},
        },
      },
      single_file_support = true,
    }) -- end pyright
  end
}
