
# ▌                  ▐
# ▛▀▖▝▀▖▞▀▘▞▀▖ ▞▀▘▞▀▖▜▀ ▌ ▌▛▀▖
# ▌ ▌▞▀▌▝▀▖▛▀  ▝▀▖▛▀ ▐ ▖▌ ▌▙▄▘
# ▀▀ ▝▀▘▀▀ ▝▀▘ ▀▀ ▝▀▘ ▀ ▝▀▘▌

#GITSTATUS_LOG_LEVEL=DEBUG
export PATH=$HOME/bin:$PATH:/opt/homebrew/bin:$HOME/.local/bin

export GOPATH="$HOME/go"

# add GOPATH/bin to PATH
export PATH="$PATH:$GOPATH/bin"


# turns out we need this extra terminfo dir for tmux on macOS
export TERMINFO_DIRS=$TERMINFO_DIRS:$HOME/.local/share/terminfo
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export EDITOR='nvim'
export BATDIFF_USE_DELTA=true
export PAGER='less'
export LESS='-FiMXr -j.5'
export DELTA_FEATURES='side-by-side line-numbers'
export PYTHONSTARTUP="${HOME}/.pystartup"
export HOOBASTANK=$(< ${HOME}/.hoobastank)
export VIRTUAL_ENV_DISABLE_PROMPT=0
export HOMEBREW_AUTO_UPDATE_SECS=43200
export GITHUB_HOME="${HOME}/github/plongitudes"

# Home Assistant Pyscript configuration
# Get token from: HA → Profile → Long-Lived Access Tokens
unamestr=$(uname)
if [ "$unamestr" = 'Linux' ]; then
  export $(grep -v '^#' ${HOME}/.ha_env | xargs -d '\n')
elif [ "$unamestr" = 'FreeBSD' ] || [ "$unamestr" = 'Darwin' ]; then
  export $(grep -v '^#' ${HOME}/.ha_env | xargs -0)
fi

# eza env vars
export EXA_COLORS="da=1;36"
export TIME_STYLE="long-iso"



#                   ▜ ▗         ▌ ▗▀▖         ▐  ▗
# ▞▀▌▞▀▖▛▀▖▞▀▖▙▀▖▝▀▖▐ ▄ ▀▜▘▞▀▖▞▀▌ ▐  ▌ ▌▛▀▖▞▀▖▜▀ ▄ ▞▀▖▛▀▖▞▀▘
# ▚▄▌▛▀ ▌ ▌▛▀ ▌  ▞▀▌▐ ▐ ▗▘ ▛▀ ▌ ▌ ▜▀ ▌ ▌▌ ▌▌ ▖▐ ▖▐ ▌ ▌▌ ▌▝▀▖
# ▗▄▘▝▀▘▘ ▘▝▀▘▘  ▝▀▘ ▘▀▘▀▀▘▝▀▘▝▀▘ ▐  ▝▀▘▘ ▘▝▀  ▀ ▀▘▝▀ ▘ ▘▀▀

function stringContains() {
    # takes 2 args, tests if $1 is a substring of $2
    # works with paths, which is nice.
    case $2 in
        (*$1*) return 0 ;;
        (*) return 1 ;;
    esac
}

function trim() {
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    printf '%s' "$var"
}

# ▗▀▖   ▗▀▖ ▗                    ▐  ▌  ▗
# ▐  ▀▜▘▐   ▄ ▛▀▖ ▞▀▖▌ ▌▞▀▖▙▀▖▌ ▌▜▀ ▛▀▖▄ ▛▀▖▞▀▌
# ▜▀ ▗▘ ▜▀  ▐ ▌ ▌ ▛▀ ▐▐ ▛▀ ▌  ▚▄▌▐ ▖▌ ▌▐ ▌ ▌▚▄▌
# ▐  ▀▀▘▐   ▀▘▘ ▘ ▝▀▘ ▘ ▝▀▘▘  ▗▄▘ ▀ ▘ ▘▀▘▘ ▘▗▄▘

function fortsplat () {
    # find a fortune that's short enough to fit in the terminal window with a little extra room.
    width=$(stty size | cut -d ' ' -f 2)
    width=$(expr $width - 20)
    fort_pfx=".-=# "
    fort_sfx=$(rev <<< ${fort_pfx})
    fort_str=$(fortune -s -n $width)
    fort_str="${fort_str//[$'\t\r\n']/ }"
    echo $(lolcat -f <<< "${fort_pfx}${fort_str}${fort_sfx}")
}

# TODO: rework this so that matching paths only show up once -- likely the last two search paths
function _dynamic_fzf () {
    # when changing directories, update the fd search directories and generate a new fortune.
    local search_paths=("${HOME}/.config" "${HOME}/.oh-my-zsh" "${PWD}" "${HOME}")
    local flags="-IL --max-depth 7 --exclude '.git' --exclude 'Library'"
    flags="${flags} --search-path $PWD --search-path ${HOME}/.config --search-path ${HOME}/.oh-my-zsh --search-path ${HOME}"
    # unique_search_paths=(${(u)search_paths[@]})
    # echo $unique_search_paths
    # for path in $unique_search_paths; do
        # echo $flags
        # flags="${flags} --search-path ${path}"
    # done
    export FZF_DEFAULT_OPTS="--height=40% --min-height=10 --layout=reverse-list --border=rounded --border-label=\"$(fortsplat)\""
    export FZF_DEFAULT_COMMAND="fd --type f ${flags}"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d ${flags}"
}

# export FZF_TMUX=1
_dynamic_fzf

# ▌  ▗        ▐         ▗       ▐  ▗
# ▌  ▄ ▛▀▖▌ ▌▝▀▖▙▀▖▌ ▌  ▞▀▖▌ ▌▞▀▌▞▀▖▜▀ ▄ ▌ ▌▝▀▖▞▀▌▞▀▖
# ▐  ▐ ▌ ▌▚▄▌▞▀▌▌  ▚▄▌  ▛▀ ▐▐ ▌ ▌▌ ▖▐ ▖▐ ▐▐ ▞▀▌▌ ▌▛▀
#  ▘▀▘▘ ▘▗▄▘▝▀▘▘  ▗▄▘  ▝▀▘ ▘ ▝▀▘▝▀  ▀ ▀▘ ▘▝▀▘▝▀▘▝▀▘

function _auto_activate_venv() {
    # Find .venv by walking up the directory tree
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.venv" ]]; then
            local venv_path="$dir/.venv"
            # Only activate if not already in this venv
            if [[ "$VIRTUAL_ENV" != "$venv_path" ]]; then
                source "$venv_path/bin/activate"
            fi
            return 0
        fi
        dir="$(dirname "$dir")"
    done

    # If we get here, no .venv found - deactivate if currently in one
    if [[ -n "$VIRTUAL_ENV" ]] && type deactivate &>/dev/null; then
        deactivate
    fi
}

# Run once on shell startup
_auto_activate_venv

if [[ -v BASH_VERSINFO ]]; then
    PROMPT_COMMAND="_dynamic_fzf; $PROMPT_COMMAND"
elif [[ -v ZSH_VERSION ]]; then
    function chpwd() {
        #case $PWD in
        #  (*/public_html) echo do something
        #esac
        _dynamic_fzf
        _auto_activate_venv
    }
fi

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

# -- Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
  #
# -- CTRL-/ to toggle small preview window to see the full command
# -- CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"


#       ▌         ▐
# ▀▜▘▞▀▘▛▀▖ ▞▀▘▞▀▖▜▀ ▌ ▌▛▀▖
# ▗▘ ▝▀▖▌ ▌ ▝▀▖▛▀ ▐ ▖▌ ▌▙▄▘
# ▀▀▘▀▀ ▘ ▘ ▀▀ ▝▀▘ ▀ ▝▀▘▌

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


#    ▌                     ▌
# ▞▀▖▛▀▖▄▄▖▛▚▀▖▌ ▌▄▄▖▀▜▘▞▀▘▛▀▖
# ▌ ▌▌ ▌   ▌▐ ▌▚▄▌   ▗▘ ▝▀▖▌ ▌
# ▝▀ ▘ ▘   ▘▝ ▘▗▄▘   ▀▀▘▀▀ ▘ ▘

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
#ZSH_THEME="powerlevel10k/powerlevel10k"

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
    fast-syntax-highlighting
    fzf-tab
    git
    mise
    ohmyzsh-full-autoupdate
    pylint
    python
    virtualenv
    zsh-autosuggestions
    zsh-completions
)
    # do not load zsh-completions in the plugins folder (see above)

# note to self that oh-my-zsh autoloads compinit for us, no need to autoload it
# here or anything.

source $ZSH/oh-my-zsh.sh
export VIRTUAL_ENV_DISABLE_PROMPT=0

#    ▐       ▞        ▌▗▀▖▝▖
# ▙▀▖▜▀ ▚▗▘ ▐ ▝▀▖▞▀▘▞▀▌▐   ▐
# ▌  ▐ ▖▗▚  ▝▖▞▀▌▝▀▖▌ ▌▜▀  ▞
# ▘   ▀ ▘ ▘  ▝▝▀▘▀▀ ▝▀▘▐  ▝

eval "$(/opt/homebrew/bin/mise activate zsh)"
export EXA_ICON_SPACING=2


#          ▐       ▐          ▗              ▐
# ▛▀▖▞▀▖▞▀▘▜▀▄▄▖▙▀▖▜▀ ▚▗▘ ▛▚▀▖▄ ▞▀▘▞▀▖ ▞▀▘▞▀▖▜▀ ▌ ▌▛▀▖
# ▙▄▘▌ ▌▝▀▖▐ ▖  ▌  ▐ ▖▗▚  ▌▐ ▌▐ ▝▀▖▌ ▖ ▝▀▖▛▀ ▐ ▖▌ ▌▙▄▘
# ▌  ▝▀ ▀▀  ▀   ▘   ▀ ▘ ▘ ▘▝ ▘▀▘▀▀ ▝▀  ▀▀ ▝▀▘ ▀ ▝▀▘▌

# this gets the version number of the currently installed Python via mise. There
# are obviously better and easier ways to get it, but I spent 5 minutes writing
# this and I like it, so I'm just going to keep it as a good example of how to
# use `read`.
# read -A python_ver <<< `mise list python`
# pyver_regex='([0-9]{1,2}\.){2}[0-9]{1,2}'
# for segment in $python_ver; do
#   if [[ $segment =~ $pyver_regex ]]; then
#     #echo $segment
#   fi
# done

# now, an easier way to do it that can be included in settings.lua
# for the python3_provider
# export NVIM_PYTHON_PATH=`which python`  # No longer needed - python3_host_prog set in settings.lua
apps_for_path=("bat" "fd" "fzf")
for application in ${apps_for_path}; do
    export PATH=${PATH}:$(command -v ${application})
done


#    ▜ ▗                      ▌ ▗▀▖▗    ▗    ▌  ▗
# ▝▀▖▐ ▄ ▝▀▖▞▀▘▞▀▖▞▀▘ ▝▀▖▛▀▖▞▀▌ ▐  ▄ ▛▀▖▄ ▞▀▘▛▀▖▄ ▛▀▖▞▀▌ ▌ ▌▛▀▖
# ▞▀▌▐ ▐ ▞▀▌▝▀▖▛▀ ▝▀▖ ▞▀▌▌ ▌▌ ▌ ▜▀ ▐ ▌ ▌▐ ▝▀▖▌ ▌▐ ▌ ▌▚▄▌ ▌ ▌▙▄▘
# ▝▀▘ ▘▀▘▝▀▘▀▀ ▝▀▘▀▀  ▝▀▘▘ ▘▝▀▘ ▐  ▀▘▘ ▘▀▘▀▀ ▘ ▘▀▘▘ ▘▗▄▘ ▝▀▘▌

source ${HOME}/.aliases.zsh

# set vi mode for the prompt
#bindkey -v
#export KEYTIMEOUT=1

# iTerm2 integration
#test -e /Users/tonye/.iterm2_shell_integration.zsh && \
#    source /Users/tonye/.iterm2_shell_integration.zsh || true

#printf "\e]1337;SetBadgeFormat=%s\a" \
  #$(echo -n "\(hostname) \(jobName)\n\(columns)x\(rows)" | base64)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Added by Windsurf
export PATH="/Users/tonye/.codeium/windsurf/bin:$PATH"

#eval "$(oh-my-posh init zsh)"
eval "$(oh-my-posh init zsh --config '~/.plongitudes.omp.json')"

# opencode
export PATH=/Users/tonye/.opencode/bin:$PATH
