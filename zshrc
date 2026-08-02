
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
# Absolute path to the Nix nvim (not bare 'nvim', which PATH-resolves to brew's
# on macOS, where the neovide-app cask keeps brew neovim installed). Pins the
# reproducible editor for $EDITOR consumers (git commit, crontab -e, …). Same
# path on the VM, so it's fleet-safe. See the nvim notes in home/tonye/default.nix.
export EDITOR="$HOME/.nix-profile/bin/nvim"
export PAGER='less'
export LESS='-FiMXr -j.5'
export PYTHONSTARTUP="${HOME}/.pystartup"
export VIRTUAL_ENV_DISABLE_PROMPT=0
export HOMEBREW_AUTO_UPDATE_SECS=43200
export GITHUB_HOME="${HOME}/github/plongitudes"

# Home-only shell extras (e.g. home-automation env) live in a private overlay
# and load only when it's cloned to ~/.undisclosed — absent on non-owned
# devices, where this is a silent no-op.
[ -f ~/.undisclosed/zshrc.local ] && source ~/.undisclosed/zshrc.local

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
    # only run when stdin is a real terminal; skip in non-interactive/piped shells
    [[ -t 0 ]] || return
    # find a fortune that's short enough to fit in the terminal window with a little extra room.
    width=$(stty size | cut -d ' ' -f 2)
    width=$(expr $width - 20)
    fort_pfx=".-=# "
    fort_sfx=$(rev <<< ${fort_pfx})
    fort_str=$(fortune -s -n $width)
    fort_str="${fort_str//[$'\t\r\n']/ }"
    echo $(lolcat -f <<< "${fort_pfx}${fort_str}${fort_sfx}")
}

function _dynamic_fzf () {
    # when changing directories, update the fd search directories and generate a new fortune.
    # when making a custom FZF_DYNAMIC_PATHS, use:
    # typeset -a FZF_DYNAMIC_PATHS=("path" "path2" "etc")
    local search_paths=("${PWD}" "${FZF_DYNAMIC_PATHS[@]}" "${HOME}/.config" "${HOME}")
    # -I (don't honor .gitignore) but deliberately NOT -L (follow symlinks):
    # with -L, fd walks the home-manager store symlinks into /nix/store and
    # enumerates the whole closure on every Ctrl-T/Alt-C (~5M paths, ~110s).
    # Dropped so we're not wading through the nix store on every hit — the
    # editable configs are still reachable at their real ~/.dotfiles/ paths.
    local flags="-I --max-depth 7 --exclude '.git' --exclude 'Library'"
    # dedupe: when PWD == $HOME the literal ~ would otherwise be searched twice,
    # doubling Alt-C results. ${(u)} keeps unique entries (fd already dedupes
    # subtree overlaps, so only the exact PWD==HOME collision needed handling).
    # NOTE: see `man zshexpn` for more info on zsh shell expansions
    for p in "${(u)search_paths[@]:#}"; do flags="${flags} --search-path ${p}"; done
    export FZF_DEFAULT_OPTS="--height=40% --min-height=10 --layout=reverse-list --border=rounded --border-label=\"$(fortsplat)\""
    export FZF_DEFAULT_COMMAND="fd --type f ${flags}"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d ${flags}"
}

# export FZF_TMUX=1
_dynamic_fzf

# nix-search-tv in fzf
# nix-search-tv: fuzzy search nixpkgs / home-manager / nixos option docs.
# `ns` opens the picker; `ns programs.git` opens it pre-filtered.
function ns() {
    nix-search-tv print | fzf \
        --preview 'nix-search-tv preview {}' \
        --scheme history \
        --query "$*"
}


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
# strategy + highlight colour now set via programs.zsh.autosuggestion (shell.nix)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

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

# fpath entries live in shell.nix (mkOrder 550) so they land before oh-my-zsh
# runs compinit; zsh-completions comes from the Nix profile.


#    ▌                     ▌
# ▞▀▖▛▀▖▄▄▖▛▚▀▖▌ ▌▄▄▖▀▜▘▞▀▘▛▀▖
# ▌ ▌▌ ▌   ▌▐ ▌▚▄▌   ▗▘ ▝▀▖▌ ▌
# ▝▀ ▘ ▘   ▘▝ ▘▗▄▘   ▀▀▘▀▀ ▘ ▘

# oh-my-zsh + its plugins are configured in programs.zsh.oh-my-zsh (shell.nix).
# HM sources oh-my-zsh at mkOrder 800, before this file (mkOrder 1000), so its
# plugins and settings (HYPHEN_INSENSITIVE, HIST_STAMPS) are already in place.
export VIRTUAL_ENV_DISABLE_PROMPT=0

#    ▐       ▞        ▌▗▀▖▝▖
# ▙▀▖▜▀ ▚▗▘ ▐ ▝▀▖▞▀▘▞▀▌▐   ▐
# ▌  ▐ ▖▗▚  ▝▖▞▀▌▝▀▖▌ ▌▜▀  ▞
# ▘   ▀ ▘ ▘  ▝▝▀▘▀▀ ▝▀▘▐  ▝

# mise is activated by programs.mise (shell.nix); its tools/settings live in
# that module's globalConfig.
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
# export NVIM_PYTHON_PATH=`which python`  # python3_host_prog is set in settings.lua instead


#    ▜ ▗                      ▌ ▗▀▖▗    ▗    ▌  ▗
# ▝▀▖▐ ▄ ▝▀▖▞▀▘▞▀▖▞▀▘ ▝▀▖▛▀▖▞▀▌ ▐  ▄ ▛▀▖▄ ▞▀▘▛▀▖▄ ▛▀▖▞▀▌ ▌ ▌▛▀▖
# ▞▀▌▐ ▐ ▞▀▌▝▀▖▛▀ ▝▀▖ ▞▀▌▌ ▌▌ ▌ ▜▀ ▐ ▌ ▌▐ ▝▀▖▌ ▌▐ ▌ ▌▚▄▌ ▌ ▌▙▄▘
# ▝▀▘ ▘▀▘▝▀▘▀▀ ▝▀▘▀▀  ▝▀▘▘ ▘▝▀▘ ▐  ▀▘▘ ▘▀▘▀▀ ▘ ▘▀▘▘ ▘▗▄▘ ▝▀▘▌

source ${HOME}/.aliases.zsh

# Nudge (once per interactive shell) if ~/.dotfiles has unpushed work. Defined in
# aliases.zsh; run here so `sa` (re-source aliases) doesn't re-fire it.
[[ -o interactive ]] && _nixie_hint

# set vi mode for the prompt
#bindkey -v
#export KEYTIMEOUT=1

# iTerm2 integration
#test -e "${HOME}/.iterm2_shell_integration.zsh" && \
#    source "${HOME}/.iterm2_shell_integration.zsh" || true

#printf "\e]1337;SetBadgeFormat=%s\a" \
  #$(echo -n "\(hostname) \(jobName)\n\(columns)x\(rows)" | base64)

# fzf keybindings + completion come from programs.fzf (shell.nix)

# Added by Windsurf
export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# prompt (oh-my-posh) is inited by programs.oh-my-posh (shell.nix); theme comes
# from programs.oh-my-posh.configFile (omp-plongitudes.json).

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
