return {
	"nvim-mini/mini.nvim",
	version = false,
	lazy = false,
	config = function()
		-- Mini modules should be required individually
		require("mini.map").setup({
			-- Minimap configuration
			integrations = {
				require("mini.map").gen_integration.builtin_search(),
				require("mini.map").gen_integration.gitsigns(),
				require("mini.map").gen_integration.diagnostic(),
				require("mini.map").gen_integration.diagnostic(),
			},
			symbols = {
				encode = require("mini.map").gen_encode_symbols.dot("4x2"),
			},
		})

		-- Enable additional mini modules
		require("mini.icons").setup({
			-- Use default style with colors
			style = "glyph", -- or 'ascii' if you want text-based icons
			use_file_extension = function(ext, file)
				return true
			end,
		})
		-- Make mini.icons the default icon provider
		MiniIcons.mock_nvim_web_devicons()

		require("mini.pairs").setup() -- Auto-pairs for brackets, quotes, etc.
		require("mini.surround").setup() -- Surround text objects (like vim-surround)
		require("mini.comment").setup() -- Enhanced commenting
		require("mini.notify").setup() -- Better notifications

		require("mini.files").setup({
			mappings = {
				close = "<esc>",
				go_in = "l",
				go_in_plus = "L",
				go_out = "h",
				go_out_plus = "H",
				mark_goto = "'",
				mark_set = "m",
				reset = "<BS>",
				reveal_cwd = "@",
				show_help = "g?",
				synchronize = "=",
				trim_left = "<",
				trim_right = ">",
			},
		})
		--require('mini.starter').setup()      -- Start screen
	end,
}
