################################################################################
# independent exports and misc env setup
################################################################################

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$PATH

# turns out we need this extra termindo dir for tmux on macOS
export TERMINFO_DIRS=$TERMINFO_DIRS:$HOME/.local/share/terminfo
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export EDITOR='nvim'
export BATDIFF_USE_DELTA=true
export PAGER='less'
export LESS='-FiMXr -j.5'
export DELTA_FEATURES='side-by-side line-numbers'

# zsh env vars
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
UPDATE_ZSH_DAYS=1

# behavior
setopt no_beep

# usability
setopt auto_cd

# history
export HISTSIZE=10000
export SAVEHIST=10000
setopt append_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history

fpath+=${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
fpath+=${HOME:-~}/.dotfiles/zsh_functions


################################################################################
# p10k
################################################################################

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


################################################################################
# oh-my-zsh setup
################################################################################

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
COMPLETION_WAITING_DOTS="%F{yellow}...󰦖 %f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    ohmyzsh-full-autoupdate
    zsh-autosuggestions
    fast-syntax-highlighting
    poetry
    python
    pylint
    rtx
)
    # do not load zsh-completions in the plugins folder (see above)

# note to self that oh-my-zsh autoloads compinit for us, no need to autoload it
# here or anything.

source $ZSH/oh-my-zsh.sh


################################################################################
# rtx
################################################################################

eval "$(/opt/homebrew/bin/rtx activate zsh)"
export EXA_ICON_SPACING=2
export EZA_HOME=`which eza`


################################################################################
# more misc env stuff but after rtx is loaded
################################################################################

# this gets the version number of the currently installed Python via rtx. There
# are obviously better and easier ways to get it, but I spent 5 minutes writing
# this and I like it, so I'm just going to keep it as a good example of how to
# use `read`.
read -A python_ver <<< `rtx list python`
pyver_regex='([0-9]{1,2}\.){2}[0-9]{1,2}'
for segment in $python_ver; do
  if [[ $segment =~ $pyver_regex ]]; then
    #echo $segment
  fi
done

# now, an easier way to do it that can be included in settings.lua
# for the python3_provider
export NVIM_PYTHON_PATH=`which python`


################################################################################
# load aliases and last bits and bobs
################################################################################

source ${HOME}/.aliases.zsh

# this bit puts any p10k instant prompt at the bottom of the screen. good to
# turn off if things are being weird.
print ${(pl:$LINES::\n:):-}

# set vi mode for the prompt
#bindkey -v
#export KEYTIMEOUT=1

# iTerm2 integration
test -e /Users/tonye/.iterm2_shell_integration.zsh && \
    source /Users/tonye/.iterm2_shell_integration.zsh || true

printf "\e]1337;SetBadgeFormat=%s\a" \
  $(echo -n "\(hostname) \(jobName)\n\(columns)x\(rows)" | base64)
