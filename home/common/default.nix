{ pkgs, config, ... }:
let
  # Same TOML generator programs.mise uses internally for its own config, so
  # ~/mise.toml (below) round-trips through Nix the same way.
  tomlFormat = pkgs.formats.toml { };
in
{
  imports = [ ./shell.nix ];

  # Derived from $USER at build time (this is why every build needs `--impure`),
  # so no username is committed to this public repo. homeDirectory follows from it.
  home.username = builtins.getEnv "USER";

  home.homeDirectory =
    if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";

  # See https://nix-community.github.io/home-manager/options.xhtml#opt-home.stateVersion
  # Don't change casually — controls backwards-compat behavior for HM-generated files.
  home.stateVersion = "26.11";

  home.file = {
    # Shell stack. zsh itself is managed by ./shell.nix (programs.zsh); these
    # are the files it still sources.
    # aliases.zsh is mostly shell functions + conditionals (not just aliases), so
    # it stays a sourced file rather than programs.zsh.shellAliases. Live symlink
    # (not an in-store copy) so `sa`/`va` (edit + re-source ~/.dotfiles/aliases.zsh)
    # and fresh shells resolve to the same file — alias edits need no switch.
    ".aliases.zsh".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/aliases.zsh";
    # omp-plongitudes.json is provided via programs.oh-my-posh.configFile (shell.nix)

    # tmux config is owned by programs.tmux (shell.nix) — it writes the generated
    # config (settings + plugin run-shell lines) to ~/.config/tmux.

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

    # Neovide (GUI) reads this. Point the prebuilt Neovide.app (a brew cask) at
    # the Nix nvim — a Finder-launched app has no ~/.nix-profile on PATH, so it
    # can't discover nvim on its own. Nix-managed in-store (you'll never hand-edit
    # it). Mac-only in practice; harmless no-op on the headless VM. Neovide stays
    # a cask because nixpkgs neovide builds no darwin .app bundle (nixpkgs#301984)
    # and is 2.8 GiB unpacked — not worth it for a storage-tight machine.
    ".config/neovide/config.toml".text = ''
      neovim-bin = "${pkgs.neovim}/bin/nvim"
    '';

    # ghostty stays an in-store copy (nothing writes back into its config dir)
    ".config/ghostty".source = ../../config/ghostty;

    # mise's tool pins for $HOME (see programs.mise in shell.nix for why these
    # live in an ordinary project mise.toml here rather than globalConfig):
    # mise walks up from cwd looking for mise.toml/.tool-versions, so this only
    # activates in $HOME and directories below it — anywhere else on disk
    # (e.g. /opt/marcom-cgs projects) falls through to whatever's on PATH.
    "mise.toml".source = tomlFormat.generate "home-mise-toml" {
      tools = {
        go = "latest";
        node = "latest";
        pipx = "latest";
        pnpm = "latest";
        python = "3.11.9";
        rust = "latest";
        uv = "latest";
      };
    };
  };

  # Nix-editing toolchain. Sourced from Nix (not mason) so the exact same
  # binaries work on macOS now and on the NixOS VM later, with no nix-ld shim.
  home.packages = with pkgs; [
    # LSP — flake-aware, completes home-manager/NixOS options
    nixd
    # formatter — nixfmt IS the official RFC 166 style now; the old
    # nixfmt-rfc-style name is a deprecated alias for this same derivation.
    nixfmt
    # linter — flags Nix anti-patterns
    statix
    # linter — finds dead/unused bindings
    deadnix
    # fuzzy CLI search over nixpkgs / HM / NixOS / darwin option docs.
    # Uses prebuilt downloaded indexes (not channels/NIX_PATH), so HM
    # options work on this flakes-only setup. Preferred over manix, which is
    # stalled (last release 2024; HM-on-flakes fix merged but unreleased).
    nix-search-tv

    # tree-sitter CLI — nvim-treesitter's 'main' branch compiles parsers
    # locally and needs the CLI (>=0.26.1). Sourced from Nix so it's identical
    # on the Mac and the NixOS VM (native, no nix-ld). Homebrew's tree-sitter
    # ships only libtree-sitter (neovim's library dep), not the CLI.
    tree-sitter

    # nix-output-monitor (nom) — live build/download progress tree. `switch`
    # (aliases.zsh) builds through `nom build` before activating, so a rebuild
    # shows what's fetching/compiling instead of going silent. See nix-kho.
    nix-output-monitor

    # nvd — diffs two generations' closures and prints exactly which packages
    # changed version. `nixup` (aliases.zsh) runs it after a flake update so an
    # update produces a readable changelog instead of a silent version bump.
    nvd

    # ── De-brewed CLI tooling (nix-9zy) ──────────────────────────────────────
    # Dev CLIs sourced from Nix so the exact same binaries exist on the Mac and
    # the NixOS VM. Pragmatic split: only small/fast-building tools live here;
    # heavy media stacks (ffmpeg, imagemagick, …) stay in Homebrew on the Mac
    # (prebuilt bottles, huge closures, storage-limited machine). fzf, oh-my-posh
    # and mise already come from Nix via programs.*; they aren't repeated here —
    # uninstalling their shadowing brew copies is what makes them win on PATH
    # (~/.nix-profile/bin sits after /opt/homebrew/bin).
    #
    # Load-bearing in the shell config (invoked across zshrc + aliases.zsh):
    fd
    eza
    bat
    ripgrep # provides `rg`
    tree
    fortune # fortsplat() (zshrc) + `fort` alias — the fzf border label
    lolcat # colours fortsplat's output; both run on every prompt via _dynamic_fzf
    # General dev CLIs — not in the zsh hot path, but wanted identical fleet-wide:
    gh
    ncdu
    btop # process monitor (picked over htop — one is enough)
    tig # git log/blame browser
    lazygit # full git TUI
    # jq: sourced from Nix like its siblings. macOS ships /usr/bin/jq (1.7.1,
    # SIP-locked) ahead of ~/.nix-profile on PATH, so it shadows this build for
    # bare `jq`. Fix is a Darwin interactive alias in aliases.zsh pointing at the
    # Nix jq (1.8.x); scripts that need it call ~/.nix-profile/bin/jq explicitly
    # (like writing /bin/ls when you mean exactly that binary). mise was tried
    # and reverted — its PATH win is ALSO interactive-only, so it just relocated
    # the problem without solving it. See nix-9zy.
    jq

    # neovim: from Nix so the VM gets a reproducible editor, and the Mac has a
    # pinned nvim that Neovide targets (via the config above). NOTE both nvims
    # coexist on the Mac: brew's neovim ALSO stays because the neovide-app cask
    # hard-depends on it, and brew (PATH pos 14) wins bare `nvim` in the terminal
    # over this one (~/.nix-profile, pos 32). We keep both rather than fight the
    # cask's dependency — revisit if nixpkgs neovide gains a darwin .app bundle
    # (nixpkgs#301984). Minimal per nix-b02: binary only — lazy.nvim owns plugins
    # from the live ~/.config/nvim symlink; NOT programs.neovim, which would fight
    # that symlink by managing init.lua.
    neovim
  ];
}
