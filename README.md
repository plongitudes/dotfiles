# Plongitudes' dotfiles
## Advantages of this repo
### Easy Vim setup
The `.vimrc` in this repo includes its own bootstrap, and the first time you launch vim, nvim, or vimR, it will install [Vundle](https://github.com/VundleVim/Vundle.vim) and all plugins that are listed in `.vimrc`. This is handy for getting your painstakingly-crafted [Vim](https://www.vim.org) condifg up and running right after you've bootstrapped your system, with no messy mucking about. One requirement though is that you at least have `vim` installed -- most vanilla `vi` binaries can't handle the bootstrapping script in the `.vimrc`. I'm sure this could be adapted for other vim plugin managers, but I haven't tried.
### Hands-free installation of iTerm prefs
For macOS (Darwin-style linux) installs, [iTerm2](https://www.iterm2.com/) preference files will be installed, so that the iTerm config from the dotfiles repo will look just like it should once bootstrapping is done. No need to launch iTerm, mess with prefs, and relaunch. For `iTerm2`, linking the binary prefs file means that on first launch, you won't need to tell `iTerm` to look in the dotfiles repo for it's pref and profile info. This is very handy if you're using [nerd-fonts](https://github.com/ryanoasis/nerd-fonts) and/or [gruvbox](https://github.com/morhetz/gruvbox) and have your terminal set up *just so*.
### Alfred sync-folder setup 
I give [Alfred](https://www.alfredapp.com/) a sync folder location (like Box or Dropbox) so that all my macs have access to the same workflows and preferences. Including `Alfred`'s prefs in this repo means that it will know where to look as soon as bootstrapping (and syncing) is complete.
__Note:__ If you adopt this method, be sure to put your sync folders in the same place each time so that the related prefs files are looking in the right place.
### Cross-platform functionality and some shell/homedir homogenization.
The bootstrap script knows about `Darwin` and `Linux` platforms, and will tailor the bootstrapping process depending on your host OS. Regardless of whether you install on Linux or macOS, the resulting homedir will be very similar in setup, so that if you hop back and forth between platforms during the day, most of your shell experience will be the same for you.
__Note:__ There's a lot of app pre-installation that happens on the macOS side, but less for Linux. That's more of a personal preference for my daily work, and I'm confident in your ability to customize that to suit your tastes.
### Lowest-common-denominator prompt theming
The prompt theming tries to be as smart as possible. While truecolor terminals are ideal, less-capable terminals are also heartily welcomed. If your term supports less than 256 colors, the [powerlevel9k](https://github.com/bhilburn/powerlevel9k) theme will be turned off in favor of a simpler custom `oh-my-zsh` theme. If your term is _really_ poor and has less than 16 colors, the prompt theme will fall even further back to a very plain prompt (but you'll still get some decent functionality out of it). There hasn't been a ton of work put into this last resort as such, it's mostly geared towards simplicity and not accidentally wandering into the realms of blinky text on account of unrenderable colors being requested.


## Installation
__Warning:__ If you want to give this repo a try, realize that many of the dotfiles are fairly customized to my own preferences (as is anyone's dotfiles repo), especially `.vimrc`, `.zshrc`, and my choice of oh-my-zsh plugins (in the bootstrap script). However, if you'd like to go bravely soldier on and give it a whirl, please do so.

### Kick it all off with the bootstrap script
The fastest way to get started is to use `curl` or `wget` to pull the bootstrap script from github, make the file executeable, and run it. I recommend downloading it first and examining its contents (unless you've already pored over the repo on github) before blindly sallying forth.

#### Option A: suspiciousfry.jpg (recommended)
```
curl -fsSL https://raw.githubusercontent.com/plongitudes/dotfiles/master/bootstrap.sh > bootstrap.sh
vi bootstrap.sh
./bootstrap.sh
```

#### Option B: doitlive.jpg
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/plongitudes/dotfiles/master/bootstrap.sh)"
```

## Various Caveats and Gotchas
### (aka, this script cannot be run 100% unattended)
- The [oh-my-zsh](http://ohmyz.sh/) installation step currently drops you into a `zsh` shell after it's done but before the bootstrap is complete. The boostrap will warn you about this before it happens, but be aware that all you have to do is type `exit` to continue bootstrapping. There's an open issue on the OMZ repo about this, and I'll integrate the change as soon as it's resolved.
- The `oh-my-zsh` install will prompt you for your password so that it can change your shell from whatever it currently is to `zsh`.

## macOS Caveats
- The bootstrapper will check for `ruby` and `curl` as pre-requisites to installing [Homebrew](https://brew.sh/) as the package manager. If it can't find ruby or curl, it will bail out and not proceed any further. If successful, it will then go on to use `brew` and `brew cask` for all subsequent installations.
- Install might take a bit longer, depending on how many applications you decide to `brew cask install`. The default set is pretty hefty, so be aware.

## Linux Caveats
- Because of the reliance on the `powerlevel9k` and `vim-airline` plugin's requirements, the default terminal will look pretty wonky until you install `nerd-fonts`. However, cloning the nerd fonts repo is disabled by default because it's almost 1.5GB in size. Once installed and properly set up, things look much better. I haven't made this very smart yet since I don't spend much time in Linux desktop environments. If that changes, expect this section to improve ;)

## Thanks
- [Andre Klärner](https://github.com/klaernie) for his super-clever gist about [bootstrapping vimrc and vundle](https://gist.github.com/klaernie/db37962e955c82254fed)
- The [Homebrew](https://brew.sh/) group for putting together and maintaining such an awesome package manager
- The [Homebrew Cask](https://github.com/caskroom/homebrew-cask) folks for making my life so much easier
- All the [dotfiles](https://dotfiles.github.io/) repos that I trawled through
