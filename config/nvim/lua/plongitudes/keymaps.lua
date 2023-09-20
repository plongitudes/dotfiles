local M = {}

function M.setup()
    M.remaps()
end

-- https://neovim.io/doc/user/api.html#nvim_set_keymap()
-- :h nvim_set_keymap
function M.remaps()
  local nr = {noremap = true}
  vim.api.nvim_set_keymap('n', 'n', 'nzz', nr)
  vim.api.nvim_set_keymap('n', 'N', 'Nzz', nr)
  vim.api.nvim_set_keymap('n', '*', '*zz', nr)
  vim.api.nvim_set_keymap('n', '#', '#zz', nr)
  vim.api.nvim_set_keymap('n', 'g*', 'g*zz', nr)
  vim.api.nvim_set_keymap('n', 'g#', 'g#zz', nr)
end

M.setup()
