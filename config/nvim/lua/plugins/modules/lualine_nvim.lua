local icons = {
  -- full diagonal
  plain = {
    lock = "",
    network = "󰈀 ",
  },
  -- slash
  slash = {
    sect = {
      l = "",
      r = "",
    },
    comp = {
      l = "",
      r = "",
    },
  },
  -- chevron
  chevron = {
    sect = {
      l = "",
      r = "",
    },
    comp = {
      l = "",
      r = "",
    },
  },
  -- half circle
  curvy = {
    sect = "",
    comp = "",
  },
  -- a hex upon you
  flames = {
    sect = " ",
    comp = " ",
  },
  -- lego
  lego = {
    sect = " ",
    comp = " ",
  },
  -- pixelated blocks 2 (large) random fade (pixey)
  pixel_sm = {
    sect = {
      l = " ",
      r = " ",
    },
    comp = {
      l = " ",
      r = " ",
    },
  }
}

return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'linrongbin16/lsp-progress.nvim',
  },
  config = function()
    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = 'powerline_dark',
        section_separators = { left = icons.slash.sect.l, right = icons.slash.r },
        component_separators = { left = icons.slash.comp.l, right = icons.slash.comp.r },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    })
  end
}
