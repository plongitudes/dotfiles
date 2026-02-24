return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = {
		"mason-org/mason.nvim",
	},
	opts = {
		ensure_installed = {
			-- Python
			"basedpyright", -- LSP
			"ruff", -- LSP + formatter + linter

			-- Lua
			"lua-language-server", -- LSP
			"stylua", -- formatter
			"selene", -- linter

			-- DAP (debuggers)
			"debugpy", -- Python debugger
			"local-lua-debugger-vscode", -- Lua debugger
		},
		auto_update = false,
		run_on_start = true,
	},
}
