-- Calculate dynamic split width based on textwidth/colorcolumn
local function calculate_claude_width()
    -- Get max line width from Neovim settings
    local max_width = vim.opt.textwidth:get()

    -- Fallback to colorcolumn if textwidth not set
    if max_width == 0 then
        local colorcolumn = vim.opt.colorcolumn:get()
        if colorcolumn ~= "" then
            max_width = tonumber(colorcolumn) or 0
        end
    end

    -- Default to 80 if neither is set
    if max_width == 0 then
        max_width = 80
    end

    -- Calculate available space
    local total_cols = vim.o.columns
    local gutter_width = 10 -- Approximate width for line numbers, sign column, padding
    local editor_content_width = max_width + gutter_width
    local claude_width = total_cols - editor_content_width

    -- Ensure Claude gets at least 50 columns
    if claude_width < 50 then
        claude_width = 50
    end

    -- Calculate percentage
    local split_percentage = claude_width / total_cols

    -- Cap at 50% maximum to prevent Claude from dominating
    if split_percentage > 0.5 then
        split_percentage = 0.5
    end

    -- Ensure minimum of 20% (fallback safety)
    if split_percentage < 0.2 then
        split_percentage = 0.4 -- Use default if calculation seems wrong
    end

    return split_percentage
end

return {
    "coder/claudecode.nvim",
    lazy = false,
    dependencies = {
        "folke/snacks.nvim", -- Optional but recommended for enhanced terminal support
    },
    opts = {
        terminal = {
            split_side = "right",
            split_width_percentage = calculate_claude_width(),
        },
        terminal_cmd = "claude",
    },
}
