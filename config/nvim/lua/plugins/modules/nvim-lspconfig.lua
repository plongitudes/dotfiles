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

                -- Migrated to which-key for better discoverability
                local wk = require("which-key")
                wk.add({
                    { "gD", vim.lsp.buf.declaration, desc = "Go to Declaration", buffer = ev.buf },
                    { "K", vim.lsp.buf.hover, desc = "Hover Documentation", buffer = ev.buf },
                    { "gi", vim.lsp.buf.implementation, desc = "Go to Implementation", buffer = ev.buf },
                    { "<C-k>", vim.lsp.buf.signature_help, desc = "Signature Help", buffer = ev.buf },
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

                -- Original keymaps (commented out - now managed by which-key)
                --vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                --vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts) -- migrated
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
                --vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts) -- migrated
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
                    autoImportCompletions = true,
                    analysis = {
                        --autoSearchPaths = true,
                        --useLibraryCodeForTypes = true,
                        ignore = { "*" },
                        typeCheckingMode = "off",
                        -- Custom stubs for completion (e.g., Pyscript)
                        extraPaths = {
                            vim.fn.expand("~/.dotfiles/python_stubs/stubs"),
                        },
                    },
                },
            },
        }

        -- Ruff: deactivate signature help to avoid duplicate popups
        vim.lsp.config.ruff = {
            root_markers = { "pyproject.toml", "ruff.toml", ".git" },
            capabilities = vim.tbl_deep_extend("force", default_capabilities, {
                signatureHelpProvider = false, -- Disable signature help (basedpyright handles this)
            }),
            settings = {
                -- Ruff uses project's ruff.toml configuration
                logLevel = "warn",
                configurationPreference = "filesystemFirst",
                format = {
                    enable = true,
                },
                codeAction = {
                    enable = true,
                    disableRuleCommand = { enable = true },
                    organizeImports = true,
                    showSyntaxErrors = true,
                    fixViolation = { enable = true },
                    lint = { enable = true },
                },
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

        -- Enable basedpyright and ruff for Python files
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "python",
            callback = function(args)
                vim.lsp.enable("basedpyright")
                vim.lsp.enable("ruff")

                -- Organize imports before save (runs before conform's format_on_save)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = args.buf,
                    callback = function()
                        if vim.g.format_on_save then
                            vim.lsp.buf.code_action({
                                context = { only = { "source.organizeImports" } },
                                apply = true,
                            })
                        end
                    end,
                })
            end,
        })

        -- Enable lua_ls for Lua files
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "lua",
            callback = function()
                vim.lsp.enable("lua_ls")
            end,
        })
    end,
}
