# ─────────────────────────────────────────────────────────────────────────────
# zsh — home-manager native module (M5 port).
# Stage A: home-manager owns ~/.zshrc. The bespoke shell (functions, dynamic
# env, fzf, prompt) is pulled in verbatim from ../../zshrc via readFile, so the
# hand-organized file — ASCII banners and all — stays the source of that content.
# Later stages peel history / oh-my-zsh / mise / fzf into native options.
# ─────────────────────────────────────────────────────────────────────────────
{
  pkgs,
  lib,
  config,
  ...
}:
let
  # nixpkgs builds fzf-tab's native module as `fzftab.so`, but macOS zsh loads
  # dynamic modules with the `.bundle` extension — so zmodload fails and the
  # plugin prompts to rebuild on every shell. The `.so` is already a valid arm64
  # Mach-O bundle (just misnamed), so add a `.bundle` symlink beside it on Darwin.
  # (Works around a nixpkgs-darwin packaging quirk; upstream fix would drop this.)
  fzf-tab = pkgs.zsh-fzf-tab.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + lib.optionalString pkgs.stdenv.isDarwin ''
        ln -s fzftab.so "$out/share/fzf-tab/modules/Src/aloxaf/fzftab.bundle"
      '';
  });

  # Restore the saved tmux session ONCE per server, when the first session is
  # created. continuum's built-in boot-restore runs resurrect from a detached
  # run-shell (no attached client) and fails every operation with "no current
  # client" on the pinned resurrect — so we disable it and fire restore from the
  # session-created hook, which runs WITH a client (unlike client-attached,
  # which doesn't fire for the session-creating client at all). The
  # @restored_once guard makes it a one-shot: it won't re-fire when resurrect
  # itself creates the restored sessions, nor on later `tmux new`. See nix-ojb.
  tmuxRestoreOnce = pkgs.writeShellScript "tmux-restore-once" ''
    [ "$(tmux show-option -gqv @restored_once)" = 1 ] && exit 0
    tmux set-option -g @restored_once 1
    exec ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/restore.sh
  '';

  # Optional local files embedded verbatim at the tail when present; everything
  # else in ~/.undisclosed is ignored here. Read impurely (build is --impure).
  undisclosed = "${config.home.homeDirectory}/.undisclosed";
  zprofileTail = "${undisclosed}/zprofile.tail";
  zshrcTail = "${undisclosed}/zshrc.tail";
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
      strategy = [
        "history"
        "completion"
      ];
      highlight = "fg=#665c54";
    };

    # Keep fast-syntax-highlighting (not home-manager's z-sy-h); it is sourced
    # from Nix DEAD LAST via initContent mkOrder 1500 below, so the native
    # syntaxHighlighting module (which would be z-sy-h) stays off.
    syntaxHighlighting.enable = false;

    # oh-my-zsh, Nix-managed. HM sources it at mkOrder 800. Only BUILT-IN OMZ
    # plugins live here; the widget-wrapping external ones (autosuggestions,
    # fzf-tab, fast-syntax-highlighting) are handled natively with explicit
    # ordering above/below.
    oh-my-zsh = {
      enable = true;
      theme = ""; # prompt is oh-my-posh (see programs.oh-my-posh below)
      plugins = [
        "git"
        "python"
        "pylint"
        "virtualenv"
      ]; # no 'mise' plugin — activation is via programs.mise (avoids double-activation)
      # COMPLETION_WAITING_DOTS is intentionally omitted: it makes OMZ wrap Tab
      # with expand-or-complete-with-dots, which conflicts with fzf-tab (double-tab
      # on an empty buffer), and the dots are only cosmetic.
      extraConfig = ''
        HYPHEN_INSENSITIVE="true"
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
    # macOS-only, so guard them — the NixOS VM has neither.
    profileExtra =
      lib.optionalString pkgs.stdenv.isDarwin ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
      ''
      + lib.optionalString (builtins.pathExists zprofileTail) (builtins.readFile zprofileTail);

    # ~/.zshenv (all shells). Keep ~/.local/bin on PATH everywhere (uv/pipx
    # shims), not just interactive shells.
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
      (lib.mkOrder 2000 (
        lib.optionalString (builtins.pathExists zshrcTail) (builtins.readFile zshrcTail)
      ))
    ];
  };

  # mise — Nix-managed. globalConfig writes ~/.config/mise/config.toml (in-repo,
  # reproducible); tools and settings live there. zsh integration activates via
  # the Nix mise binary, and _mise completion ships in the Nix profile.
  #
  # Tool versions are declared in ~/mise.toml instead of here (see
  # home.file."mise.toml" in default.nix): mise's TRUE global config
  # (~/.config/mise/config.toml) applies everywhere on disk regardless of cwd,
  # but ~/mise.toml is just an ordinary project config that mise finds by
  # walking up from cwd — so it only takes effect in $HOME and directories
  # below it, same as any other project mise.toml. Individual repos under
  # $HOME can still override/disable a tool (e.g. `python = "system"`) to
  # defer to something else on PATH (e.g. /opt/marcom-cgs/bin).
  programs.mise = {
    enable = true;
    globalConfig = {
      tools = { };
      settings.experimental = true;
    };
  };

  # oh-my-posh — Nix-managed prompt. configFile points at your theme as-is (no
  # JSON→Nix round-trip); the zsh integration inits via the Nix binary. Edit the
  # theme in omp-plongitudes.json (needs a switch to take effect).
  programs.oh-my-posh = {
    enable = true;
    configFile = ../../omp-plongitudes.json;
  };

  # fzf — Nix binary + zsh keybindings/completion via programs.fzf. No
  # command/opts set here, so no FZF_* env vars are exported — your _dynamic_fzf
  # and the CTRL_T/CTRL_R/ALT_C opts in the zshrc stay the sole source.
  programs.fzf.enable = true;

  # tmux — Nix-managed (nix-ojb). Binary + plugins from nixpkgs, pinned by
  # flake.lock — no Homebrew tmux, no TPM. Config is authoritative in
  # ../../tmux.conf (read verbatim); HM writes the generated result to
  # ~/.config/tmux/tmux.conf.
  #
  # ORDERING GOTCHA: home-manager emits the plugin `run-shell` lines BEFORE
  # `extraConfig` — the reverse of TPM (whose `run tpm` sat at the bottom). So
  # any LOAD-TIME plugin var (one a plugin reads as it initialises) must be set
  # via that plugin's per-plugin `extraConfig` below, which HM places right
  # before its run-shell. Putting them in ../../tmux.conf is too late: continuum
  # would boot with @continuum-restore still off (no auto-restore) and gruvbox
  # would theme before @tmux-gruvbox is set. Runtime-only vars (e.g.
  # @yank_action, read when you copy) can stay in tmux.conf.
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible # sane defaults (only sets what you haven't)
      yank # copy selection to the system clipboard
      net-speed # up/down speeds in the status bar
      {
        plugin = gruvbox; # egel/tmux-gruvbox theme (pinned v2.0.1)
        extraConfig = "set -g @tmux-gruvbox 'dark'";
      }
      {
        plugin = resurrect; # save/restore sessions
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = continuum; # auto-SAVE only (loads after resurrect)
        # Boot-restore OFF: continuum's headless restore fails "no current
        # client" on the pinned resurrect. Restore is driven by the
        # client-attached hook below instead (runs with a real client). continuum
        # still auto-saves every ~15 min, so there's always a state to restore.
        extraConfig = ''
          set -g @continuum-restore 'off'
          set-hook -g session-created "run-shell '${tmuxRestoreOnce}'"
        '';
      }
    ];
    extraConfig = builtins.readFile ../../tmux.conf;
  };
}
