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
          disableLanguageServices = false,
          disableOrganizeImports = false,
          openFilesOnly = false,
        },
        python = {
          analysis = {
            autoImportCompletions = true,
            autoSearchPaths = true,
            diagnosticMode = 'workspace',
            extraPaths = {
            },
            pylintPath = {
            },
          },
          good_names_rgxs = {'[a-z]{1,3}'},
        },
      },
      single_file_support = true,
    }) -- end pyright

    require('lspconfig').lua_ls.setup({
      on_init = function(client)
        local path = client.workspace_folders[1].name
        if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
          client.config.settings = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              library = { vim.env.VIMRUNTIME },
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
              -- library = vim.api.nvim_get_runtime_file('', true)
            },
          })

          client.notify(
            'workspace/didChangeConfiguration',
            {settings = client.config.settings}
          )
        end
        return true
      end
    })
  end
}
