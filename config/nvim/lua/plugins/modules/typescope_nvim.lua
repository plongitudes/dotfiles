return {
  -- local development checkout; loads on python files so the K takeover in
  -- nvim-lspconfig.lua can require it, plus on :TypeScope anywhere
  dir = vim.fn.expand("~/github/plongitudes/typescope.nvim"),
  name = "typescope.nvim",
  -- "plongitudes/typescope.nvim",
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
  -- lazy.nvim passes this to require("typescope").setup()
  opts = {
    -- the checkout's own build (scripts/build-oracle.sh --release), not the
    -- downloaded release binary
    oracle = {
      path = "~/github/plongitudes/typescope.nvim/oracle/target/release/typescope-oracle",
    },
    ui = {
      max_width = 0.6, -- ledger is content-narrow; uvicorn.run fits in ~80 cols
    },
    -- auto-generate example values on open via local ollama: heuristics
    -- show instantly, LLM values swap in when the request lands (E covers
    -- newly expanded leaves)
    example_mode = "llm",
    -- U6 typing surface: param-names block + wrapping active-param detail
    -- while inside call parens (blink's signature help is disabled in
    -- blink-cmp.lua in its favor)
    insert_mode = { enabled = true },
    -- autostart: spawn `ollama serve` as a child of nvim when the port is
    -- dead — the server (and the model's ~2GB) dies with the editor
    ollama = { enabled = true, autostart = true },
  },
}
