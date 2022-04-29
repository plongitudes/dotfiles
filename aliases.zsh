###########################
# General                 #
###########################

# for sysV flavors like centos and RHEL,
# let's get color into ls
if [[ "$(uname)" == "Linux" ]]; then
    alias ls='/bin/ls --color'
fi

# find the proper installation of vim
NVIM_CMD=$(command -v nvim 2>/dev/null)
VIM_CMD=$(command -v vim 2>/dev/null)
VI_CMD=$(command -v vi 2>/dev/null)

if [ ! -z $NVIM_CMD ]; then
    alias vi='nvim'
    alias li='vi -c "set background=light"'
elif [ ! -z $VIM_CMD ]; then
    alias vi='vim'
elif [ ! -z $VI_CMD ]; then
    alias vi='vi'
else
    echo "Can't find vim or vi! What the hell, man?"
fi

alias rm='rm -i'
alias m='$PAGER -M'
alias fort='echo "" ; /usr/games/fortune -e ; echo ""'
alias duf='sudo /usr/bin/du -d 1 -h'
alias h='history'
alias hg='history | grep -i'
alias lo='logout'
alias xv='xnview'

function du () { /usr/bin/du -sh $* | m }
function l () { /bin/ls -CFlaG $* | m }

############################
# ls aliases               #
############################

unalias l
unalias ll
function l () { /bin/ls -CFlaGh $* | m }
function ls () { /bin/ls -CFGh $* | m }
function ll () { /bin/ls -CFlGh $* | m }
function lt () { /bin/ls -CFltrGh $* | m }
function lsd () { /bin/ls -CFlGh $* | grep -e '^d' }
function lg () { ll * | grep -i $* }
function lp () { find `pwd` -name $* }

###########################
# .alias aliases          #
###########################

function ag () { grep -i $* ~/.oh-my-zsh/custom/aliases.zsh }
alias sa='source ~/.oh-my-zsh/custom/aliases.zsh ; echo "alias file re-sourced!"'
alias va='vi ~/.oh-my-zsh/custom/aliases.zsh; sa'

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
alias sf='sudo chown -R tonye:tonye /media/space/transmission/complete/*'
alias irb='pry'
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
alias eg='cd /opt/etiennt/git'
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

#function crop () {
    #echo "reading $1, from $2 to $3"
    #start=$(grep -n $2 $1 | head -n 1 | cut -f 1 -d ':')
    #echo "start line: $start"
    #end=$(grep -n $3 $1 | head -n 1 | cut -f 1 -d ':')
    #echo "end line:   $end"
    #gawk -v start="$start" -v end="$end" 'NR >= start && NR <= end' $1 | gzip -v - > output.log.gz
#}
#
#function zcrop () {
    #echo "reading $1, from $2 to $3"
    #start=$(zgrep -n $2 $1 | head -n 1 | cut -f 1 -d ':')
    #echo "start line: $start"
    #end=$(zgrep -n $3 $1 | head -n 1 | cut -f 1 -d ':')
    #echo "end line:   $end"
    #gawk -v start="$start" -v end="$end" 'NR >= start && NR <= end' <(gzip -dc $1) | gzip -v - > output.log.gz
#}


###########################
# Doing Git Things        #
###########################

# git: get branch name
alias gbn='git rev-parse --abbrev-ref HEAD'
# git: get tag name
alias ggt='git describe --abbrev=0 --tags'

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

###########################
# Doing Virtualbox Things #
###########################

function vmreset () {
    VBoxManage controlvm "centOS minimal cleanroom" poweroff; sleep 1
    VBoxManage snapshot "centOS minimal cleanroom" restore "step zero"; sleep 1
    VBoxManage startvm "centOS minimal cleanroom"
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

###########################
# Doing venv Things       #
###########################

function upsearch() {
  local slashes=${PWD//[^\/]/}
  directory="$PWD"
  for (( n=${#slashes}; n>0; --n ))
  do
    test -e "$directory/$1" && return
    directory="$directory/.."
  done
  directory=`realpath -L "$directory"`
}

function chpwd() {
    # Make sure the appropriate Python venv is automatically activated.
    upsearch ".venv"

    if [ "$directory" = "/" ]; then
        if [[ -v VIRTUAL_ENV ]]; then
            deactivate
        fi

        return
    fi

    if [[ "$directory/.venv" == $VIRTUAL_ENV ]]; then
        return
    fi

    source "$directory/.venv/bin/activate"
}

alias ve='python -m venv .venv'

#######################

source ~/.oh-my-zsh/custom/sg_helpers.zsh

