return {
    dir = vim.fn.expand("~/github/plongitudes/tidiest-evensong.nvim"),
    lazy = true,
    event = { "UIEnter" },
    cond = vim.g.neovide ~= nil,
	opts = {
		-- User-declared Neovide setting overrides (travels with dotfiles).
		-- These take precedence over built-in defaults; runtime tweaks from the
		-- UI persist to stdpath('data') and layer on top.
		--
		-- settings = {
		-- 	neovide_opacity = 0.9,
		-- 	neovide_floating_shadow = false,
		-- 	neovide_scroll_animation_length = 0.2,
		-- },
	},
}
