return {
  'lukas-reineke/indent-blankline.nvim',
  lazy = false,
  init = function()
    vim.opt.termguicolors = true
    vim.cmd [[highlight IndentBlanklineIndent1 guifg=#776600 gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent2 guifg=#333333 gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent3 guifg=#776600 gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent4 guifg=#333333 gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent5 guifg=#776600 gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent6 guifg=#333333 gui=nocombine]]

    vim.opt.list = true
    --vim.opt.listchars:append "space:⋅"
    --vim.opt.listchars:append "eol:↴"
  end,

  config = function()
    require("indent_blankline").setup({
      -- for example, context is off by default, use this to turn it on
      show_current_context = true,
      show_current_context_start = true,
      show_end_of_line = true,
      space_char_blankline = " ",
      char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
      },
    })
  end
}
