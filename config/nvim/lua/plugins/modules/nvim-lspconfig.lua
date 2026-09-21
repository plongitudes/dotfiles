local function system(command)
  local file = assert(io.popen(command, "r"))
  local output = file:read("*all"):gsub("%s+", "")
  file:close()
  return output
end

--if vim.fn.executable("python3") > 0 then
--vim.g.python3_host_prog = system("which python3")
--end

return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  config = function()
    -- Set default capabilities for all LSP servers
    local default_capabilities = vim.lsp.protocol.make_client_capabilities()
    default_capabilities.offsetEncoding = { "utf-8", "utf-16" }

    -- Apply default capabilities to all future servers
    vim.lsp.config("*", {
      capabilities = default_capabilities,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }

        -- LSP keymaps, registered via which-key (keymaps are centralized there)
        local wk = require("which-key")
        wk.add({
          { "gD", vim.lsp.buf.declaration, desc = "Go to Declaration", buffer = ev.buf },
          {
            "K",
            function()
              -- TypeScope takes over K for python: function symbols get the
              -- hover float + structure tree; everything else (and load
              -- failures) falls back to plain hover inside typescope.hover()
              local ok, typescope = pcall(require, "typescope")
              if ok and vim.bo.filetype == "python" then
                typescope.hover()
              else
                vim.lsp.buf.hover()
              end
            end,
            desc = "Hover Documentation (+TypeScope)",
            buffer = ev.buf,
          },
          { "gi", vim.lsp.buf.implementation, desc = "Go to Implementation", buffer = ev.buf },
          {
            "<C-k>",
            function()
              -- TypeScope unification (U1): same muscle memory, structured
              -- answer; core signature help for non-python buffers
              local ok, typescope = pcall(require, "typescope")
              if ok and vim.bo.filetype == "python" then
                typescope.open()
              else
                vim.lsp.buf.signature_help()
              end
            end,
            desc = "Signature Help (+TypeScope)",
            buffer = ev.buf,
          },
          { "<leader>wa", vim.lsp.buf.add_workspace_folder, desc = "Add Workspace Folder", buffer = ev.buf },
          {
            "<leader>wr",
            vim.lsp.buf.remove_workspace_folder,
            desc = "Remove Workspace Folder",
            buffer = ev.buf,
          },
          {
            "<leader>wl",
            function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            desc = "List Workspace Folders",
            buffer = ev.buf,
          },
          { "<leader>D", vim.lsp.buf.type_definition, desc = "Type Definition", buffer = ev.buf },
          { "<leader>rn", vim.lsp.buf.rename, desc = "Rename Symbol", buffer = ev.buf },
          {
            "<leader>ca",
            vim.lsp.buf.code_action,
            desc = "Code Actions",
            buffer = ev.buf,
            mode = { "n", "v" },
          },
          {
            "<leader>F",
            function()
              -- Organize imports first (ruff)
              vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports" } },
                apply = true,
              })
              -- Then format
              vim.defer_fn(function()
                vim.lsp.buf.format({ async = true })
              end, 100)
            end,
            desc = "Format & Organize Imports",
            buffer = ev.buf,
          },
        })

        -- Plain vim.keymap.set equivalents, kept for reference (the live copies
        -- are the which-key block above):
        --vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        --vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        --vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        --vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        --vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        --vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        --vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        --vim.keymap.set("n", "<space>wl", function()
        --    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        --end, opts)
        --vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        --vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        --vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        --vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        --vim.keymap.set("n", "<space>F", function()
        --    vim.lsp.buf.format({ async = true })
        --end, opts)
      end,
    })

    -- Configure basedpyright LSP server using new vim.lsp.config API
    -- Automatically detects pyrightconfig.json in project root
    vim.lsp.config.basedpyright = {
      cmd = { "basedpyright-langserver", "--stdio" },
      root_markers = { "pyrightconfig.json", "pyproject.toml", ".git" },
      capabilities = default_capabilities, -- Use shared capabilities
      settings = {
        basedpyright = {
          disableOrganizeImports = true,
          analysis = {
            autoImportCompletions = true,
            --autoSearchPaths = true,
            --useLibraryCodeForTypes = true,
            -- lint stays with ruff; basedpyright's "off" silences everything
            -- (unlike pyright), so missing imports need an explicit opt-in
            typeCheckingMode = "recommended",
            diagnosticSeverityOverrides = {
              reportMissingImports = "warning",
            },
            -- Custom stubs for completion (e.g., Pyscript)
            extraPaths = {
              vim.fn.expand("~/.dotfiles/python_stubs/stubs"),
            },
          },
        },
      },
    }

    -- Ruff: lint diagnostics, code actions, and formatting only. basedpyright
    -- is the language server (definition, references, completion, signature
    -- help, ...). The one capability the two share is hover -- ruff answers
    -- with rule docs when the cursor is on a flagged line -- so it's dropped
    -- here to keep K single-sourced. Server capabilities can only be turned
    -- off after the handshake, hence on_attach rather than `capabilities`.
    vim.lsp.config.ruff = {
      root_markers = { "pyproject.toml", "ruff.toml", ".git" },
      capabilities = default_capabilities,
      on_attach = function(client, _)
        client.server_capabilities.hoverProvider = false
      end,
      settings = {
        -- Ruff uses project's ruff.toml / pyproject.toml configuration
        logLevel = "warn",
        configurationPreference = "filesystemFirst",
      },
    }

    -- Configure lua_ls for Neovim Lua development
    vim.lsp.config.lua_ls = {
      cmd = { "lua-language-server" },
      root_markers = {
        ".luarc.json",
        ".luarc.jsonc",
        ".luacheckrc",
        ".stylua.toml",
        "stylua.toml",
        "selene.toml",
        ".git",
      },
      capabilities = default_capabilities,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT", -- Neovim uses LuaJIT
          },
          diagnostics = {
            globals = { "vim" }, -- Recognize 'vim' as a global
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true), -- Make the server aware of Neovim runtime files
            checkThirdParty = false, -- Disable third-party library prompts
          },
          telemetry = {
            enable = false,
          },
          format = {
            enable = false, -- Disable lua_ls formatting (we use stylua via conform)
          },
        },
      },
    }

    -- Configure sourcekit-lsp for Swift development
    -- Ships with Xcode CLI tools, not managed by Mason
    vim.lsp.config.sourcekit = {
      cmd = { "sourcekit-lsp" },
      root_markers = { "Package.swift", ".git" },
      capabilities = default_capabilities,
    }

    -- Configure bash-language-server for shell scripts
    -- Note: bashls runs shellcheck itself (bashIde.shellcheckPath) and publishes
    -- the results as LSP diagnostics, so shellcheck is deliberately NOT in
    -- nvim-lint's linters_by_ft for sh/bash -- that would double every warning.
    vim.lsp.config.bashls = {
      cmd = { "bash-language-server", "start" },
      root_markers = { ".git" },
      capabilities = default_capabilities,
      settings = {
        bashIde = {
          -- Resolved on $PATH; mason.nvim prepends its bin dir to vim.env.PATH,
          -- so this finds the mason-installed shellcheck. "" disables the
          -- integration entirely.
          shellcheckPath = "shellcheck",
          -- Non-recursive on purpose (lspconfig's default, not upstream's
          -- "**/*@(...)"): opening a stray ~/foo.sh with the recursive pattern
          -- makes the background analyzer walk all of $HOME.
          globPattern = "*@(.sh|.inc|.bash|.command)",
        },
      },
    }

    -- Configure nil for nix files. Mason-provided (not the flake) -- see the
    -- note in home/common/default.nix.
    -- nil is a pure-Nix-language server: it has no flake/option evaluation, so
    -- unlike nixd it can't complete home-manager option paths. The profile
    -- marker lookup that fed nixd's option expr is gone with it.
    vim.lsp.config.nil_ls = {
      cmd = { "nil" },
      root_markers = { "flake.nix", ".git" },
      capabilities = default_capabilities,
      settings = {
        ["nil"] = {
          -- Formatting stays with conform (alejandra); leaving nil's own
          -- formatting.command unset means nil advertises no formatting
          -- provider, so there's nothing for lsp_fallback to collide with.
          nix = {
            flake = {
              -- Don't auto-archive/eval flake inputs: on this flake that means
              -- fetching and evaluating nixpkgs on every open.
              autoArchive = false,
              autoEvalInputs = false,
            },
          },
        },
      },
    }

    -- Enable basedpyright and ruff for Python files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function(args)
        vim.lsp.enable("basedpyright")
        vim.lsp.enable("ruff")
      end,
    })

    -- Enable lua_ls for Lua files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "lua",
      callback = function()
        vim.lsp.enable("lua_ls")
      end,
    })

    -- Enable nil for nix configs
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "nix",
      callback = function()
        vim.lsp.enable("nil_ls")
      end,
    })

    -- Enable bashls for shell scripts. zsh is excluded: bashls parses with a
    -- bash grammar and reports zsh-only syntax as errors.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sh", "bash" },
      callback = function()
        vim.lsp.enable("bashls")
      end,
    })
  end,
}
