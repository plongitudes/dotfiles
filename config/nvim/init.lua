vim.lsp.log.set_level("warn")
require("plongitudes")

-- Only load plugins and colorscheme when not in VSCode
if not vim.g.vscode then
    require("plugins")
    vim.cmd("colorscheme gruvbox-baby")

    -- LSP reference highlights (used by snacks.words)
    --   Text: neutral warm grey  |  Read: cool blue tint  |  Write: warm amber tint
    vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#615956", fg = "#d6a808", bold = true })
    vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#425660", fg = "#139ee3", bold = true })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#604428", fg = "#fd8915", bold = true })
else
    -- Load VSCode-specific keymaps
    require("plongitudes.vscode-keymaps")
end
