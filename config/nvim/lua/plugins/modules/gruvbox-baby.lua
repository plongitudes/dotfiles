return {
  "luisiacc/gruvbox-baby",
  priority = 1000,
  init = function()
    -- Transparent bg so tmux window-style dimming reaches nvim panes;
    -- Ghostty's Gruvbox Dark bg (#282828) matches the theme, so the
    -- active pane looks unchanged.
    vim.g.gruvbox_baby_transparent_mode = 1
  end,
}
