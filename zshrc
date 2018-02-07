# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#
# other settings to export
export CLICOLOR_FORCE=1
export LESS='EXiR'

export HISTSIZE=10000
export SAVEHIST=10000
#setopt EXTENDED_HISTORY         # Write the history file in the ":start:elapsed;command" format.
#setopt INC_APPEND_HISTORY       # Write to the history file immediately, not when the shell exits.
#setopt SHARE_HISTORY            # share history between sessions
#setopt HIST_IGNORE_DUPS         # Do not record an entry that was just recorded again.
#setopt HIST_FIND_NO_DUPS        # Do not display a line previously found.
#setopt HIST_SAVE_NO_DUPS        # Do not write duplicate entries in the history file.
#setopt HIST_VERIFY              # Do not execute immediately upon history expansion.
setopt AUTO_LIST                # list options instead of complaining about ambiguity
setopt NO_BEEP                  # Do not fucking beep
setopt NO_LIST_BEEP             # Do not fucking beep

export SCRIPTHOME=$HOME/scripts

# set path
export PATH="/usr/sbin:/usr/local/bin/:$SCRIPTHOME:~/local/bin:$PATH"

# add to PYTHONPATH
export PYTHONPATH=$PYTHONPATH:/usr/local/shotgun/python-api

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
#
# =============================================================================
#                                Key Bindings
# =============================================================================
# Common CTRL bindings.

bindkey -e
bindkey '^\n' autosuggest-execute

# Do not require a space when attempting to tab-complete.
bindkey "^i" expand-or-complete-prefix

# =============================================================================
#                                 Completions
# =============================================================================

zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select=1
zstyle ':completion:*' verbose yes
#zstyle ':completion:*:descriptions' format '%B%d%b'
#zstyle ':completion:*:messages' format '%d'
#zstyle ':completion:*:warnings' format 'No matches for: %d'
#zstyle ':completion:*' group-name ''

# case-insensitive (all), partial-word and then substring completion
zstyle ":completion:*" matcher-list \
  "m:{a-zA-Z}={A-Za-z}" \
  "r:|[._-]=* r:|=*" \
  "l:|=* r:|=*"

#zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

#=============================================================================
# oh-my-zsh specific configs
#=============================================================================

# Path to your oh-my-zsh installation.
export ZSH=/Users/$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# Rhyd-Ddu [14:57:38] ~ [1167] >
#ZSH_THEME="plongitudes"
POWERLEVEL9K_MODE='nerdfont-complete'
ZSH_THEME="powerlevel9k/powerlevel9k"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
#COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    docker
    git
    history-search-multi-word
    zsh-autosuggestions
    zsh-completions
    fast-syntax-highlighting
)

autoload -U compinit && compinit

# start up oh-my-zsh
source $ZSH/oh-my-zsh.sh

# start up enhancd
source $ZSH_CUSTOM/plugins/enhancd/init.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


