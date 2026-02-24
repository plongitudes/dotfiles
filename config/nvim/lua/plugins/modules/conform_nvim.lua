return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = {
		formatters_by_ft = {
			python = { "ruff_organize_imports", "ruff_format" }, -- ruff fix for isort, then format
			lua = { "stylua" }, -- Use stylua for Lua formatting
			swift = { "swiftformat" },
		},
		format_on_save = function(bufnr)
			-- Check the global format_on_save setting
			if not vim.g.format_on_save then
				return nil
			end
			return {
				timeout_ms = 500,
				lsp_fallback = true,
			}
		end,
	},
}
