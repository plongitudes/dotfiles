# Plongitudes' dotfiles
## Advantages of this repo
- `.vimrc` has its __*own*__ bootstrap, and will install [Vundle](https://github.com/VundleVim/Vundle.vim) and all requested plugins from `.vimrc` on first boot. This is handy for getting [Vim](https://www.vim.org) up and running right after you've bootstrapped your system, with no messy mucking about. One requirement though is that you at least have `vim` installed -- most vanilla `vi` binaries can't handle the bootstrapping script in the `.vimrc`.
- For macOS (Darwin-style linux) installs, [iTerm2](https://www.iterm2.com/) and [Alfred](https://www.alfredapp.com/) preference files are included.
 - For `iTerm2`, linking the binary prefs file means that on first launch, you won't need to tell `iTerm` to look in the dotfiles repo for it's pref and profile info. This is very handy if you're using [nerd-fonts](https://github.com/ryanoasis/nerd-fonts) and/or [gruvbox](https://github.com/morhetz/gruvbox) and have your terminal set up *just so*.
 - For `Alfred`, I keep a sync folder offsite so that all my macs have access to the same workflows and preferences. Including `Alfred`'s prefs here means that Alfred will know where to get those from as soon as bootstrapping (and syncing) is complete.
- Cross-platform functionality and some shell/homedir homogenization. The bootstrap script knows about `Darwin` and `Linux`, and will tailor the bootstrapping depending on your host OS.
 - If you install on Linux or macOS, the resulting homedir will be very similar in setup, so that if you hop back and forth a lot during the day, most things will operate the same for you.
 - There's a lot of app pre-installation that happens on the macOS side, but less for Linux. That's more of a personal preference and I'm confident in your ability to customize that to suit your tastes.

## Installation
__Warning:__ If you want to give this repo a try, realize that some of the dotfiles are fairly customized to my own preferences, especially `.vimrc`, `.zshrc`, and my choice of oh-my-zsh plugins (in the bootstrap script).
However, if you'd like to go bravely soldier on and give it a whirl, please do so.

### Using the bootstrap script (omz_bootstrap.sh)
The fastest way to get started is to pull the bootstrap script from github and run it.

#### Option A: ihavenoideawhatimdoing.jpg
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/plongitudes/dotfiles/bootstrap.sh)"
```

#### Option B: suspiciousfry.jpg
```
curl -fsSL https://raw.githubusercontent.com/plongitudes/dotfiles/bootstrap.sh > bootstrap.sh
vi bootstrap.sh
./bootstrap.sh
```
### macOS specific notes
The bootstrapper will check for `ruby` and `curl` as pre-requisites to installing [Homebrew](https://brew.sh/) as the package manager. It will then go on to use `brew` and `brew cask` for all subsequent installations.

## Caveats
### (aka, this script cannot be run 100% unattended)
- The [oh-my-zsh](http://ohmyz.sh/) installation step currently drops you into a `zsh` shell after it's done but before the bootstrap is complete. The boostrap will warn you about this before it happens, but be aware that all you have to do is type `exit` to continue bootstrapping. There's an open issue on the OMZ repo about this, and I'll integrate the change as soon as it's resolved.
- The `oh-my-zsh` install will prompt you for your password so that it can change your shell from whatever it currently is to `zsh`.
- macOS install will take a little longer depending on how many applications you decide to `brew cask install`. The default set is prety hefty, so be aware.

##Thanks
- [Andre Klärner](https://github.com/klaernie) for his super-clever gist about [bootstrapping vimrc and vundle](https://gist.github.com/klaernie/db37962e955c82254fed)
- The [Homebrew](https://brew.sh/) group for putting together and maintaining such an awesome package manager
- The [Homebrew Cask](https://github.com/caskroom/homebrew-cask) folks for making my life so much easier
- All the [dotfiles](https://dotfiles.github.io/) repos that I trawled through
