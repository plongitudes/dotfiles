local M = {}

-- Custom statuscolumn that shows relative numbers starting from 1 instead of 0
-- This makes the displayed numbers match what you need to yank/delete
-- (e.g., seeing "5" means 5yy will yank 5 lines including the current line)
--
-- Performance note: This is called for every visible line on every redraw,
-- so we keep it simple and fast - just basic arithmetic and string concat.
function M.statuscolumn()
	local relnum = vim.v.relnum
	local virtnum = vim.v.virtnum

	-- Don't show line numbers for virtual lines (like wrapped lines)
	if virtnum ~= 0 then
		return ""
	end

	-- Sign column + line number with +1 offset for relative numbers
	if relnum == 0 then
		-- Current line: show absolute line number
		return "%s%=%l "
	else
		-- Other lines: show relative number + 1
		-- Using string concat instead of format for better performance
		return "%s%=" .. (relnum + 1) .. " "
	end
end

return M
