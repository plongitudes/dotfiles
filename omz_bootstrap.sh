# install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install Homebrew-Cask
brew tap caskroom/cask

# install Zsh and set shell for user
brew install zsh
sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

# and git
brew install git

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install omz plugins
git clone https://github.com/b4b4r07/enhancd ~/.oh-my-zsh/custom/plugins/enhancd
git clone https://github.com/zdharma/fast-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions
zsh-history-substring-search
zsh-syntax-highlighting
