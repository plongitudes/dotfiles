{ pkgs, ... }:
{
  home.username = "tonye";

  home.homeDirectory =
    if pkgs.stdenv.isDarwin then "/Users/tonye" else "/home/tonye";

  # See https://nix-community.github.io/home-manager/options.xhtml#opt-home.stateVersion
  # Don't change casually — controls backwards-compat behavior for HM-generated files.
  home.stateVersion = "26.11";

  # Real configuration starts in M3:
  #   - home.file references to existing dotfiles (zshrc, p10k.zsh, tmux.conf, ...)
  # Then in M5:
  #   - programs.* native modules replacing the symlinks one config at a time
}
