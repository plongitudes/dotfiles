return {
	"alexghergh/nvim-tmux-navigation",
	lazy = false,
	enabled = false, -- replaced by smart-splits.nvim (works across tmux + wezterm)
	dependencies = {},
	config = function()
		require("nvim-tmux-navigation").setup({
			disable_when_zoomed = true, -- defaults to false
			keybindings = {
				left = "<M-h>",
				down = "<M-j>",
				up = "<M-k>",
				right = "<M-l>",
				last_active = "<M-\\>",
				next = "<M-Space>",
			},
		})
	end,
}
