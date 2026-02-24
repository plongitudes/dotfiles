return {
    "3rd/image.nvim",
    cond = not vim.g.neovide,
    ft = { "markdown", "python" },
    opts = {
        backend = "kitty", -- Ghostty uses Kitty protocol
        integrations = {
            markdown = { enabled = false },
        },
        max_width = 100,
        max_height = 30,
        window_overlap_clear_enabled = true,
    },
}
