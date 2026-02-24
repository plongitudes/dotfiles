return {
	"hedyhli/outline.nvim",
	lazy = true,
	event = { "UIEnter" },
	cmd = { "Outline", "OutlineOpen" },
	enabled = true,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("outline").setup({
			outline_window = {
				position = "left",
				width = 22,
				relative_width = true,
				auto_width = true,
				max_width = 60,
				max_depth = 3,
				auto_jump = true,
				focus_on_open = true,
				center_on_jump = true,
			},
			symbol_folding = {
				autofold_depth = 2,
				auto_unfold = {
					hovered = true,
					only = true,
				},
			},
			guides = {
				enabled = true,
				markers = {
					-- It is recommended for bottom and middle markers to use the same number
					-- of characters to align all child nodes vertically.
					bottom = "└",
					middle = "├",
					vertical = "│",
				},
			},
			preview_window = {
				auto_preview = false,
			},
			outline_items = {
				show_symbol_lineno = true,
				highlight_hovered_item = true,
			},
			symbols = {
				filter = { "Variable", exclude = true },
			},
		})
	end,
}
