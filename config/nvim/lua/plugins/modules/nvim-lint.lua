return {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      python = { "ruff" },
      lua = { "selene" },
      swift = { "swiftlint" },
      ruby = { "rubocop" },

      -- zsh: `zsh -n --no-rcs` syntax check. Nothing else covers zsh --
      -- shellcheck refuses the dialect and bashls isn't enabled for it, so
      -- this is the only linting the repo's own zshrc/aliases.zsh files get.
      zsh = { "zsh" },
    }

    -- Auto-lint on these events
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
