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
elif [ ! -z $VIM_CMD ]; then
    alias vi='vim'
elif [ ! -z $VI_CMD ]; then
    alias vi='vi'
else
    echo "Can't find vim or vi! What the hell, man?"
fi

alias rm='rm -i'
alias m=$PAGER
alias fort='echo "" ; /usr/games/fortune -e ; echo ""'
alias duf='sudo /usr/bin/du -d 1 -h'
alias h='history'
alias hg='history | grep -i'
alias lo='logout'
alias xv='xnview'

function du () { /usr/bin/du -sh $* | less }
function l () { /bin/ls -CFlaG $* | less }

############################
# ls aliases               #
############################

function l () { /bin/ls -CFlaG $* | less }
function ls () { /bin/ls -CFG $* | less }
function ll () { /bin/ls -CFlG $* | less }
function lt () { /bin/ls -CFltrG $* | less }
function lsd () { /bin/ls -CFlG $* | grep \/ }
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
alias mdiff='/Applications/IntelliJ\ IDEA.app/Contents/MacOS/idea diff'
alias vu='vagrant up --provision'
alias vh='vagrant halt'
function it2prof() { echo -e "\033]50;SetProfile=$1\a" }
alias godark='it2prof gruvbox-dark'
alias golight='it2prof gruvbox-light'

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
alias gg='git grep -n --break --heading -1 -p'
# git: grep in the git log (for ticket numbers, usually)
alias glg='git log |grep'
# git: grep through branch names
alias ggb='git branch -a |grep'
# git: checkout branch
alias gc='git checkout'
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
# git: vim edit all changed files
alias gvi='~/scripts/vim_changed_files_git.rc'


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

# docker-compose
alias dc='docker-compose'
# start docker and follow logs
alias dup='docker-compose up -d app && docker-compose logs -f app'
# stop app
alias dstop='docker-compose stop app'
# restart from scratch, only delete database
alias ddown='docker-compose down'
# restart from scratch, delete db and volumes
alias ddel='docker-compose down -v'
# after switching branches, build and restart from fresh db
alias dnuke='docker-compose down -v; docker-compose build app; docker-compose up -d app'
# restart passenger to quickly reload app code
alias dres='docker-compose exec app passenger-config restart-app /var/rails/shotgun'
# run unit tests
alias drake='docker-compose run --rm app bash; rake test:units'
# build SCSS
alias dscss='docker-compose run --rm app bash; npm run build_css'
# run linting tests
alias dlint='docker-compose run --rm app npm run lint:js'
# run rubocop tests
alias drubocop='docker-compose run --rm app rubocop'
# get into pgsql
alias dpsql='docker-compose run --rm app bash; psql'
# It's better to use docker-compose run to get the right user and environment
# variables. There is the exec command to use if a shell inside the running
# container is needed.
alias dsh='docker-compose exec app /docker-entrypoint.sh bash'
# start transcoder and worker containers
alias dtrans='docker-compose up -d'
# look at sent email
alias dmail='open http://localhost:1080'

#######################

source ~/.sshes
source ~/.oh-my-zsh/custom/sg_helpers.zsh

