{ pkgs, ... }:
{
  home.username = "tonye";

  home.homeDirectory =
    if pkgs.stdenv.isDarwin then "/Users/tonye" else "/home/tonye";

  # See https://nix-community.github.io/home-manager/options.xhtml#opt-home.stateVersion
  # Don't change casually — controls backwards-compat behavior for HM-generated files.
  home.stateVersion = "26.11";

  home.file = {
    # Shell stack (zshrc and the files it sources)
    ".zshrc".source = ../../zshrc;
    ".aliases.zsh".source = ../../aliases.zsh;
    ".p10k.zsh".source = ../../p10k.zsh;
    ".plongitudes.omp.json".source = ../../.plongitudes.omp.json;

    # Terminal multiplexer
    ".tmux.conf".source = ../../tmux.conf;

    # Git
    ".gitconfig".source = ../../gitconfig;
    ".gitignore_global".source = ../../gitignore_global;

    # Editor + terminal-emulator configs (directories, recursively linked)
    ".config/nvim".source = ../../config/nvim;
    ".config/ghostty".source = ../../config/ghostty;
  };

  # Nix-editing toolchain. Sourced from Nix (not mason) so the exact same
  # binaries work on macOS now and on the NixOS VM later, with no nix-ld shim.
  home.packages = with pkgs; [
    nixd              # LSP — flake-aware, completes home-manager/NixOS options
    nixfmt-rfc-style  # formatter — official RFC 166 style (what nixpkgs uses)
    statix            # linter — flags Nix anti-patterns
    deadnix           # linter — finds dead/unused bindings
    manix             # CLI search over nixpkgs / HM / NixOS option docs
  ];
}

