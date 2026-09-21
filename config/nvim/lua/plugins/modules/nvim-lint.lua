-- python is deliberately absent: `ruff server` (nvim-lspconfig.lua) already
-- publishes ruff diagnostics; running the CLI here too would double every
-- warning.
local linters_by_ft = {
  lua = { "selene" },
  swift = { "swiftlint" },
  ruby = { "rubocop" },

  -- zsh: `zsh -n --no-rcs` syntax check. Nothing else covers zsh --
  -- shellcheck refuses the dialect and bashls isn't enabled for it, so
  -- this is the only linting the repo's own zshrc/aliases.zsh files get.
  zsh = { "zsh" },
}

return {
  "mfussenegger/nvim-lint",
  -- lazy.nvim defaults to lazy = true, so the plugin needs a trigger or it
  -- never loads. `ft` rather than BufReadPost: lazy's BufReadPost handler
  -- runs before filetype detection for the same event, so a plugin loaded
  -- there sees an empty filetype on its first lint.
  ft = vim.tbl_keys(linters_by_ft),
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = linters_by_ft

    -- Auto-lint on these events
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })

    -- The buffer that triggered the load has already passed BufReadPost.
    lint.try_lint()
  end,
}
