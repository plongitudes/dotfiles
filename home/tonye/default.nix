{ pkgs, config, ... }:
{
  imports = [ ./shell.nix ];

  home.username = "tonye";

  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/tonye" else "/home/tonye";

  # See https://nix-community.github.io/home-manager/options.xhtml#opt-home.stateVersion
  # Don't change casually — controls backwards-compat behavior for HM-generated files.
  home.stateVersion = "26.11";

  home.file = {
    # Shell stack. zsh itself is managed by ./shell.nix (programs.zsh); these
    # are the files it still sources.
    ".aliases.zsh".source = ../../aliases.zsh;
    ".p10k.zsh".source = ../../p10k.zsh;
    ".plongitudes.omp.json".source = ../../.plongitudes.omp.json;

    # Terminal multiplexer
    ".tmux.conf".source = ../../tmux.conf;

    # Git
    ".gitconfig".source = ../../gitconfig;
    ".gitignore_global".source = ../../gitignore_global;

    # nvim points at the LIVE repo (not the read-only store copy) so lazy.nvim
    # can write lazy-lock.json on :Lazy sync. Also means nvim config edits are
    # live without a `home-manager switch`. Reproducibility still holds: the
    # lockfile is committed to the repo, which is the source of truth on both
    # machines (assumes the repo is cloned to ~/.dotfiles, which it is).
    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/nvim";

    # ghostty stays an in-store copy (nothing writes back into its config dir)
    ".config/ghostty".source = ../../config/ghostty;
  };

  # Nix-editing toolchain. Sourced from Nix (not mason) so the exact same
  # binaries work on macOS now and on the NixOS VM later, with no nix-ld shim.
  home.packages = with pkgs; [
    # LSP — flake-aware, completes home-manager/NixOS options
    nixd
    # formatter — official RFC 166 style (what nixpkgs uses)
    nixfmt-rfc-style
    # linter — flags Nix anti-patterns
    statix
    # linter — finds dead/unused bindings
    deadnix
    # fuzzy CLI search over nixpkgs / HM / NixOS / darwin option docs.
    # Uses prebuilt downloaded indexes (not channels/NIX_PATH), so HM
    # options work on this flakes-only setup. Replaces manix, which is
    # stalled (last release 2024; HM-on-flakes fix merged but unreleased).
    nix-search-tv

    # tree-sitter CLI — nvim-treesitter's 'main' branch compiles parsers
    # locally and needs the CLI (>=0.26.1). Sourced from Nix so it's identical
    # on the Mac and the NixOS VM (native, no nix-ld). Homebrew's tree-sitter
    # ships only libtree-sitter (neovim's library dep), not the CLI.
    tree-sitter
  ];
}
