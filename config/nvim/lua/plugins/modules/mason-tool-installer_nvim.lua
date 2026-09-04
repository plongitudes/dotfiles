return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "mason-org/mason.nvim",
  },
  opts = {
    ensure_installed = {
      -- Python
      "basedpyright", -- LSP
      "ruff", -- LSP + formatter + linter

      -- Lua
      "lua-language-server", -- LSP
      "stylua", -- formatter
      "selene", -- linter

      -- Shell (sh/bash only; zsh is covered by nvim-lint's `zsh -n` check,
      -- since neither bash-language-server nor shellcheck parse zsh)
      "bash-language-server", -- LSP (also runs shellcheck internally)
      "beautysh", -- formatter
      "shellcheck", -- linter, invoked by bash-language-server

      -- Ruby
      "rubocop", -- formatter + linter

      -- Nix (moved here from the flake's home.packages)
      "nil", -- LSP
      "alejandra", -- formatter

      -- Swift (sourcekit-lsp is NOT here -- it ships with the Xcode CLI tools)
      "swiftformat", -- formatter
      "swiftlint", -- linter

      -- DAP (debuggers)
      "debugpy", -- Python debugger
      "local-lua-debugger-vscode", -- Lua debugger
    },
    auto_update = false,
    run_on_start = true,
  },
}
