###########################
# General                 #
###########################

# find and use drop-in replacements like bat, ripgrep, etc if installed
for CMD in "cat ls vi vim nvim asdf batg man"; do
  unalias $CMD 2>/dev/null
done

alias cat="bat"
alias vi="nvim"
alias asdf="rtx"
alias grep="batgrep -iSC3"
alias man="batman"

alias rm='rm -i'
alias fort='echo "" ; /usr/games/fortune -e ; echo ""'
alias duf='sudo /usr/bin/du -d 1 -h'
alias hg='history | grep -i'

function vf () { vi $(fzf -q $* ); }
function du () { /usr/bin/du -sh $* | ${PAGER} }

format_stacktrace='grep --line-buffered -o '\''".\+[^"]"'\'' | grep --line-buffered -o '\''[^"]*[^"]'\'' | while read -r line; do printf "%b" $line; done | tr "\r\n" "\275\276" | tr -d "[:cntrl:]" | tr "\275\276" "\r\n"'
#strace -e trace=read,write,recvfrom,sendto -s 4096 -fp $(pgrep -n php) 2>&1 | format-strace

############################
# env aliases              #
############################

alias eg='env | grep -i'

############################
# ls aliases               #
############################

unalias l 2>/dev/null
unalias ll 2>/dev/null

if [[ -x `which eza` ]]; then
    function eza_base () {
        # test if being piped
        if [ -t 1 ] ; then
            # eza fancy with icons
            echo "i'm not in a pipe!"
            ${EZA_HOME} -lFgTL1 --git --color=always --icons $*
        else
            # eza plain for working with pipes &etc.
            echo "fuck, i'm in a pipe?"
            ${EZA_HOME} -lFg --git --color=never --no-icons $*
        fi
    }

    function ll () { eza_base -a $*; }
    function llt () { eza_base -a --sort=modified $*; }
    function lltr () { eza_base -a --sort=modified --reverse $*; }
    function lld () { eza_base -aD $*; }

    function l () { eza_base $*; }
    function lt () { eza_base --sort=modified $*; }
    function ltr () { eza_base --sort=modified --reverse $*; }
    function ld () { eza_base -D $*; }

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
# nvim aliases            #
###########################

vl='nvim --listen localhost:9999'

###########################
# .alias aliases          #
###########################

function ag () { grep -i $* ~/.oh-my-zsh/custom/aliases.zsh }
alias sa='source ~/.dotfiles/aliases.zsh ; echo "alias file re-sourced!"'
alias va='vi ~/.dotfiles/aliases.zsh; sa'
alias vv='vi ~/.vimrc'
alias vz='vi ~/.zshrc'


###########################
# Finding files           #
###########################

function fnd () { find -L . -print -type f -exec grep -n $* {} \; | grep $* -B 1 }
#alias f='iname \!*'

#alias vqo       'vi $SCRIPTHOME/sig_quotes.txt'


###########################
# Doing Things            #
###########################

alias tm='tmux attach -d'
alias tran='transmission-remote-cli'
alias gpull='find . -maxdepth 1 -type d -exec sh -c "(cd {} && echo {} && git pull)" ";"'
function mdiff() { /Applications/Xcode.app/Contents/Applications/FileMerge.app/Contents/MacOS/FileMerge -left $1 -right $2 }
alias vu='vagrant up --provision'
alias vh='vagrant halt'
function it2prof() { echo -e "\033]50;SetProfile=$1\a" }
alias godark='it2prof gruvbox-dark'
alias golight='it2prof gruvbox-light'
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

###########################
# Doing Ruby Things       #
###########################

function ppr () { echo '$*' | jsonf | pygmentize -l json }

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

# git: get branch name
alias gbn='git rev-parse --abbrev-ref HEAD'
# git: get tag name
alias ggt='git describe --abbrev=0 --tags'

# git: fetch and pull
alias fp='git fetch;git pull'
# git: push <branch name>
alias gpcb='git push origin `gbn`'
# git: set upstream relationship
alias gitup='git push --set-upstream origin `gbn`'
# git: push tag up to origin
alias gpt='git push origin `ggt`'
# git: delete tag from branch
alias gdt='git push origin :refs/tags/`ggt`; git tag --delete `ggt`'
# git: git grep with context
alias gg='git grep -in --break --heading -1 -p'
# git: grep in the git log (for ticket numbers, usually)
alias glg='git log |grep'
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
#git: grep a tag and get its creation date
function gtg () {git log --date-order --tags --simplify-by-decoration --pretty=format:'%ai %h %d' | grep $* }
#git: show tag timeline with branching
function gtt() {git log --date-order --graph --tags --simplify-by-decoration --pretty=format:'%ai %h %d' }
# git: vim edit all changed files
alias gvi='~/scripts/vim_changed_files_git.rc'
function bs () {
    branches=`git branch | grep -i $1`
    branches=${branches//\*/}
    if test $(wc -w <<< "$branches") -eq 1; then
        echo "SINGLE branch matched: Checking it out."
        git checkout $branches
        exit
    fi
    select branch in $branches; do
        [ -z "$branch" ] && echo "No branch selected (choose a number)" || git checkout $branch
        exit
    done
}

#alias DONOTDOTHIS='sh -c "$(curl -fsSL https://raw.githubusercontent.com/plongitudes/dotfiles/master/omz_bootstrap.sh)"'

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

