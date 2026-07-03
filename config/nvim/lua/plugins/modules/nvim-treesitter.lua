return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "abecodes/tabout.nvim",
  },
  config = function()
    -- main branch has no module system: install parsers explicitly, then
    -- enable highlighting per-buffer (highlight/indent/fold live in core now).
    require("nvim-treesitter").install({
      "bash",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "nix",
      "python",
      "query",
      "regex",
      "ruby",
      "sql",
      "vim",
      "vimdoc",
    })

    -- Replaces the old `highlight = { enable = true }` module. Start treesitter
    -- highlighting on any filetype that has a parser; the size guard mirrors the
    -- previous disable-by-filesize behavior. Indentation is intentionally left to
    -- Neovim's runtime indent scripts (nvim-yati is dead on main) and folding is
    -- left unconfigured, matching the pre-migration behavior.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local max_filesize = 1000 * 1024 -- 1000 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
        if ok and stats and stats.size > max_filesize then
          return
        end
        pcall(vim.treesitter.start) -- no-ops if this filetype has no parser
      end,
    })
  end,
}
