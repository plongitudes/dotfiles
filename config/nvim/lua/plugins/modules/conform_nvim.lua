return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = {
    formatters_by_ft = {
      python = { "ruff_organize_imports", "ruff_format" }, -- ruff fix for isort, then format
      lua = { "stylua" }, -- Use stylua for Lua formatting
      swift = { "swiftformat" },
      nix = { "alejandra" },
      -- rubocop -a via its --server mode (a warm resident process). Slow
      -- enough to need its own timeout -- see `timeouts` below.
      ruby = { "rubocop" },
      -- beautysh is Bourne-family; it has no zsh mode, so zsh files are left
      -- unformatted rather than run through a formatter that doesn't know the
      -- syntax (zsh-specific constructs would get mangled)
      sh = { "beautysh" },
      bash = { "beautysh" },
    },
    format_on_save = function(bufnr)
      -- Check the global format_on_save setting
      if not vim.g.format_on_save then
        return nil
      end
      -- Per-filetype timeout: rubocop needs ~600ms even with a warm --server,
      -- so the flat 500ms silently timed it out and fell through to
      -- lsp_fallback (which is nothing, for ruby). Everything else is fast, and
      -- keeping their budget low means one slow formatter can't stall all saves.
      local timeouts = { ruby = 2000 }
      return {
        timeout_ms = timeouts[vim.bo[bufnr].filetype] or 500,
        lsp_fallback = true,
      }
    end,
  },
}
