local M = {}

function M.setup()
  --M.remaps()
  if vim.g.neovide then
    -- 1. Set the clipboard to the OS default (unnamedplus)
    -- This makes 'y' copy to the Windows clipboard automatically.
    vim.o.clipboard = "unnamedplus"

    -- 2. Map Shift+Insert to Paste
    -- Neovide is a GUI, so it doesn't inherit terminal "Shift+Insert" behavior
    -- by default; you have to map it manually to the clipboard register (+).

    -- Insert Mode: Paste from clipboard at cursor
    vim.keymap.set("i", "<S-Insert>", "<C-R><C-o>+", { noremap = true, silent = true })

    -- Command Mode: Paste from clipboard into the command line (e.g. for searching)
    vim.keymap.set("c", "<S-Insert>", "<C-R>+", { noremap = true, silent = true })

    -- Normal Mode: Paste from clipboard
    vim.keymap.set("n", "<S-Insert>", '"+P', { noremap = true, silent = true })

    -- Visual Mode: Replace selection with clipboard content
    vim.keymap.set("v", "<S-Insert>", '"+P', { noremap = true, silent = true })

    -- Cmd+V to paste (macOS). Neovide forwards Cmd as <D-...>; without these
    -- mappings the raw keycode "<D-v>" gets inserted as literal text.
    vim.keymap.set("i", "<D-v>", "<C-R><C-o>+", { noremap = true, silent = true })
    vim.keymap.set("c", "<D-v>", "<C-R>+", { noremap = true, silent = true })
    vim.keymap.set("n", "<D-v>", '"+P', { noremap = true, silent = true })
    vim.keymap.set("v", "<D-v>", '"+P', { noremap = true, silent = true })
    vim.keymap.set("t", "<D-v>", [[<C-\><C-n>"+pi]], { noremap = true, silent = true })

    -- Cmd+C to copy the visual selection to the system clipboard (macOS).
    vim.keymap.set("v", "<D-c>", '"+y', { noremap = true, silent = true })

    -- dynamically resize UI in-session
    vim.keymap.set({ "n", "v" }, "<D-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<D-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<D-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
  end
end

-- https://neovim.io/doc/user/api.html#nvim_set_keymap()
-- :h nvim_set_keymap
function M.remaps()
  --nothing to see here, go to which-key_nvim.lua
end

M.setup()
