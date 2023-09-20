return {
  'abecodes/tabout.nvim',
  config = function()
    require('tabout').setup({
      -- key to trigger tabout, set to an empty string to disable
      tabkey = '<Tab>',
      -- key to trigger backwards tabout, set to an empty string to disable
      backwards_tabkey = '<S-Tab>',
      -- shift content if tab out is not possible
      act_as_tab = true,
      -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
      act_as_shift_tab = false,
      -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
      default_tab = '<C-t>',
      -- reverse shift default action,
      default_shift_tab = '<C-d>',
      -- well ...
      enable_backwards = true,
      -- if the tabkey is used in a completion pum
      completion = true,
      tabouts = {
        {open = "'", close = "'"},
        {open = '"', close = '"'},
        {open = '`', close = '`'},
        {open = '(', close = ')'},
        {open = '[', close = ']'},
        {open = '{', close = '}'},
      },
      -- if the cursor is at the beginning of a filled element it will rather tab out than shift the content
      ignore_beginning = true,
      -- tabout will ignore these filetypes
      exclude = {},
    })
  end
}
