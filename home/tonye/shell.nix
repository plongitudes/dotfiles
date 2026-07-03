# ─────────────────────────────────────────────────────────────────────────────
# zsh — home-manager native module (M5 port).
# Stage A: home-manager owns ~/.zshrc. The bespoke shell (functions, dynamic
# env, fzf, prompt) is pulled in verbatim from ../../zshrc via readFile, so the
# hand-organized file — ASCII banners and all — stays the source of that content.
# Later stages peel history / oh-my-zsh / mise / fzf into native options.
# ─────────────────────────────────────────────────────────────────────────────
{ pkgs, lib, ... }:
let
  # nixpkgs builds fzf-tab's native module as `fzftab.so`, but macOS zsh loads
  # dynamic modules with the `.bundle` extension — so zmodload fails and the
  # plugin prompts to rebuild on every shell. The `.so` is already a valid arm64
  # Mach-O bundle (just misnamed), so add a `.bundle` symlink beside it on Darwin.
  # (Works around a nixpkgs-darwin packaging quirk; upstream fix would drop this.)
  fzf-tab = pkgs.zsh-fzf-tab.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + lib.optionalString pkgs.stdenv.isDarwin ''
      ln -s fzftab.so "$out/share/fzf-tab/modules/Src/aloxaf/fzftab.bundle"
    '';
  });
in
{
  # zsh-completions ships completion functions into the profile's
  # share/zsh/site-functions, which home-manager adds to fpath before compinit.
  home.packages = [ pkgs.zsh-completions ];

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

    # oh-my-zsh, Nix-managed (retires the manual ~/.oh-my-zsh clone). HM sources
    # it at mkOrder 800. Only BUILT-IN OMZ plugins live here; the widget-wrapping
    # external ones (autosuggestions, fzf-tab, fast-syntax-highlighting) are
    # handled natively with explicit ordering above/below.
    oh-my-zsh = {
      enable = true;
      theme = ""; # prompt is oh-my-posh (migrated in a later step)
      plugins = [ "git" "python" "pylint" "virtualenv" ]; # mise → programs.mise (avoids double-activation)
      # Settings migrated from the old zshrc oh-my-zsh block. (The fancy
      # COMPLETION_WAITING_DOTS icon was already overridden by a later "true".)
      extraConfig = ''
        HYPHEN_INSENSITIVE="true"
        COMPLETION_WAITING_DOTS="true"
        HIST_STAMPS="yyyy-mm-dd"
      '';
    };

    # fzf-tab as a native plugin (sourced at mkOrder 900 — after oh-my-zsh's
    # compinit, before fast-syntax-highlighting).
    plugins = [
      {
        name = "fzf-tab";
        src = fzf-tab; # patched: adds the .bundle symlink so the native module loads on macOS
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

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
      # Completion/function search paths, added BEFORE oh-my-zsh runs compinit
      # (mkOrder 800). zsh-completions comes from the Nix profile (home.packages)
      # so it's handled automatically; these are the remaining extras.
      (lib.mkOrder 550 ''
        fpath+="''${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions"
        fpath+="$HOME/.dotfiles/zsh_functions"
      '')
      (lib.mkOrder 1000 (builtins.readFile ../../zshrc))
      (lib.mkOrder 1500 "source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh")
    ];
  };

  # mise — Nix-managed. globalConfig writes ~/.config/mise/config.toml (finally
  # in-repo/reproducible); the zsh integration activates via the Nix mise binary,
  # retiring the hardcoded /opt/homebrew/bin/mise eval. mise's _mise completion
  # ships in the Nix profile, so dropping the OMZ 'mise' plugin loses nothing.
  programs.mise = {
    enable = true;
    globalConfig = {
      tools = {
        go = "latest";
        node = "latest";
        pipx = "latest";
        pnpm = "latest";
        python = "3.11.8";
        rust = "latest";
        uv = "latest";
      };
      settings.experimental = true;
    };
  };
}
