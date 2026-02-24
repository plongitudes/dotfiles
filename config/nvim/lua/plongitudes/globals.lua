function pp(obj)
	local output = vim.inspect(obj)
	local msg_line_count = select(2, output:gsub("\n", "\n"))
	local message_height
	local win_width = vim.fn.winwidth(0)
	local win_height = vim.fn.winheight(0)

	if (win_height / 2) > msg_line_count then
		message_height = msg_line_count
	else
		message_height = (win_height / 2)
	end

	vim.cmd("messages")
	vim.cmd("resize " .. win_height - message_height)
end
