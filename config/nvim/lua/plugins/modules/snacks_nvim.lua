local proj_desc = "Select Project Root"
local last = require("plongitudes.project_switcher").get_last_project()
if last then
    proj_desc = "Select Project Root (last: " .. last.name .. ")"
end

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        -- animate: Animation library with 45+ easing functions
        animate = { enabled = true },

        -- bigfile: Disable features for large files
        bigfile = { enabled = true },

        -- dashboard: Beautiful declarative dashboards
        dashboard = {
            enabled = true,
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                { section = "startup" },
            },
            preset = {
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
		    {
         	    	icon = "󰉋 ",
			key = "p",
			desc = proj_desc,
			action = ":lua require('plongitudes.project_switcher').switch_to_project()",
		    },
		    { icon = " ", key = "v", desc = "Neovide", action = ":Neovide", enabled = vim.g.neovide ~= nil },
		    { icon = " ", key = "m", desc = "Mason", action = ":Mason" },
		    {
		    	icon = " ",
			key = "c",
			desc = "Config",
			action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})",
		    },
		    { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
        },

        -- dim: Focus on active scope by dimming the rest
        dim = { enabled = true },

        -- git: Git utilities
        git = { enabled = true },

        -- gitbrowse: Open files/repos in browser (GitHub, GitLab, etc.)
        gitbrowse = { enabled = true },

        -- image: Image viewer (kitty/wezterm/ghostty support)
        image = { enabled = true },

        -- indent: Indent guides with scope highlighting
        indent = { enabled = true },

        -- input: better vim.ui.input
        input = {
            enabled = true,
            icon = " ",
            icon_hl = "SnacksInputIcon",
            icon_pos = "left",
            prompt_pos = "title",
            win = { style = "input" },
            expand = true,
        },

        -- lazygit: LazyGit integration
        lazygit = { enabled = true },

        -- notify: Enhanced notification system (replaces noice.nvim)
        notify = {
            enabled = true,
            timeout = 3000,
        },

        -- picker: Fuzzy finder (replaces telescope.nvim)
        picker = {
            enabled = true,
            sources = {
                files = { hidden = true },
                grep = { hidden = true },
            },
            -- Use smart case matching
            matcher = {
                frecency = true,
            },
            -- hjkl navigation in picker list (not in input field)
            win = {
                input = {
                    keys = {
                        -- Keep hjkl available for typing in search
                    },
                },
                list = {
                    keys = {
                        ["j"] = "list_down",
                        ["k"] = "list_up",
                        ["h"] = "list_left",
                        ["l"] = "list_right",
                        ["<Down>"] = "list_down",
                        ["<Up>"] = "list_up",
                        ["<Left>"] = "list_left",
                        ["<Right>"] = "list_right",
                    },
                },
            },
        },

        -- quickfile: Fast file rendering for better performance
        quickfile = { enabled = true },

        -- rename: LSP rename with preview
        rename = { enabled = true },

        -- scope: Scope-aware buffer and tab management
        scope = { enabled = true },

        -- scratch: Scratch buffers
        scratch = { enabled = true },

        -- scroll: Smooth scrolling
        scroll = { enabled = true },

        -- select: Better vim.ui.select (replaces telescope-ui-select)
        select = { enabled = true },

        -- smartpicker: Intelligent context-aware picker that automatically chooses the right picker
        smartpicker = { enabled = true },

        -- statuscolumn: Better status column with git signs
        statuscolumn = { enabled = true },

        -- terminal: Enhanced terminal support (used by claudecode.nvim)
        terminal = { enabled = true },

        -- toggle: Toggle keymaps integrated with which-key
        toggle = { enabled = true },

        -- util: Utility functions library
        util = { enabled = true },

        -- words: LSP reference highlighting
        words = { enabled = true },

        -- zen: Distraction-free coding mode
        zen = { enabled = true },
    },
}
