#!/bin/bash

######## to-do: figure out how to curl this script from github
######## test get_package function in cleanroom and macos

ECHO_PREFIX="...---===### "
ECHO_SUFFIX=" ###===---..."
PACK_MAN=""
PROGRAM_FOUND=0
PROGRAM_INSTALLED=0

# Some tiny helper funcs for messaging the user
msg_user () { printf "$ECHO_PREFIX $1 $ECHO_SUFFIX\n" }
pfx_user () { printf "$ECHO_PREFIX $1" }
#sfx_user () { printf "$1 $ECHO_SUFFIX\n" }
sfx_user () { printf "$1\n" }

# Detect platform and set package manager
uname_str=$(uname)

if [ $uname_str -eq "Darwin" ]; then
    # Assume for now that we'll be using Homebrew, since that's the only package
    # manager that we want for macOS. We'll verify this later on.
    PACK_MAN="brew"
elif [ $uname_str -eq "Linux" ]; then
    # Detect package manager for our flavor of Linux

    local APTITUDE_CMD=$(type -p aptitude 2>/dev/null)
    local APT_GET_CMD=$(type -p apt-get 2>/dev/null)
    local YUM_CMD=$(type -p yum 2>/dev/null)

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
    PACK_MAN="sudo $PACK_MAN"
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
    # `type -p`: type is a bash builtin. with `-p`, it will return the full path
    # of the name queried.
    local package_location=$(type -p $package 2>/dev/null)
    # if $package_location exists and is executeable, then hurray!
    if [ -x "$package_location" ]; then
        sfx_user "...[SUCCESS]"
        # we can use eval to set the incoming var name as the actual var with
        # contents from $package_location.
        eval $__resultvar="'$package_location'"
        PROGRAM_FOUND=1
    else
        sfx_user "...[NOT FOUND]"
        msg_user "Aborting: couldn't find $package installed on this machine."
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
    local result=0
    while [ $result -ne 0 ];
    do
        find_package $($1) $($2)
        if [ $? -ne 0 ]; then
            install_package $($1)
            result=$?
        fi
    done
}

if [ $uname_str -eq "Darwin" ]; then
    # running macOS, let's use Homebrew for most things
    msg_user "Detected Darwin/MacOS system"

    # install Homebrew
    msg_user "Attempting to install Homebrew for package management,"

    # curl and ruby are prerequisites for homebrew.
    # if we can't find them, we can't install them handily, so abort.
    find_package curl CURL_CMD; if [ $PROGRAM_FOUND -eq 0 ]; then exit 1
    find_package ruby RUBY_CMD; if [ $PROGRAM_FOUND -eq 0 ]; then exit 1

    # if we've made it this far, we are go for Homebrew
    $RUBY_CMD -e "$($CURL_CMD -fssl https://raw.githubusercontent.com/homebrew/install/master/install)"

    # see if Brew binary exists now
    find_package brew PACK_MAN; if [ $PROGRAM_FOUND -eq 0 ]; then exit 1

    # set up Homebrew-Cask
    msg_user "Tapping Homebrew-Cask"
    $PACK_MAN tap caskroom/cask

    # install Zsh and set shell for user
    get_package zsh ZSH_CMD
    sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

    # and git
    get_package git GIT_CMD

elif [ $uname_str -eq "Linux" ]; then

    # make sure zsh is installed
    install_package zsh ZSH_CMD
    if [ -e "$(which zsh)" ]; then
        msg_user "changing shell to zsh:"
        chsh -s $(which zsh)
    fi

    # see if zsh is installed and install it if not.
    install_package git GIT_CMD
fi

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install omz plugins
git clone https://github.com/b4b4r07/enhancd ~/.oh-my-zsh/custom/plugins/enhancd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/enhancd
git clone https://github.com/zdharma/fast-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zdharma/history-search-multi-word.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/history-search-multi-word
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# dotfiles
git clone https://github.com/plongitudes/dotfiles.git ${HOME}/.dotfiles

ln -sf ${HOME}/.dotfiles/zshrc ${HOME}/.zshrc
ln -sf ${HOME}/.dotfiles/aliases.zsh ${HOME}/.oh-my-zsh/custom/aliases.zsh
ln -sf ${HOME}/.dotfiles/powerlevel9k.zsh ${HOME}/.oh-my-zsh/custom/powerlevel9k.zsh
ln -sf ${HOME}/.dotfiles/vimrc ${HOME}/.vimrc
ln -sf ${HOME}/.dotfiles/vimrc ${HOME}/.config/nvim/init.vim
ln -sf ${HOME}/.dotfiles/vimrc ${HOME}/.vim/init.vim

