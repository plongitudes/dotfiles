# Plongitudes' dotfiles

Nix + [home-manager](https://github.com/nix-community/home-manager), one flake, driving all machines. The whole thing is declarative: `flake.nix` is the source of truth, and a single `home-manager switch` rebuilds the entire user environment out of it — shell, prompt, editor, CLI tooling, dotfiles, the lot.

## What you get

### Reproducible, not just "documented"
The old version of this repo was a pile of files plus a bootstrap script that imperatively glued them into place. This one is a flake. Every package, every config file, every symlink is declared in `home/common/default.nix` (+ `shell.nix`), pinned by `flake.lock`. Two machines run the same closure, so "works on my laptop" and "works on the server" are the same statement. No drift, no "wait, which version of node did I install here."

### Live-editable where it actually matters
Full reproducibility usually means your configs live read-only in the Nix store, and every tweak needs a rebuild. That's miserable for the two files I fiddle with constantly, so those are symlinked straight back into the repo: `aliases.zsh` and `~/.config/nvim`. Edit them in place, re-source (`sa`/`va`) or reload nvim, done — no `switch` required. Everything else is nix-managed in-store, where it belongs. `lazy.nvim` can still write its lockfile because the nvim dir is a live symlink, and that lockfile is committed, so reproducibility holds.

### One flake, every machine
`flake.nix` carries a `homeConfigurations` entry for macOS (and nix-on-linux) machines and a `nixosConfigurations` entry for nixOS. Same `default.nix` feeds both, with `pkgs.stdenv.isDarwin` guarding the handful of things that differ. Hop between them and the shell feels identical, because it *is* identical — same zsh, same [oh-my-posh](https://ohmyposh.dev/) prompt, same [mise](https://mise.jdx.dev/) runtimes, same `fd`/`eza`/`bat`/`ripgrep`/`gh`/etc., all from Nix.

### Pragmatic about Homebrew
Nix builds from source. For small, fast-compiling CLI tools, that cost is almost free and you get the reproducibility win. For heavier (`ffmpeg`, `imagemagick`) or other GUI apps, Homebrew's prebuilt bottles are prefereable; especially on a storage-tight laptop where you might not want a 2.8 GiB source build for a GUI front-end. So there's a deliberate split: the reproducible core lives in Nix, the heavy/GUI stuff lives in brew. `bootstrap.sh` installs the brew set dead last, because Nix and brew don't depend on each other. I'd rather have the deterministic half working before the imperative half gets a chance to prompt for sudo.

## Installation

### bootstrap.sh
Fresh machine? Call `bootstrap.sh`. It installs Xcode Command Line Tools (macOS), then Nix. The [Determinate](https://github.com/DeterminateSystems/nix-installer) installer has flakes on by default, and they survive OS upgrades. We then clone this repo to `~/.dotfiles`, and run the first `home-manager switch`. That switch is where the real work happens: every symlink, the whole shell, mise, oh-my-posh, the CLI toolchain. On macOS it finishes by installing the Homebrew set.

Download it and read it before you run it. It's short.

```
curl -fsSL https://raw.githubusercontent.com/plongitudes/dotfiles/master/bootstrap.sh > bootstrap.sh
vi bootstrap.sh
./bootstrap.sh
```

The brew formulae/casks in `bootstrap.sh` should be altered to taste, unless you're me, in which case you're already set.

### Day to day
Once it's live, three commands carry most of the weight (all defined in `aliases.zsh`):

- **`switch`** — rebuild from the flake. Picks the right config by hostname and pipes the build through [nom](https://github.com/maralorn/nix-output-monitor) so you get a live progress tree instead of a long silence.
- **`nixie`** — quiet status probe: what's out of date, what would change, without the build noise.
- **`ns <query>`** — fuzzy-search nixpkgs / home-manager / NixOS options right in the terminal (via [nix-search-tv](https://github.com/3timeslazy/nix-search-tv)).

## Caveats and gotchas
- __Opinionated and Specific__ Everything here is fairly heavily to my own prefs — `zshrc`, the prompt, the app list, but very especially the neovim config. Fork it, gut it, make it yours. Or don't.
- __Xcode CLT prompt (macOS).__ On a fresh Mac, `bootstrap.sh` triggers the Command Line Tools GUI installer and then exits; let that finish, then re-run. Everything after is unattended until brew.
- __Login shell is manual.__ home-manager installs zsh into the Nix profile but won't `chsh` you into it — that needs root and an `/etc/shells` entry. `bootstrap.sh` prints the two commands you'll need.
- __The VM is different.__ non-nixOS machines provision via `nixos-rebuild`, not this script. `bootstrap.sh` is the macOS (and generic Nix-on-Linux) path.

## Thanks
- The [nix-community](https://github.com/nix-community/home-manager) folks for home-manager, which is doing 90% of the work here.
- [Determinate Systems](https://determinate.systems/) for a Nix installer that doesn't fall over on the next macOS update.
- The [Homebrew](https://brew.sh/) crew — still the right tool for the heavy, GUI half.
- Every [dotfiles](https://dotfiles.github.io/) repo I've ever trawled through for ideas.
