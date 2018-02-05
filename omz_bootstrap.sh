#!/bin/bash

# detect platform
uname_str=$(uname)
ECHO_PREFIX="...---===### "
ECHO_SUFFIX=" ###===---..."

# some tiny helper funcs for messaging the user
msg_user () {
    printf "$ECHO_PREFIX $1 $ECHO_SUFFIX\n"
}

pfx_user () {
    printf "$ECHO_PREFIX $1"
}

sfx_user () {
    printf "$1 $ECHO_SUFFIX\n"
}

# we need to check for various executables, so here's a helper function to test
# for a program and to return a var that contains its location if successful.
# failure will exit the entire script, which is fine because we don't want to
# continue in that case anyway.
# usage: create_var <program name> <RETURN_VAR>
create_var () {
    local program=$1
    local __resultvar=$2

    pfx_user "Checking that $program exists..."
    # `type -p`: type is a bash builtin. with `-p`, it will return the full path
    # of the name queried.
    local program_location=$(type -p $program 2>/dev/null)
    # if $program_location exists and is executeable, then hurray!
    if [ -x "$program_location" ]; then
        sfx_user "...[OK]"
        # we can use eval to set the incoming var name as the actual var with
        # contents from $program_location.
        eval $__resultvar="'$program_location'"
    else
        sfx_user "...[ERROR]"
        if [ $# -eq 3 ]; then
            # use the third arg to run an install
            msg_user "Attempting to install $program..."
            $($3)
        else
            msg_user "Aborting: couldn't find $program installed on this machine."
            exit 1
        fi
    fi
}

if [ $uname_str -eq "Darwin" ]; then
    # running macOS, let's use Homebrew for most things
    msg_user "Detected Darwin/MacOS system"

    # install Homebrew
    msg_user "Attempting to install Homebrew"

    # check that curl is installed
    create_var curl CURL_CMD

    # check that ruby is installed
    create_var ruby RUBY_CMD

    # we are go for Homebrew if we've made it this far
    $RUBY_CMD -e "$($CURL_CMD -fssl https://raw.githubusercontent.com/homebrew/install/master/install)"

    # see if Brew binary exists now
    create_var brew BREW_CMD

    # install Homebrew-Cask
    msg_user "Tapping Homebrew-Cask"
    $BREW_CMD tap caskroom/cask

    # install Zsh and set shell for user
    msg_user "Installing Homebrew's Zsh"
    $BREW_CMD install zsh
    sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

    # and git
    if [ -z $(which git) ]
    msg_user "Installing git"
    $BREW_CMD install git

elif [ $uname_str -eq "Linux" ]; then
    # found a flavor of Linux, let's find a package manager and keep going.

    # detect package manager
    APTITUDE_CMD=$(which aptitude)
    APT_GET_CMD=$(which apt-get)

    if [ ! -z $APTITUDE_CMD ]; then
        $PACK_MAN="aptitude"
    elif [ ! -z $APT_GET_CMD ]; then
        $PACK_MAN="apt-get"
    else
        msg_user "Can't determine package manager, aborting."
        exit 1;
    fi

    msg_user "Found $PACK_MAN to use as package manager."

    # see if zsh is installed and install it if not.
    if [ -z "$(which zsh)" ]; then
        $PACK_MAN install zsh
    fi

    # make sure zsh is installed
    if [ -e "$(which zsh)" ]; then
        msg_user "changing shell to zsh:"
        chsh -s $(which zsh)
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

