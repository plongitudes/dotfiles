# ▌            ▗▀▖         ▐  ▗          ▜ ▗▐
# ▛▀▖▝▀▖▞▀▘▞▀▖ ▐  ▌ ▌▛▀▖▞▀▖▜▀ ▄ ▞▀▖▛▀▖▝▀▖▐ ▄▜▀ ▌ ▌
# ▌ ▌▞▀▌▝▀▖▛▀  ▜▀ ▌ ▌▌ ▌▌ ▖▐ ▖▐ ▌ ▌▌ ▌▞▀▌▐ ▐▐ ▖▚▄▌
# ▀▀ ▝▀▘▀▀ ▝▀▘ ▐  ▝▀▘▘ ▘▝▀  ▀ ▀▘▝▀ ▘ ▘▝▀▘ ▘▀▘▀ ▗▄▘

# find and use drop-in replacements like bat, ripgrep, etc if installed
for CMD in "cat ls vi vim nvim asdf batg man"; do
  unalias $CMD 2>/dev/null
done

alias cat="bat"
alias vi="nvim"
alias v="neovide"
alias p='poetry'
alias m='mise'

export NVIM_PYTHON_PATH="`mise where python`/bin"
export VSCODE_PATHS="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH=${PATH}:${VSCODE_PATHS}

# below is wicked old and basically obviated by ripgrep, so... will use batgrep instead
# function fnd () { find -L . -print -type f -exec grep -n $* {} \; | grep $* -B 1 }

alias fnd="rg -SC3"
alias grep="grep -i"

alias man="batman"

function vrg() { rg -in --context 5 --heading $* | ${PAGER}; }
alias rg='rg -i'

alias eg='env | grep -i'
alias rm='rm -i'
alias fort='echo "" ; fortune -e ; echo ""'
alias duf='sudo /usr/bin/du -d 1 -h'
alias h='history'
alias hg='history | grep -i'
alias gk='gitkraken'
alias i='ipython'
alias psh='source $(poetry env info --path)/bin/activate'
alias pos='poetry shell'

alias compress='ditto -c -k --sequesterRsrc --keepParent'
function du () { /usr/bin/du -sh $* | ${PAGER} }

format_stacktrace='grep --line-buffered -o '\''".\+[^"]"'\'' | grep --line-buffered -o '\''[^"]*[^"]'\'' | while read -r line; do printf "%b" $line; done | tr "\r\n" "\275\276" | tr -d "[:cntrl:]" | tr "\275\276" "\r\n"'


# ▜        ▜ ▗
# ▐ ▞▀▘ ▝▀▖▐ ▄ ▝▀▖▞▀▘▞▀▖▞▀▘
# ▐ ▝▀▖ ▞▀▌▐ ▐ ▞▀▌▝▀▖▛▀ ▝▀▖
#  ▘▀▀  ▝▀▘ ▘▀▘▝▀▘▀▀ ▝▀▘▀▀

if [[ -v BASH_VERSINFO ]]; then
    l_alias="$(type -t l)"
    ll_alias="$(type -t ll)"
elif [[ -v ZSH_VERSION ]]; then
    l_alias="$(whence -w l | cut -d ' ' -f 2)"
    ll_alias="$(whence -w ll | cut -d ' ' -f 2)"
fi

if [[ $l_alias == "alias" ]]; then unalias l; fi
if [[ $ll_alias == "alias" ]]; then unalias ll; fi

if [[ -x `which eza` ]]; then
    function eza_base () {
        # test if being piped
        if [[ -t 1 ]] ; then
            # eza fancy with icons
            # a - all
            # b - filesize with binary prefixes
            # g - list file's group
            # m - use 'modified' timestamp field
            # l - long
            # L1 - limit recursion
            eza -bgmlL1 --color-scale --color=always --icons=auto $* | less
        else
            # eza plain for working with pipes &etc.
            eza -gml --color=never --icons=auto $*
        fi
    }

    function l () { eza_base -aa $*; }
    function lt () { eza_base -aa --sort=modified $*; }
    function ltr () { eza_base -aa --sort=modified --reverse $*; }
    function ld () { eza_base -aaD $*; }

    function ll () { eza_base $*; }
    function llt () { eza_base --sort=modified $*; }
    function lltr () { eza_base --sort=modified --reverse $*; }
    function lld () { eza_base -D $*; }

    function lp () { fd -H -g "$*"; }
else
    # C list by columns
    # F classify indicator character
    # l long listing format
    # a all
    # G no group names
    # h human readable units
    # t sort by time, newsest first
    # r reverse sort order
    function l () { /bin/ls -CFlah $* | ${PAGER}; }
    function ls () { /bin/ls -CFh $* | ${PAGER}; }
    function ll () { /bin/ls -CFlh $* | ${PAGER}; }
    function lt () { /bin/ls -CFltrh $* | ${PAGER}; }
    function lta () { /bin/ls -CFlatrh $* | ${PAGER}; }
    function lp () { find `pwd` -name $*; }
fi


###########################
# brew aliases            #
###########################

function brupdate () {
    brew update
    brew upgrade
}

###########################
# .alias aliases          #
###########################

function ag () { fnd $* ~/.dotfiles/aliases.zsh }
alias sa='source ~/.dotfiles/aliases.zsh ; echo "alias file re-sourced!"'
alias va='vi ~/.dotfiles/aliases.zsh; sa'
alias vz='vi ~/.zshrc'
alias vb='vi ~/.bashrc'
alias vw='vi ~/.dotfiles/wezterm.lua'
alias ez='exec zsh'
#alias vqo       'vi $SCRIPTHOME/sig_quotes.txt'


###########################
# nix / fleet sync        #
###########################

# `switch` — rebuild this machine from ~/.dotfiles. Dispatches on the selected
# profile (~/.config/dotfiles/profile, or $DOTFILES_PROFILE) rather than the
# hostname, so no machine identity lives in this public repo. `darwin-*` profiles
# use home-manager, `linux-*` use nixos-rebuild. All builds pass `--impure` because
# the flake derives home.username from $USER (getEnv). Args pass through, e.g.
# `switch -b backup` or `switch --show-trace`.
#
# nom: when nix-output-monitor is installed, build through `nom build` FIRST for a
# live progress tree, then run the real switch — its internal build is then a cache
# hit, so it goes straight to activation. Costs one extra eval (~seconds); the heavy
# build/download happens once, under nom. The `{ ! command -v nom || nom build …; }`
# guard means: no nom → plain switch; nom build fails → stop before activating.
# (nixie stays nom-free on purpose — a quiet status probe, usually a no-op build.)
function switch() {
    local d="$HOME/.dotfiles" attr out
    local profile="${DOTFILES_PROFILE:-$(cat "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/profile" 2>/dev/null)}"
    if [ -z "$profile" ]; then
        echo "switch: no profile set — write one to ~/.config/dotfiles/profile (e.g. darwin-personal) or export DOTFILES_PROFILE" >&2
        return 1
    fi
    case "$profile" in
        linux-*)
            attr="nixosConfigurations.$profile.config.system.build.toplevel"
            { ! command -v nom >/dev/null 2>&1 || nom build --impure "$d#$attr" --no-link; } &&
                sudo nixos-rebuild switch --impure --flake "$d#$profile" "$@" ;;
        *)
            # Build the activation package ONCE (through nom for a live progress
            # tree when available) and run its activate script directly — one flake
            # eval instead of two (a bare `home-manager switch` re-evaluates). The
            # activate script does the real generation registration (nix-env --set)
            # itself. "$@" forwards to the build, so `switch --show-trace` still
            # works. No backup ext on purpose: a file collision errors and stops —
            # rare here (HM already owns its paths) and worth knowing about;
            # bootstrap.sh uses -b backup for first-run, where collisions are normal.
            attr="homeConfigurations.$profile.activationPackage"
            if command -v nom >/dev/null 2>&1; then
                out=$(nom build --impure "$d#$attr" --no-link --print-out-paths "$@") || return
            else
                out=$(nix build --impure "$d#$attr" --no-link --print-out-paths "$@") || return
            fi
            "$out/activate" ;;
    esac
    local rc=$?
    # After a successful rebuild, if we're inside tmux, reload the LIVE server so
    # a tmux.conf change lands now instead of only in the next fresh session. The
    # call is coming from inside the house on purpose: source-file is
    # non-destructive — it re-applies options and re-runs the plugin run-shell
    # lines, but does NOT kill the server. (Config is Nix-managed by programs.tmux
    # at ~/.config/tmux/tmux.conf.)
    if [[ $rc -eq 0 && -n "$TMUX" ]] && command -v tmux >/dev/null 2>&1; then
        tmux source-file "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
    fi
    return $rc
}

# `nixie` — where does THIS machine stand vs the shared config? (nix-check)
#   rebuild: built config vs active generation (a full eval — a few seconds)
#   push:    uncommitted / unpushed work the fleet can't see yet (git, free)
#   pull:    is origin ahead of me? (only with -f, which fetches — network)
# Reports this machine's standing vs the hub; can't know if others have pulled.
# Note: rebuild sees git-TRACKED state — `git add` new files first. push's
# "unpushed" count needs a tracking branch (gitup sets it).
function nixie() {
    local d="$HOME/.dotfiles" fetch=1
    [ "$1" = "-n" ] && fetch=0
    [ -d "$d/.git" ] || { echo "nixie: $d is not a git repo" >&2; return 1; }

    # rebuild axis — per profile (only the local eval is expensive)
    local rebuild
    local profile="${DOTFILES_PROFILE:-$(cat "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/profile" 2>/dev/null)}"
    case "$profile" in
        darwin-*)
            local built active
            built=$(nix build --no-link --print-out-paths --impure \
                "$d#homeConfigurations.$profile.activationPackage" 2>/dev/null)
            active=$(readlink -f ~/.local/state/nix/profiles/home-manager)
            [ "$built" = "$active" ] && rebuild="✓ up to date" \
                || rebuild="⚠ needed (built config ≠ active generation)" ;;
        linux-*) rebuild="– linux profile: use nixos-rebuild (M6+)" ;;
        *) rebuild="– no profile set (see ~/.config/dotfiles/profile)" ;;
    esac

    # push axis — git, free
    local dirty ahead push
    dirty=$(git -C "$d" status --porcelain 2>/dev/null | grep -c .)
    ahead=$(git -C "$d" rev-list --count '@{upstream}..HEAD' 2>/dev/null)
    { [ "${dirty:-0}" -eq 0 ] && [ "${ahead:-0}" -eq 0 ]; } \
        && push="✓ in sync with origin" || push="⚠ ${ahead:-0} ahead, ${dirty:-0} dirty"

    # pull axis — needs network, so opt-in
    local pull behind
    if [ "$fetch" -eq 1 ]; then
        git -C "$d" fetch --quiet 2>/dev/null
        behind=$(git -C "$d" rev-list --count 'HEAD..@{upstream}' 2>/dev/null)
        [ "${behind:-0}" -eq 0 ] && pull="✓ up to date" \
            || pull="⚠ ${behind} behind — pull + switch"
    else
        pull="– not checked"
    fi

    printf '~/.dotfiles:\n  rebuild  %s\n  push     %s\n  pull     %s\n' "$rebuild" "$push" "$pull"
}

# `nixup` — pull newer package versions by re-locking the flake, then rebuild and
# show what changed. No config editing: default.nix/shell.nix declare WHAT you
# have; flake.lock pins WHICH version, and this bumps the lock. Args pass through
# to `nix flake update`, so bare `nixup` updates every input and `nixup nixpkgs`
# bumps just nixpkgs. Reversible: if a bump misbehaves, `git -C ~/.dotfiles
# checkout flake.lock && switch` restores the old world. Uses switch() under the
# hood, so you get the nom progress tree and the profile-marker dispatch for free.
function nixup() {
    local d="$HOME/.dotfiles" before after
    [ -d "$d/.git" ] || { echo "nixup: $d is not a git repo" >&2; return 1; }
    before=$(readlink -f ~/.local/state/nix/profiles/home-manager 2>/dev/null)
    ( cd "$d" && nix flake update "$@" ) || return
    switch || return
    after=$(readlink -f ~/.local/state/nix/profiles/home-manager 2>/dev/null)
    echo
    if command -v nvd >/dev/null 2>&1 && [ -n "$before" ] && [ "$before" != "$after" ]; then
        nvd diff "$before" "$after"   # readable version-change list
    else
        echo "nixup: no package changes (generation unchanged)"
    fi
    printf '\nother update surfaces (not flake-managed):\n'
    printf '  brew upgrade               # Homebrew casks/formulae\n'
    printf '  mise upgrade               # go/node/rust/uv ("latest" pins)\n'
    printf '  nvim +"Lazy update" +qa    # nvim plugins (writes lazy-lock.json)\n'
    printf 'commit when happy: git -C %s add flake.lock && git -C %s commit\n' "$d" "$d"
}

# Startup nudge: warn if ~/.dotfiles has local work the fleet can't see yet.
# Free & offline — no fetch (that's `nixie -f`). Push axis only. Called from zshrc.
function _nixie_hint() {
    local d="$HOME/.dotfiles"
    [ -d "$d/.git" ] || return 0
    local dirty ahead parts=""
    dirty=$(git -C "$d" status --porcelain 2>/dev/null | grep -c .)
    ahead=$(git -C "$d" rev-list --count '@{upstream}..HEAD' 2>/dev/null)
    [ "${dirty:-0}" -gt 0 ] && parts="${dirty} uncommitted"
    if [ "${ahead:-0}" -gt 0 ]; then
        [ -n "$parts" ] && parts="${parts} + "
        parts="${parts}${ahead} unpushed"
    fi
    [ -n "$parts" ] && printf '\033[33m⚠ ~/.dotfiles: %s — push to sync the fleet\033[0m\n' "$parts"
}


###########################
# Alfred Things           #
###########################

# alfred workflow name getter
function alf () {
    for name in $(/bin/ls ${HOME}/workflows/); do
        awk 'c&&!--c;/<key>name<\/key>/{c=1}' \
            ${HOME}/workflows/${name}/info.plist |\
            sed -E 's/^.*<string>(.*)<\/string>.*$/\1/'
    done
}

###########################
# Doing Things            #
###########################

alias tm='tmux attach -d'

function vlc () {
     /Applications/VLC.app/Contents/MacOS/VLC -f $*
}

if [[ $(uname) == "Darwin" ]]; then
    function it2prof() { echo -e "\033]50;SetProfile=$1\a" }
    alias godark='it2prof gruvbox-dark'
    alias golight='it2prof gruvbox-light'

    # macOS ships /usr/bin/jq (1.7.1, SIP-locked) ahead of ~/.nix-profile on
    # PATH, so point interactive `jq` at the newer Nix build. Interactive only —
    # aliases aren't inherited by scripts; when a script must use the Nix jq,
    # call ~/.nix-profile/bin/jq explicitly (as you would /bin/ls for that exact
    # binary). See the jq notes in home/tonye/default.nix + nix-9zy.
    alias jq="$HOME/.nix-profile/bin/jq"

    # Brew's neovim wins bare `nvim` on PATH (the neovide-app cask hard-depends
    # on it, so it stays) — pin interactive `nvim` to the reproducible Nix build
    # as a hedge against brew drift. ~/.nix-profile/bin/nvim is the active
    # generation's nvim (self-updates on switch; identical path on the VM). `vi`
    # (aliased to `nvim` at the top of this file) chains here via zsh's recursive
    # alias expansion, so it follows for free. $EDITOR is set to the same absolute
    # path in zshrc, so git commits etc. use Nix nvim too. Remaining gap: a bare
    # `nvim` inside a script/function bypasses this alias and PATH-resolves to
    # brew's — call ~/.nix-profile/bin/nvim explicitly there if it matters.
    alias nvim="$HOME/.nix-profile/bin/nvim"
fi

function ka() { kill -9 $(pgrep -i $*) }

function archive () {
    archive_dir=${1%/}
    mkdir -p archived
    tar cfz archived/$archive_dir.tgz $archive_dir/
    rm -rf $archive_dir
}

function mklist() {
    find ./$1/ -iname '*.zip' |rev| cut -d '/' -f 1 | rev | uniq | sort  > $1.txt
}

function tailformat () {
    cat $1 | python -m json.tool
    inotifywait -q -m -e close_write --format %e $1 |
    while read events; do
        cat $1 | python -m json.tool
    done
}

function taildiff () {
    /usr/bin/cat $1 | python -m json.tool >| /tmp/a_foo
    inotifywait -q -m -e close_write --format %e $1 |
    while read events; do
        /usr/bin/cat $1 | python -m json.tool >| /tmp/b_foo
        git diff -U0 --word-diff=color --word-diff-regex=. /tmp/a_foo /tmp/b_foo
        /usr/bin/cat $1 | python -m json.tool >| /tmp/a_foo
    done
    rm -f /tmp/a_foo
    rm -f /tmp/b_foo
}

function today() {
    local week=$(date "+%W")
    local year=$(date "+%Y")
    local week_num_of_Jan_1 week_day_of_Jan_1
    local first_Mon
    local date_fmt="+%Y%m%d"
    local mon sun

    week_num_of_Jan_1=$(date -d $year-01-01 +%W)
    week_day_of_Jan_1=$(date -d $year-01-01 +%u)

    if ((week_num_of_Jan_1)); then
        first_Mon=$year-01-01
    else
        first_Mon=$year-01-$((01 + (7 - week_day_of_Jan_1 + 1) ))
    fi

    mon=$(date -d "$first_Mon +$((week - 1)) week" "$date_fmt")
    sun=$(date -d "$first_Mon +$((week - 1)) week + 6 day" "$date_fmt")
    #echo "\"$mon\" - \"$sun\""
    echo $HOME/weeklyreports/$year/${mon}_weeklyreport.md
    nvim $HOME/weeklyreports/$year/${mon}_weeklyreport.md
}

function vf () {
    file=$(${FZF_ALT_C_COMMAND}|fzf)
    if [ $? -eq 0 ]; then
      echo "git status exited successfully"
    else
      echo "git status exited with error code"
    fi
}


###########################
# Doing Connecty Things   #
###########################

###########################
# Doing Shotgun Things    #
###########################

alias webrick='cd /usr/local/shotgun/shotgun/.idea/runConfigurations/ ; git checkout Shotgun_Server__WEBrick_.xml ; cd /usr/local/shotgun/shotgun; /usr/bin/open /Applications/IntelliJ\ IDEA.app/'
alias sg='cd ~/shotgun/shotgun'
alias lc='~/shotgun/enterprise-toolbox/troubleshooting/log_chop.rb'

function crop () {
    unset name
    unset ext
    unset begin
    unset finish
    unset filename
    name=$(echo "$1" | cut -f 1 -d '.')
    ext=$(echo "$1" | cut -f2-  -d '.')
    begin="${2//:/_}"
    begin="${begin// /_}"
    finish="${3//:/_}"
    finish="${finish// /_}"
    filename="${name}_${begin}_to_${finish}.${ext}"
    echo "reading $1, from $2 to $3"
    start=$(grep -n $2 $1 | head -n 1 | cut -f 1 -d ':')
    echo "start line: $start"
    stop=$(grep -n $3 $1 | head -n 1 | cut -f 1 -d ':')
    echo "end line:   $stop"
    echo "output: $filename.gz"
    gawk -v start="$start" -v stop="$stop" 'NR >= start && NR <= stop' $1 | gzip -v - > $filename.gz
}

function zcrop () {
    unset name
    unset ext
    unset begin
    unset finish
    unset filename
    name=$(echo "$1" | cut -f 1 -d '.')
    ext=$(echo "$1" | cut -f2-  -d '.')
    begin="${2//:/_}"
    begin="${begin// /_}"
    finish="${3//:/_}"
    finish="${finish// /_}"
    filename="${name}_${begin}_to_${finish}.${ext}"
    echo "name $name begin $begin finish $finish filename $filename"
    echo "reading $1, from $2 to $3"
    start=$(zgrep -n "$2" $1 | head -n 1 | cut -f 1 -d ':')
    echo "start line: $start"
    stop=$(zgrep -n "$3" $1 | head -n 1 | cut -f 1 -d ':')
    echo "end line:   $stop"
    echo "output: $filename"
    gawk -v start="$start" -v stop="$stop" 'NR >= start && NR <= stop' <(gzip -dc $1) | gzip -v - > $filename
}


###########################
# Doing Git Things        #
###########################

# gw - Git Worktree switcher
function gw() {
    local worktrees worktree_list selection worktree_path exit_code

    # Get list of worktrees, excluding the header line
    worktrees=$(git worktree list --porcelain 2>/dev/null)
    exit_code=$?

    if [[ $exit_code -ne 0 ]]; then
        echo "Not a git repository"
        return 1
    fi

    # Parse worktree list into an array of "path branch" pairs
    worktree_list=()
    local current_path="" current_branch=""

    while IFS= read -r line; do
        if [[ $line =~ ^worktree\ (.+)$ ]]; then
            current_path="${match[1]}"
        elif [[ $line =~ ^branch\ refs/heads/(.+)$ ]]; then
            current_branch="${match[1]}"
        elif [[ $line =~ ^detached$ ]]; then
            current_branch="(detached HEAD)"
        elif [[ -z $line && -n $current_path ]]; then
            worktree_list+=("$current_path|$current_branch")
            current_path=""
            current_branch=""
        fi
    done <<< "$worktrees"

    # Add last worktree if exists
    if [[ -n $current_path ]]; then
        worktree_list+=("$current_path|$current_branch")
    fi

    # Check if we only have main/master worktree
    if [[ ${#worktree_list[@]} -le 1 ]]; then
        echo "No additional worktrees exist besides the main branch"
        return 0
    fi

    # Use fzf if available, otherwise use numbered menu
    if command -v fzf &> /dev/null; then
        # Format for fzf display: "branch (worktree_path)"
        local display_list=()
        for entry in "${worktree_list[@]}"; do
            worktree_path="${entry%|*}"
            branch="${entry#*|}"
            display_list+=("$branch ($worktree_path)")
        done

        selection=$(printf "%s\n" "${display_list[@]}" | fzf --height=40% --border --prompt="Select worktree: ")

        if [[ -n $selection ]]; then
            # Extract worktree_path from selection (format: "branch (path)")
            worktree_path="${selection#*\(}"
            worktree_path="${worktree_path%\)}"
            cd "$worktree_path"
        fi
    else
        # Numbered menu
        echo "Git worktrees:"
        local i=1
        for entry in "${worktree_list[@]}"; do
            worktree_path="${entry%|*}"
            branch="${entry#*|}"
            echo "$i) $branch ($worktree_path)"
            ((i++))
        done

        echo -n "Select worktree (1-${#worktree_list[@]}): "
        read choice

        if [[ $choice =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -le ${#worktree_list[@]} ]]; then
            entry="${worktree_list[$choice]}"
            worktree_path="${entry%|*}"
            cd "$worktree_path"
        else
            echo "Invalid selection"
            return 1
        fi
    fi
}

# git: get branch name
alias gbn='git rev-parse --abbrev-ref HEAD'
# git: get tag name
alias ggt='git describe --abbrev=0 --tags'
# shallow pull for a dir of repos
alias gpull='find . -maxdepth 1 -type d -exec sh -c "(cd {} && echo {} && git pull)" ";"'
# fetch and pull
alias fep='git fetch; git pull'
# git: push <branch name>
alias gpcb='git push origin `gbn`'
# git: set upstream relationship
alias gitup='git push --set-upstream origin `gbn`'
# git: push tag up to origin
alias gpt='git push origin `ggt`'
# git: delete tag from branch
alias gdt='git push origin :refs/tags/`ggt`; git tag --delete `ggt`'
# git: git grep with context
alias gg='git grep -pin --break --heading -C 3'
# git: git grep with context and no index if not in a repo
alias gig='git grep --no-index -p -in --break --heading -1'
# git: git grep with context and case sensitivity
alias ggs='git grep -p -n --break --heading -1'
# git: git grep with context, but regex patterns instead of case sensitivity
alias egg='git grep -p -En --break --heading -1'
# git: grep in the git log (for ticket numbers, usually)
function glg () { git log --grep=$*; }
# git: grep through branch names
alias ggb='git branch -a |grep'
# git: checkout
alias gc='git checkout'
# git: switch branch
alias gcb='dstop; git checkout'
#git: cherry-pick
alias gcp='git cherry-pick'
#git: show verbose log for commit
alias gspf='git show --pretty=fuller'
#git: get current status
alias gs='git status'
#git: self explanatory :)
alias gb='git branch'
#git: tag a branch
alias gt='git tag'
#git: list files touched in each stash commit
alias gsl='git stash list --stat'

# git: grep a tag and get its creation date
function gtg () {
    git log --date-order --tags --simplify-by-decoration --pretty=format:'%ai %h %d' | grep $*
}

# git: show tag timeline with branching
function gtt() {
    git log --date-order --graph --tags --simplify-by-decoration --pretty=format:'%ai %h %d'
}

# git: vim edit all changed files
alias gvi='~/scripts/vim_changed_files_git.rc'

function ggc () {
    fzf_args=""
    if [[ $# -gt 0 ]]; then
        fzf_args="-q $*"
    fi
    local branchname=$(git branch -l | sed 's/[ \*]//g' | fzf ${fzf_args})
    git checkout ${branchname}
}


###########################
# Doing Docker Things     #
###########################

# this function provides tag functionality in order to work with
# multiple containers at once when changing branches
# function dc-opts () {
    # # zparseopts -D -E -A Args -- v
    # if (( ${+Args[-v]} )); then
        # docker-compose $*
    # else
        # docker-compose -p \"$(git rev-parse --abbrev-ref HEAD)\" $*
    # fi
# }

function dc-opts () {
    docker-compose $*
}
# list containers
alias dps='docker ps -a'
# build app
alias dbuild='dc-opts build app'
# start docker and follow logs
alias dup='dc-opts up -d app'
# follow logs
alias dl='dc-opts logs -f app'
# stop containers, don't delete anything
alias dstop='dc-opts stop app smtp db memcached'
# stop EVERYTHING
alias dfire='docker stop $(docker ps -aq); docker rm $(docker ps -q -f status=exited)'
# restart from scratch, only delete database
alias ddel='dc-opts down'
# restart from scratch, delete db and volumes
alias dnuke='dc-opts down -v'
# restart passenger to quickly reload app code
alias dres='dc-opts exec app passenger-config restart-app /var/rails/shotgun'
# run unit tests
alias drake='dc-opts run --rm app rake test:units'
# build SCSS
alias dscss='dc-opts run --rm app npm run build_css'
# run linting tests
alias dlint='dc-opts run --rm app npm run lint:js'
# run rubocop tests
alias drubocop='dc-opts run --rm app rubocop'
# get into pgsql
alias dpsql='dc-opts run --rm app bash; psql'
# It's better to use docker-compose run to get the right user and environment
# variables. There is the exec command to use if a shell inside the running
# container is needed.
alias dsh='dc-opts exec app /docker-entrypoint.sh bash'
alias droot='docker-compose exec app bash'
# start transcoder and worker containers
alias dtrans='dc-opts up -d'
# look at sent email
alias dmail='open http://localhost:1080'

#################################
# doing claude things           #
#################################

function cl() { claude --allow-dangerously-skip-permissions $*; }
function cr() { claude --allow-dangerously-skip-permissions --resume $*; }


# Machine-local alias overlay: extra aliases live in the ~/.undisclosed overlay and
# load last so they can add to or override the above — absent elsewhere, a silent
# no-op. At the tail of this file, so `sa` (re-source aliases) reloads it too.
[ -f ~/.undisclosed/aliases.local ] && source ~/.undisclosed/aliases.local
