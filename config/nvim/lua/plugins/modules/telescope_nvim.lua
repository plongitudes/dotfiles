return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.2',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-fzf-native.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  -- You dont need to set any of these options. These are the default ones. Only
  -- the loading is important
  config = function()
    require('telescope').setup({
      extensions = {
        fzf = {
          -- false will only do exact matching
          fuzzy = true,
          -- override the generic sorter
          override_generic_sorter = true,
          -- override the file sorter
          override_file_sorter = true,
          -- or 'ignore_case' or 'respect_case', the default case_mode is 'smart_case'
          case_mode = 'smart_case',
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown {
            -- even more opts
          }

          -- pseudo code / specification for writing custom displays, like the one
          -- for 'codeactions'
          -- specific_opts = {
          --   [kind] = {
          --     make_indexed = function(items) -> indexed_items, width,
          --     make_displayer = function(widths) -> displayer
          --     make_display = function(displayer) -> function(e)
          --     make_ordinal = function(e) -> string
          --   },
          --   -- for example to disable the custom builtin 'codeactions' display
          --      do the following
          --   codeactions = false,
          -- }
        },
      },
    })
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('ui-select')
  end,
}

