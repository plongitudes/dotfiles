return {
  "benlubas/molten-nvim",
  version = "^1.0.0",
  build = ":UpdateRemotePlugins",
  ft = { "python" },
  dependencies = {
    "3rd/image.nvim",
  },
  init = function()
    -- Output configuration
    vim.g.molten_auto_open_output = true
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_virt_text_output = true
    vim.g.molten_virt_lines_off_by_1 = true

    -- Image rendering via image.nvim
    vim.g.molten_image_provider = "image.nvim"

    -- Wrap long output lines
    vim.g.molten_wrap_output = true
  end,
  config = function()
    -- The only home-specific piece here (the MoltenSetupPyscript Home Assistant
    -- command) lives in a private overlay and loads only if it's cloned to
    -- ~/.undisclosed. On a machine without it (e.g. work), this is a no-op and
    -- the generic molten setup above still applies.
    local ext = vim.fn.expand("~/.undisclosed/nvim/molten_pyscript.lua")
    if vim.fn.filereadable(ext) == 1 then
      dofile(ext)
    end
  end,
}
