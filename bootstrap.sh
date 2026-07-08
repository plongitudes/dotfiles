#!/usr/bin/env bash
#
# bootstrap.sh — fresh-machine bootstrap for Nix/home-manager dotfiles.
#
# The heavy lifting is DECLARATIVE now. This script's whole job is to get Nix
# and the repo onto a new box, then hand off to `home-manager switch` — which
# writes every symlink the old bootstrap used to hand-wire, plus zsh, mise,
# oh-my-posh, and the CLI toolchain, all from the flake. Homebrew is a
# supporting actor (macOS only) for the few heavy / GUI things HM deliberately
# doesn't manage, and it runs LAST because Nix and brew don't depend on each
# other — so the reproducible core is fully working before any imperative
# brew step runs.
#
# NOT for a Linux/NixOS host: those provision via nixos-rebuild (see the
# linux-* host config under hosts/, reserved for M6+), not this script.

set -euo pipefail

REPO_URL="https://github.com/plongitudes/dotfiles.git"
DOTFILES="${HOME}/.dotfiles"
PROFILE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles"
PROFILE_FILE="$PROFILE_DIR/profile"   # which flake profile this machine builds
# HM_CONFIG is chosen in phase 2.5 and persisted to $PROFILE_FILE — no machine
# identity is hardcoded here (this bootstrap is public).

# ── messaging helpers ─────────────────────────────────────────────────────
say()  { printf '\n...---===### [[[ %s ]]]\n' "$1"; }
step() { printf '      %s\n' "$1"; }
have() { command -v "$1" >/dev/null 2>&1; }

# ── args ──────────────────────────────────────────────────────────────────
# The script is re-runnable: every phase below is guarded to skip work already
# done, so re-running is safe (e.g. to install mise later, or pick up new casks).
# --profile <name> overrides/updates the saved profile on a re-run; without it a
# saved profile is reused and a fresh box prompts.
PROFILE_ARG=""
usage() { printf 'usage: bootstrap.sh [--profile <name>]\n'; }
while [ $# -gt 0 ]; do
    case "$1" in
        --profile)
            [ $# -ge 2 ] || { echo "bootstrap.sh: --profile needs a value" >&2; exit 1; }
            PROFILE_ARG="$2"; shift 2 ;;
        --profile=*) PROFILE_ARG="${1#*=}"; shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "bootstrap.sh: unknown argument: $1" >&2; usage >&2; exit 1 ;;
    esac
done

os="$(uname)"

# ── phase 0: platform prereqs ─────────────────────────────────────────────
# git + curl come from Xcode Command Line Tools; a fresh Mac has neither, and
# both the clone and the Homebrew installer need them. This pops a GUI prompt,
# and the install runs async — so we bail and ask for a re-run once it's done.
if [ "$os" = "Darwin" ]; then
    if ! xcode-select -p >/dev/null 2>&1; then
        say "Installing Xcode Command Line Tools"
        step "Accept the GUI prompt, let it finish, then re-run this script."
        xcode-select --install || true
        exit 1
    fi
fi

# ── phase 1: install Nix (flakes-enabled) ─────────────────────────────────
# Determinate Systems installer: flakes + nix-command on by default, manages
# the /nix APFS volume, and survives macOS upgrades (the classic pain point
# the official installer leaves you to fix by hand).
if ! have nix; then
    say "Installing Nix (Determinate Systems installer)"
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
        | sh -s -- install --no-confirm
    # bring nix onto PATH for the rest of THIS script run
    if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        # shellcheck disable=SC1091
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi
else
    say "Nix already installed — skipping"
fi

# ── phase 2: clone the dotfiles repo ──────────────────────────────────────
if [ ! -d "$DOTFILES/.git" ]; then
    say "Cloning dotfiles → $DOTFILES"
    git clone "$REPO_URL" "$DOTFILES"
else
    say "Dotfiles already present at $DOTFILES — skipping clone"
fi

# ── phase 2.5: select this machine's profile ──────────────────────────────
# switch()/nixie() (aliases.zsh) build the flake profile named in $PROFILE_FILE,
# NOT the hostname — so no machine identity lives in the public repo. Persist the
# choice once here; re-runs reuse it.
if [ -n "$PROFILE_ARG" ]; then
    HM_CONFIG="$PROFILE_ARG"
    mkdir -p "$PROFILE_DIR"
    printf '%s\n' "$HM_CONFIG" > "$PROFILE_FILE"
    say "Profile set to $HM_CONFIG (from --profile)"
elif [ -f "$PROFILE_FILE" ]; then
    HM_CONFIG="$(cat "$PROFILE_FILE")"
    say "Using existing profile: $HM_CONFIG (pass --profile <name> to change)"
else
    say "Select this machine's profile"
    step "darwin-personal — personal Mac"
    step "darwin-work       — work Mac"
    printf '      profile [darwin-personal]: '
    read -r HM_CONFIG
    HM_CONFIG="${HM_CONFIG:-darwin-personal}"
    mkdir -p "$PROFILE_DIR"
    printf '%s\n' "$HM_CONFIG" > "$PROFILE_FILE"
    step "wrote $PROFILE_FILE"
fi

# ── phase 2.6 (optional): private overlay repo ────────────────────────────
# Home machines keep home-specific tooling in a SEPARATE private repo that the
# public config sources only if present, at ~/.undisclosed (the path zshrc +
# the nvim molten loader expect). The URL is intentionally NOT hardcoded —
# this bootstrap is public. Paste it to clone, or leave blank (e.g. on a work
# box).
UNDISCLOSED="${HOME}/.undisclosed"
if [ ! -d "$UNDISCLOSED/.git" ]; then
    printf '\n      private overlay repo URL (blank to skip): '
    read -r OVERLAY_URL
    if [ -n "${OVERLAY_URL:-}" ]; then
        say "Cloning private overlay → $UNDISCLOSED"
        git clone "$OVERLAY_URL" "$UNDISCLOSED"
    else
        step "skipped — no private overlay"
    fi
fi

# ── phase 3: THE CORE — home-manager switch ───────────────────────────────
# The important step. `nix run home-manager/master` fetches HM just to run
# the first switch (afterward the `switch` alias in aliases.zsh takes over,
# using the HM pinned in flake.lock). `-b backup` renames any pre-existing
# colliding file to <name>.backup instead of aborting, so this is safe on a
# box that isn't perfectly fresh. --impure because the flake derives
# home.username from $USER (getEnv), so no username is committed to the repo.
if [ "$os" = "Darwin" ]; then
    say "Running home-manager switch (#$HM_CONFIG) — this does the real work"
    nix run home-manager/master -- switch --impure -b backup --flake "$DOTFILES#$HM_CONFIG"
elif [ "$os" = "Linux" ]; then
    say "Linux host detected"
    step "This repo provisions Linux via nixos-rebuild, not home-manager"
    step "standalone. See the linux-* NixOS host config under hosts/ (M6+). Stopping here."
    exit 0
fi

# ── phase 3.5 (optional): install mise-pinned dev tools ───────────────────
# home-manager installs mise + writes ~/.config/mise/config.toml, but the pinned
# runtimes (go/node/python/rust/…) aren't fetched until `mise install` runs — so
# a fresh shell warns about missing tools until then. This can be slow/large, so
# ask first; skip and run `mise install` yourself later if you'd rather. (Called
# by full path: the switch just created ~/.nix-profile but this shell's PATH
# predates it.)
mise_bin="${HOME}/.nix-profile/bin/mise"
if [ -x "$mise_bin" ]; then
    printf '\n      install mise-pinned dev tools now (go, node, python, rust, …)? [y/N]: '
    read -r ans
    case "$ans" in
        [yY]*) say "Installing mise-pinned tools"; "$mise_bin" install ;;
        *)     step "skipped — run 'mise install' later to fetch them" ;;
    esac
fi

# ── phase 4 (macOS only, LAST): Homebrew ──────────────────────────────────
# Only the pragmatic-split set lives here: heavy media stacks and GUI apps that
# would be huge Nix closures on a storage-tight Mac, the neovide-app cask (which
# hard-deps brew's neovim — the Nix nvim stays the real editor via alias +
# EDITOR + the neovide config), and nerd fonts. Curate to taste.
if [ "$os" = "Darwin" ]; then
    if ! have brew; then
        say "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    eval "$(/opt/homebrew/bin/brew shellenv)"

    say "Installing brew formulae + casks (pragmatic-split set)"

    # ── TODO: curate these two lists ─────────────────────────────────────
    # Only what the Mac genuinely wants from brew rather than Nix. Leave a
    # short comment on each so future-you knows WHY it's here and not in Nix.
    brew_formulae=(
        # heavy CLIs / media stacks kept in brew on this storage-tight Mac:
        ffmpeg          # huge Nix closure; brew ships a bottle
        imagemagick
    )
    brew_casks=(
        ghostty                            # terminal emulator (config in config/ghostty)
        neovide-app                        # GUI nvim front-end (targets Nix nvim)
        font-fantasque-sans-mono-nerd-font # guifont in config/nvim .../settings.lua
        # GUI apps, e.g.:
        # firefox
        # rectangle
        # vlc
    )
    # ─────────────────────────────────────────────────────────────────────

    if [ ${#brew_formulae[@]} -gt 0 ]; then brew install "${brew_formulae[@]}"; fi
    if [ ${#brew_casks[@]} -gt 0 ]; then brew install --cask "${brew_casks[@]}"; fi
fi

# ── phase 5: login shell ──────────────────────────────────────────────────
# home-manager installs zsh into the Nix profile but does NOT chsh you into it
# (that needs root + an /etc/shells entry). Left as a manual step on purpose —
# auto-editing /etc/shells + chsh from a bootstrap is the kind of hack that
# bites later. Run these by hand if you want the Nix zsh as your login shell:
nix_zsh="${HOME}/.nix-profile/bin/zsh"
if [ -x "$nix_zsh" ] && [ "${SHELL:-}" != "$nix_zsh" ]; then
    say "Optional: make the Nix zsh your login shell"
    step "sudo sh -c 'echo $nix_zsh >> /etc/shells'"
    step "chsh -s $nix_zsh"
fi

say "Bootstrap complete. Open a fresh terminal to land in the new shell."
