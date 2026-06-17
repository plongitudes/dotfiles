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
}

