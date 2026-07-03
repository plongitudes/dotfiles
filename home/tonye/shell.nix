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

    # oh-my-zsh (still sourced inside the readFile'd content) runs compinit.
    enableCompletion = false;

    # zsh-autosuggestions via the native module — sourced at mkOrder 700, i.e.
    # BEFORE fast-syntax-highlighting below, which is the ordering that keeps
    # suggestions dimmed. Grey matches nvim's gruvbox comment colour.
    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
      highlight = "fg=#665c54";
    };

    # Keep fast-syntax-highlighting (not home-manager's z-sy-h); it is sourced
    # from Nix DEAD LAST via initContent mkOrder 1500 below, so the native
    # syntaxHighlighting module (which would be z-sy-h) stays off.
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

    # Your zshrc (bespoke shell) at the default order, then fast-syntax-
    # highlighting sourced last so it runs after autosuggestions and every
    # custom widget. readFile keeps the zshrc as the source of truth and
    # sidesteps Nix escaping of the shell's ${...}/$(...) syntax.
    initContent = lib.mkMerge [
      (lib.mkOrder 1000 (builtins.readFile ../../zshrc))
      (lib.mkOrder 1500 "source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh")
    ];
  };
}
