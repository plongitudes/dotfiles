return {
  "luisiacc/gruvbox-baby",
  priority = 1000,
  init = function()
    -- Transparent bg so tmux window-style dimming reaches nvim panes;
    -- Ghostty's Gruvbox Dark bg (#282828) matches the theme, so the
    -- active pane looks unchanged.
    --
    -- Neovide has no terminal behind it: with no Normal guibg it paints
    -- the window black instead. Let the theme draw its own #282828 there.
    vim.g.gruvbox_baby_transparent_mode = vim.g.neovide and 0 or 1
  end,
}
