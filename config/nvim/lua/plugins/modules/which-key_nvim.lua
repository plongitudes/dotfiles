--[[  folke/which-key.nvim

when creating mappings by calling `register({mappings},{opts})`, these are the defaults for opts:

  {
    mode = 'n',                 -- NORMAL mode
    -- prefix: use '<leader>f' for example for mapping everything related to finding files
    -- the prefix is prepended to every mapping part of `mappings`
    prefix = '<leader>',
    -- Global mappings. Specify a buffer number for buffer local mappings
    buffer = nil,
    -- use `silent` when creating keymaps
    silent = true,
    -- use `noremap` when creating keymaps
    noremap = true,
    -- use `nowait` when creating keymaps
    nowait = false,
    -- use `expr` when creating keymaps
    expr = false,
  },
]]

--

return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = {
        "echasnovski/mini.icons",
    },
    opts = {
        preset = "modern",
        notify = true,
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.add({
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },

            { ":", ":", desc = "<Plug>(cmdpalette)" },
            { "<leader>p", group = "Formatting" },
            { "<leader>pl", "gql", desc = "Format comments in line" },
            { "<leader>pp", "gqip", desc = "Format comments in paragraph" },

            { "<leader>a", group = "[A]nthropic Claude Code" },
            { "<leader>aa", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer to Claude" },
            { "<leader>ac", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude session" },
            { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude Code" },
            { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude session" },
            { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
            { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
            { "<leader>ad", group = "Claude [D]iff operations" },
            { "<leader>ada", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
            { "<leader>add", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny Claude diff" },

            { "<leader>c", group = "[C]ode Actions" },

            { "<leader>w", group = "[W]orkspace" },

            { "<leader>t", group = "[T]erminal" },
            {
                "<leader>tt",
                function()
                    Snacks.terminal.toggle()
                end,
                desc = "Toggle terminal",
            },

            {
                "<leader><leader>",
                function()
                    require("snacks").picker.smart()
                end,
                desc = "Smart Picker (context-aware)",
            },

            { "<leader>f", group = "[F]inding things" },
            {
                "<leader>fd",
                function()
                    require("snacks").dashboard.open()
                end,
                desc = "[D]ashboard",
                remap = true,
            },
            {
                "<leader>ff",
                function()
                    require("mini.files").open()
                end,
                desc = "[F]ile Browser",
                remap = true,
            },
            {
                "<leader>fr",
                function()
                    require("snacks").picker.recent()
                end,
                desc = "[R]ecent Files",
                remap = true,
            },
            {
                "<leader>fe",
                function()
                    require("snacks").picker.grep_word()
                end,
                desc = "Gr[e]p Word under Cursor",
            },
            {
                "<leader>ft",
                function()
                    require("snacks").picker.git_files()
                end,
                desc = "Git ls-files",
            },
            {
                "<leader>fg",
                function()
                    require("snacks").picker.grep()
                end,
                desc = "Rip[g]rep String",
            },
            {
                "<leader>fc",
                function()
                    require("snacks").picker.files()
                end,
                desc = "Find Files in [c]wd",
            },
            {
                "<leader>fn",
                function()
                    require("snacks").picker.notifications()
                end,
                desc = "[N]otification History",
            },

            { "g", group = "[G]o to" },
            { "gb", "<cmd>BufferLinePick<cr>", desc = "Select buffer" },
            { "gc", "<cmd>BufferLinePickClose<cr>", desc = "Select buffer to close" },
            { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
            {
                "gr",
                function()
                    require("snacks").picker.lsp_references()
                end,
                desc = "Show LSP references",
            },
            {
                "grr",
                function()
                    require("snacks").picker.lsp_references()
                end,
                desc = "Show LSP references",
            },
            {
                "gs",
                function()
                    require("snacks").picker.lsp_symbols()
                end,
                desc = "LSP Symbols",
            },
            {
                "gi",
                function() --only show instantiations
                    local symbol = vim.fn.expand("<cword>")
                    Snacks.picker.lsp_references({
                        include_declaration = false,
                        title = "Instantiations of " .. symbol,
                        -- Filter out non-calls early (transform runs before matching/formatting)
                        transform = function(item)
                            -- `item.text` contains the line snippet; keep only lines like `Foo(` or `Foo (`
                            local line = (item and item.text) or ""
                            return line:match(symbol .. "%s*%(") and item or false
                        end,
                        -- optional: auto-confirm if exactly one instantiation remains
                        auto_confirm = true,
                    })
                end,
                desc = "Find class instantiations",
            },

            { "<leader>o", "<cmd>Outline<cr>", desc = "Open Outline" },

            { "<leader>d", group = "[D]ebug / [D]iagnostics" },

            -- Debug (DAP) keybindings
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Toggle breakpoint",
            },
            {
                "<leader>dB",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "Conditional breakpoint",
            },
            {
                "<leader>dc",
                function()
                    require("dap").continue()
                end,
                desc = "Continue / Start debugging",
            },
            {
                "<leader>dt",
                function()
                    require("dap").terminate()
                end,
                desc = "Terminate debugging",
            },
            {
                "<leader>di",
                function()
                    require("dap").step_into()
                end,
                desc = "Step into",
            },
            {
                "<leader>do",
                function()
                    require("dap").step_over()
                end,
                desc = "Step over",
            },
            {
                "<leader>dO",
                function()
                    require("dap").step_out()
                end,
                desc = "Step out",
            },
            {
                "<leader>dr",
                function()
                    require("dap").repl.open()
                end,
                desc = "Open REPL",
            },
            {
                "<leader>dl",
                function()
                    require("dap").run_last()
                end,
                desc = "Run last debug config",
            },
            {
                "<leader>du",
                function()
                    require("dapui").toggle()
                end,
                desc = "Toggle DAP UI",
            },
            {
                "<leader>de",
                function()
                    require("dapui").eval()
                end,
                desc = "Evaluate expression",
                mode = { "n", "v" },
            },
            { "<leader>dI", "<cmd>DapInitProject<cr>", desc = "Initialize DAP project (create launch.json)" },

            -- Diagnostics keybindings
            { "<leader>dh", "<cmd>lua vim.diagnostic.goto_prev()<cr>zz", desc = "PREV diagnostic" },
            { "<leader>dj", "<cmd>lua vim.diagnostic.goto_next()<cr>zz", desc = "NEXT diagnostic" },
            { "<leader>df", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Show diagnostics in floating window" },
            {
                "<leader>dD",
                function()
                    require("snacks").picker.diagnostics()
                end,
                desc = "Show all diagnostics",
            },
            { "<leader>b", group = "[B]uffer Operations" },
            {
                "<leader>bb",
                function()
                    require("snacks").picker.buffers()
                end,
                desc = "[B]uffers",
            },
            {
                "<leader>bm",
                function()
                    vim.fn.setreg("+", vim.api.nvim_exec2("messages", { output = true }).output)
                    vim.notify("Messages yanked to clipboard")
                end,
                desc = "Yank :messages buffer to clipboard",
            },
            {
                "<leader>bM",
                function()
                    vim.cmd("new")
                    vim.bo.buftype = "nofile"
                    vim.bo.bufhidden = "wipe"
                    vim.bo.swapfile = false
                    local output = vim.api.nvim_exec2("messages", { output = true }).output
                    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, "\n"))
                end,
                desc = "Open :messages in scratch buffer",
            },

            { "<leader>g", group = "Git [C]hanges" },
            { "<leader>gl", "<cmd>Gitsigns next_hunk<cr>zz", desc = "next changed hunk" },
            { "<leader>gh", "<cmd>Gitsigns prev_hunk<cr>zz", desc = "prev changed hunk" },
            { "<leader>gb", "<cmd>Gitsigns blame<cr>", desc = "open [b]lame" },
            { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "[d]iff this file" },
            { "<leader>gw", "<cmd>Gitsigns toggle_word_diff<cr>", desc = "toggle [w]ord diff" },
            { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "[s]tage hunk" },
            { "<leader>gr", "<cmd>Gitsigns stage_hunk<cr>", desc = "[r]eset hunk" },
            { "<leader>gz", "<cmd>LazyGit<cr>", desc = "La[z]yGit" },

            -- Molten (Jupyter) keybindings
            { "<leader>m", group = "[M]olten (Jupyter)" },
            { "<leader>mi", "<cmd>MoltenInit<cr>", desc = "Init kernel (select from list)" },
            { "<leader>ms", "<cmd>MoltenSetupPyscript<cr>", desc = "Setup HA Pyscript kernel" },
            { "<leader>me", "<cmd>MoltenEvaluateOperator<cr>", desc = "Evaluate operator" },
            { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = "Evaluate line" },
            { "<leader>mr", "<cmd>MoltenReevaluateCell<cr>", desc = "Re-evaluate cell" },
            { "<leader>mo", "<cmd>MoltenShowOutput<cr>", desc = "Show output" },
            { "<leader>mh", "<cmd>MoltenHideOutput<cr>", desc = "Hide output" },
            { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "Delete cell" },
            { "<leader>e", ":<C-u>MoltenEvaluateVisual<cr>gv", mode = "v", desc = "Evaluate selection" },
            { "<leader>me", ":vip:MoltenEvaluateVisual<cr>ip", mode = "v", desc = "Evaluate cell" },

            -- { "<C-h>", "<C-w>h", desc = "Focus window left" },
            -- { "<C-j>", "<C-w>j", desc = "focus window down" },
            -- { "<C-k>", "<C-w>k", desc = "focus window up" },
            -- { "<C-l>", "<C-w>l", desc = "focus window right" },

            { "<leader>q", group = "[Q]uit / Dashboard" },
            {
                "<leader>qq",
                function()
                    -- Collect unsaved buffers
                    local unsaved = {}
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
                            table.insert(unsaved, buf)
                        end
                    end

                    -- Process unsaved buffers one at a time, then wipe all and open dashboard
                    local function process(i)
                        if i > #unsaved then
                            vim.cmd("%bdelete!")
                            Snacks.dashboard.open()
                            return
                        end
                        local buf = unsaved[i]
                        -- Skip if buffer was closed during earlier prompts
                        if not vim.api.nvim_buf_is_valid(buf) then
                            return process(i + 1)
                        end
                        local name = vim.api.nvim_buf_get_name(buf)
                        if name == "" then
                            name = "[No Name]"
                        else
                            name = vim.fn.fnamemodify(name, ":t")
                        end
                        vim.ui.select({ "Save", "Discard", "Cancel" }, {
                            prompt = "Unsaved changes in " .. name .. ":",
                        }, function(choice)
                            if choice == "Save" then
                                vim.api.nvim_buf_call(buf, function()
                                    vim.cmd("write")
                                end)
                                process(i + 1)
                            elseif choice == "Discard" then
                                vim.bo[buf].modified = false
                                process(i + 1)
                            else
                                -- Cancel: abort the whole operation
                            end
                        end)
                    end
                    process(1)
                end,
                desc = "Close all buffers → Dashboard",
            },
            {
                "]]",
                function()
                    Snacks.words.jump(vim.v.count1)
                end,
                desc = "Next Reference (snacks.words)",
                mode = { "n", "t" },
            },
            {
                "[[",
                function()
                    Snacks.words.jump(-vim.v.count1)
                end,
                desc = "Prev Reference (snacks.words)",
                mode = { "n", "t" },
            },

            { "n", "nzzzv", desc = "next search and center" },
            { "*", "*zzzv", desc = "next word under cursor and center" },
            { "N", "Nzzzv", desc = "next and center" },
            { "#", "#zzzv", desc = "prev word under cursor and center" },
        })
    end,
}
