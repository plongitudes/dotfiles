return {
	"mrjones2014/smart-splits.nvim",
	lazy = false,
	enabled = true,
	config = function()
		require("smart-splits").setup({
			-- when moving cursor between splits, the neovim cursor will be kept
			-- in the same relative position in the window
			cursor_follows_swapped_bufs = false,
			-- disable navigation when the current pane is zoomed in tmux
			at_edge = "stop",
		})

		-- navigation: Alt+h/j/k/l (matching previous nvim-tmux-navigation bindings)
		vim.keymap.set("n", "<M-h>", require("smart-splits").move_cursor_left)
		vim.keymap.set("n", "<M-j>", require("smart-splits").move_cursor_down)
		vim.keymap.set("n", "<M-k>", require("smart-splits").move_cursor_up)
		vim.keymap.set("n", "<M-l>", require("smart-splits").move_cursor_right)

		-- resize: Ctrl+Arrow (matching your tmux resize bindings)
		vim.keymap.set("n", "<C-Left>", require("smart-splits").resize_left)
		vim.keymap.set("n", "<C-Down>", require("smart-splits").resize_down)
		vim.keymap.set("n", "<C-Up>", require("smart-splits").resize_up)
		vim.keymap.set("n", "<C-Right>", require("smart-splits").resize_right)
	end,
}
