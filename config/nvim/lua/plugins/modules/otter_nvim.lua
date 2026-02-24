return {
	"jmbuhr/otter.nvim",
	ft = { "python", "markdown" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		buffers = {
			set_filetype = true,
			write_to_disk = false,
		},
		handle_leading_whitespace = true,
	},
}
