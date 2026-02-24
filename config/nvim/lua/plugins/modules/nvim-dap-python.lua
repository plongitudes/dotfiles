return {
	"mfussenegger/nvim-dap-python",
	lazy = false,
	enabled = true,
	config = function()
		-- Use Mason's debugpy as the adapter (it has debugpy installed)
		local debugpy_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/Scripts/python.exe"

		-- Setup nvim-dap-python with Mason's debugpy
		require("dap-python").setup(debugpy_python, {
			-- Don't include default configurations (we use launch.json instead)
			include_configs = false,
		})

		-- Override the adapter to ensure it uses Mason's debugpy Python
		local dap = require("dap")
		dap.adapters.python = {
			type = "executable",
			command = debugpy_python,
			args = { "-m", "debugpy.adapter" },
		}

		-- This still provides useful commands like:
		-- :DapTestMethod - Debug the test method under cursor
		-- :DapTestClass - Debug the test class under cursor
		-- :DapDebugSelection - Debug selected code
	end,
}
