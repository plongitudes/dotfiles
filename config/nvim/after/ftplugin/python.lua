--vim.opt_local.shiftwidth = 2
--vim.opt_local.softtabstop = 2
vim.g.python_indent = {}
vim.g.python_indent = {
  disable_parentheses_indenting = "v:true",
  closed_paren_align_last_line = "v:true",
  searchpair_timeout = 150,
  continue = "shiftwidth() * 2",
  open_paren = "shiftwidth() * 2",
  nested_paren = "shiftwidth()"
}
