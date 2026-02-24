return {
	"mason-org/mason.nvim",
    dependencies = {
        "mason-org/mason-lspconfig.nvim"
    },
    opts = {},
    require("mason").setup({
        pip = {
            ---@since 1.0.0
            -- Whether to upgrade pip to the latest version in the virtual environment before installing packages.
            upgrade_pip = true,
        },

        ui = {
            -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
            -- Defaults to `:h 'winborder'` if nil.
            border = "rounded",

            ---@since 1.11.0
            -- The backdrop opacity. 0 is fully opaque, 100 is fully transparent.
            backdrop = 60,

            ---@since 1.0.0
            -- Width of the window. Accepts:
            -- - Integer greater than 1 for fixed width.
            -- - Float in the range of 0-1 for a percentage of screen width.
            width = 0.8,

            ---@since 1.0.0
            -- Height of the window. Accepts:
            -- - Integer greater than 1 for fixed height.
            -- - Float in the range of 0-1 for a percentage of screen height.
            height = 0.9,
        },
    }),
}
