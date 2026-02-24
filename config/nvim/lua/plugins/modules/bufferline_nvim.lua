return {
	"akinsho/bufferline.nvim",
	lazy = false,
	enabled = true,
	version = "*",
	dependencies = {
		"echasnovski/mini.icons",
	},
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers",
				themable = true,
				indicator = {
					style = "underline",
				},
				buffer_close_icon = "󰅖",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				separator_style = "slant",
				sort_by = "directory",
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
				diagnostics = "nvim_lsp",
				--- count is an integer representing total count of errors
				--- level is a string "error" | "warning"
				--- diagnostics_dict is a dictionary from error level ("error", "warning" or "info")to number of errors for each level.
				--- this should return a string
				--- Don't get too fancy as this function will be executed a lot
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local icon = level:match("error") and " " or " "
					return " " .. icon .. count
				end,
				highlights = {
					--[[
          fill = {
            fg = '#ffffff',
            bg = '#ffffff',
          },
          ]]
					--
					background = {
						fg = "#00ff00",
						bg = "#0000ff",
					},
					tab_separator_selected = {
						underline = "#ff0000",
					},
				},
			},
		})
	end,
}
