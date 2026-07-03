# ─────────────────────────────────────────────────────────────────────────────
# zsh — home-manager native module (M5 port).
# Stage A: home-manager owns ~/.zshrc. The bespoke shell (functions, dynamic
# env, fzf, prompt) is pulled in verbatim from ../../zshrc via readFile, so the
# hand-organized file — ASCII banners and all — stays the source of that content.
# Later stages peel history / oh-my-zsh / mise / fzf into native options.
# ─────────────────────────────────────────────────────────────────────────────
{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;

    # oh-my-zsh (still sourced inside the readFile'd content) runs compinit and
    # provides autosuggestions + syntax highlighting via its plugins, so keep
    # home-manager's own versions off for now to avoid double-loading.
    enableCompletion = false;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;

    # ~/.zprofile (login shells). brew shellenv + the Obsidian CLI path are
    # macOS-only, so guard them — the NixOS VM has neither. (Migrated out of the
    # pre-existing hand-written ~/.zprofile that programs.zsh now owns.)
    profileExtra = lib.optionalString pkgs.stdenv.isDarwin ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
    '';

    # ~/.zshenv (all shells). Keep ~/.local/bin on PATH everywhere (uv/pipx
    # shims), not just interactive shells. (Migrated out of the pre-existing
    # ~/.zshenv that programs.zsh now owns.)
    envExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';

    # Current zshrc, verbatim. readFile keeps the file as the source of truth
    # and sidesteps Nix escaping of the shell's ${...}/$(...) syntax.
    initContent = builtins.readFile ../../zshrc;
  };
}
