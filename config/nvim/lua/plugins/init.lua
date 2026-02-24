-- Skip plugin loading entirely when in VSCode
if vim.g.vscode then
  return
end

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("plugins.modules", {
  defaults = {
    lazy = true,
  },
  change_detection = {
    enabled = false,
  },
})

--require("lazy").setup("plugins", {
--  change_detection = {
--    enabled = false
--  },
--})
