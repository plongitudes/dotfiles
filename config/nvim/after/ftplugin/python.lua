vim.g.python_indent = {}
vim.g.python_indent = {
	disable_parentheses_indenting = "v:true",
	closed_paren_align_last_line = "v:true",
	searchpair_timeout = 150,
	continue = "shiftwidth() * 2",
	open_paren = "shiftwidth() * 2",
	nested_paren = "shiftwidth()",
}

-- Activate otter for LSP completions in code cells (Jupyter/Pyscript)
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.py",
	callback = function()
		-- Only activate if file has cell markers (# %%)
		local lines = vim.api.nvim_buf_get_lines(0, 0, 20, false)
		for _, line in ipairs(lines) do
			if line:match("^# %%%%") then
				local ok, otter = pcall(require, "otter")
				if ok then
					otter.activate()
				end
				return
			end
		end
	end,
})
