return {
  -- dir = vim.fn.expand("~/github/plongitudes/typescope.nvim"),
  -- name = "typescope.nvim",
  -- local development checkout; loads on python files so the K takeover in
  -- nvim-lspconfig.lua can require it, plus on :TypeScope anywhere
  "plongitudes/typescope.nvim",
  ft = "python",
  cmd = "TypeScope",
  -- <leader>c is the [C]ode Actions group; <leader>t belongs to Terminal
  keys = {
    { "<leader>ct", "<Plug>(TypeScopeToggle)", desc = "[T]ypeScope toggle" },
    { "<leader>cT", "<Plug>(TypeScopeOpen)", desc = "[T]ypeScope open / focus" },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("typescope").setup({
      ui = {
        align = "right", -- tree-layout only; kept for if/when ledger doesn't stick
        -- U6 ledger (2026-08-05): one line per param, detail block (≈ owner,
        -- example, origin, long defaults) follows the cursor once focused.
        -- "table" (U5 grid) and "tree" remain available.
        layout = "ledger",
        max_width = 0.6, -- ledger is content-narrow; uvicorn.run fits in ~80 cols
      },
      -- auto-generate example values on open via local ollama: heuristics
      -- show instantly, LLM values swap in when the request lands (E covers
      -- newly expanded leaves)
      example_mode = "llm",
      -- U6 typing surface: param-names block + wrapping active-param detail
      -- while inside call parens (blink's signature help is disabled in
      -- blink-cmp.lua in its favor). max_width sizes JUST this surface —
      -- same units as ui.max_width — and inherits ui.max_width when unset.
      insert_mode = {
        enabled = true,
        -- max_width = 0.5,
      },
      -- autostart: spawn `ollama serve` as a child of nvim when the port is
      -- dead — the server (and the model's ~2GB) dies with the editor
      -- keep_alive 5m: on 8GB the ~2GB model idling out beats warm E presses
      ollama = { enabled = true, autostart = true, keep_alive = "5m" },
    })
  end,
}
