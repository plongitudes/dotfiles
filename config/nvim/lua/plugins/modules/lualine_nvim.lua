return {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
        "echasnovski/mini.icons",
    },
    config = function()
        require("lualine").setup({
            options = {
                theme = "gruvbox_dark",
            },
        })
    end,
}
