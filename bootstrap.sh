#!/bin/bash

ECHO_PREFIX="...---===### [[["
ECHO_SUFFIX=""
PACK_MAN=""
PROGRAM_FOUND=0
PROGRAM_INSTALLED=0

# Some tiny helper funcs for messaging the user
msg_user () { printf "$ECHO_PREFIX $1 $ECHO_SUFFIX\n"; }
pfx_user () { printf "$ECHO_PREFIX $1"; }
#sfx_user () { printf "$1 $ECHO_SUFFIX\n" }
sfx_user () { printf "$1\n"; }

# Detect platform and set package manager
uname_str=$(uname)

if [ "$uname_str" == "Darwin" ]; then
    # Assume for now that we'll be using Homebrew, since that's the only package
    # manager that we want for macOS. We'll verify this later on.
    PACK_MAN="brew"
elif [ "$uname_str" == "Linux" ]; then
    # Detect package manager for our flavor of Linux

    APTITUDE_CMD=$(command -v aptitude 2>/dev/null)
    APT_GET_CMD=$(command -v apt-get 2>/dev/null)
    YUM_CMD=$(command -v yum 2>/dev/null)

    if [ ! -z $APTITUDE_CMD ]; then
        PACK_MAN="aptitude"
    elif [ ! -z $APT_GET_CMD ]; then
        PACK_MAN="apt-get"
    elif [ ! -z $YUM_CMD ]; then
        PACK_MAN="yum"
    else
        msg_user "Can't determine package manager, aborting."
        exit 1;
    fi
    msg_user "Found $PACK_MAN to use as package manager."
    msg_user "Will attempt to sudo all install commands."
    PACK_MAN="sudo $PACK_MAN -y"
fi

# we need to check for various executables, so here's a helper function to test
# for a package and to return a var that contains its location if successful.
# failure will exit the entire script, which is fine because we don't want to
# continue in that case anyway.
# usage: find_package <package name> <RETURN_VAR>
find_package () {
    PROGRAM_FOUND=0
    local package=$1
    local __resultvar=$2

    pfx_user "Checking if $package exists..."
    # `command -v`: type is a bash builtin. with `-p`, it will return the full path
    # of the name queried.
    local package_location=$(command -v $package 2>/dev/null)
    # if $package_location exists and is executeable, then hurray!
    if [ -x "$package_location" ]; then
        sfx_user "...[SUCCESS]"
        # we can use eval to set the incoming var name as the actual var with
        # contents from $package_location.
        eval $__resultvar="'$package_location'"
        PROGRAM_FOUND=1
    else
        sfx_user "...[NOT FOUND]"
    fi
}

install_package () {
    local package=$1
    PROGRAM_INSTALLED=0
    msg_user "Attempting to install $package..."
    $PACK_MAN install $package
    if [ $? -ne 0 ]; then
        msg_user "[ERROR]: install of $package via $PACK_MAN failed with non-zero exit code."
    else
        msg_user "[SUCCESS]: installed $package."
        PROGRAM_INSTALLED=1
    fi
}

get_package () {
    local result=1
    while [ $result -ne 0 ];
    do
        find_package $1 $2
        if [ $PROGRAM_FOUND -eq 0 ]; then
            install_package $1
            result=$?
        else
            # we're done here
            result=0
        fi
    done
}

if [ "$uname_str" == "Darwin" ]; then
    # running macOS, let's use Homebrew for most things
    msg_user "Detected Darwin/MacOS system"

    # install Homebrew
    msg_user "Attempting to install Homebrew for package management,"

    # curl and ruby are prerequisites for homebrew.
    # if we can't find them, we can't install them handily, so abort.
    find_package curl CURL_CMD; if [ $PROGRAM_FOUND -eq 0 ]; then exit 1; fi
    find_package ruby RUBY_CMD; if [ $PROGRAM_FOUND -eq 0 ]; then exit 1; fi

    # if we've made it this far, we are go for Homebrew
    $RUBY_CMD -e "$($CURL_CMD -fssl https://raw.githubusercontent.com/homebrew/install/master/install)"

    # see if Brew binary exists now
    find_package brew PACK_MAN; if [ $PROGRAM_FOUND -eq 0 ]; then exit 1; fi

    # set up Homebrew-Cask
    msg_user "Tapping Homebrew-Cask"
    $PACK_MAN tap caskroom/cask

    # also tap homebrew fonts
    brew tap caskroom/fonts
    brew cask install font-hack-nerd-font font-monofur-nerd-font-mono

    # install Zsh and set shell for user
    get_package zsh ZSH_CMD

    # and git
    get_package git GIT_CMD

    # and neovim and vimR
    get_package nvim NVIM_CMD
    $PACK_MAN cask install vimr

    # and fuckit, other apps we'll need
    $PACK_MAN cask install alfred battle-net box-sync google-chrome \
        default-folder-x disk-inventory-x divvy dropbox filezilla firefox gitx \
        gog-galaxy iterm2 numi pycharm skitch steam synergy the-clock \
        tunnelblick vlc yujitach-menumeters zoom

elif [ "$uname_str" == "Linux" ]; then
    # make sure zsh is installed
    get_package zsh ZSH_CMD

    # vi can't handle Vundle, we need vim at least
    get_package vim VIM_CMD

    # see if git is installed and install it if not.
    get_package git GIT_CMD

    # install nerd-fonts (disabled because repo is 1GB+)
    #git clone https://github.com/ryanoasis/nerd-fonts.git /tmp/nerd-fonts
    #cd /tmp/nerd-fonts
    #/tmp/install.sh FiraCode
    #/tmp/install.sh Monofur
    #cd $HOME
fi

# install oh-my-zsh
echo "Oh-My-Zsh will now install. When finished, it will launch the new (but"
echo "incomplete) shell. To continue the installation, just type 'exit' at the"
echo "new prompt and the install script will continue per normal."
read -p "[Hit Enter/Return to continue] "

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install omz plugins
git clone https://github.com/b4b4r07/enhancd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/enhancd
git clone https://github.com/zdharma/fast-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zdharma/history-search-multi-word.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/history-search-multi-word
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/bhilburn/powerlevel9k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel9k

# dotfiles
git clone https://github.com/plongitudes/dotfiles.git ${HOME}/.dotfiles

mkdir -p ${HOME}/.config/nvim
mkdir -p ${HOME}/.vim
ln -sf ${HOME}/.dotfiles/aliases.zsh ${HOME}/.oh-my-zsh/custom/aliases.zsh
ln -sf ${HOME}/.dotfiles/fakeSMTP.properties ${HOME}/.fakeSMTP.properties
ln -sf ${HOME}/.dotfiles/gitattributes ${HOME}/.gitattributes
ln -sf ${HOME}/.dotfiles/gitconfig ${HOME}/.gitconfig
ln -sf ${HOME}/.dotfiles/gitignore_global ${HOME}/.gitignore_global
ln -sf ${HOME}/.dotfiles/jsbeautifyrc ${HOME}/.jsbeautifyrc
ln -sf ${HOME}/.dotfiles/powerlevel9k.zsh ${HOME}/.oh-my-zsh/custom/powerlevel9k.zsh
ln -sf ${HOME}/.dotfiles/plongitudes.zsh-theme ${HOME}/.oh-my-zsh/custom/themes/plongitudes.zsh-theme
ln -sf ${HOME}/.dotfiles/plongitudes-plain.zsh-theme ${HOME}/.oh-my-zsh/custom/themes/plongitudes.zsh-theme
ln -sf ${HOME}/.dotfiles/tern-project ${HOME}/.tern-project
ln -sf ${HOME}/.dotfiles/tigrc ${HOME}/.tigrc
ln -sf ${HOME}/.dotfiles/vimrc ${HOME}/.vimrc
ln -sf ${HOME}/.dotfiles/vimrc ${HOME}/.vim/init.vim
ln -sf ${HOME}/.dotfiles/vimrc ${HOME}/.config/nvim/init.vim
ln -sf ${HOME}/.dotfiles/zshrc ${HOME}/.zshrc

if [ "$uname_str" == "Darwin" ]; then
    # put Alfred's prefs in so that we know to look in the Box folder for workflow and pref syncing.
    ln -sf ${HOME}/.dotfiles/alfred/com.runningwithcrayons.Alfred-3.plist ${HOME}/Library/Preferences/com.runningwithcrayons.Alfred-3.plist
    ln -sf ${HOME}/.dotfiles/alfred/com.runningwithcrayons.Alfred-Preferences-3.plist ${HOME}/Library/Preferences/com.runningwithcrayons.Alfred-Preferences-3.plist

    # put the binary version of iterm2's prefs in place so that it knows to load up the xml version from dotfiles
    # since both xml and bin files have the same name, keep them seperate

    # also need to rename some folders that are hardwired in the plist, in case $USER is different
    #sed -i "" "s/$OLDUSER/$USER/g" ${HOME}/.dotfiles/iterm2/com.googlecode.iterm2.plist
    defaults import com.googlecode.iterm2 ${HOME}/.dotfiles/iterm2/com.googlecode.iterm2.plist
    defaults export com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
fi

