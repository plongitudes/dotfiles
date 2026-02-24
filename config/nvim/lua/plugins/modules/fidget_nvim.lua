return {
    "j-hui/fidget.nvim",
    opts = {
        -- Options for notification subsystem
        notification = {
            window = {
                winblend = 0,
                border = "none",
            },
        },
        -- Options for LSP progress subsystem
        progress = {
            display = {
                render_limit = 16,
                done_ttl = 3,
                done_icon = "✔",
                progress_icon = { pattern = "dots", period = 1 },
            },
        },
    },
}
