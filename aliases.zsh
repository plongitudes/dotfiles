###########################
# General                 #
###########################

NVIM_CMD=$(type -p vi 2>/dev/null)
VIM_CMD=$(type -p vim 2>/dev/null)
VI_CMD=$(type -p nvim 2>/dev/null)

if [ ! -z $NVIM_CMD ]; then
    alias vi='nvim'
elif [ ! -z $VIM_CMD ]; then
    alias vi='vim'
else
    msg_user "Can't find vi! What the hell, man?"
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
alias sa='source ~/.oh-my-zsh/custom/aliases.zsh ; echo "" ; echo "alias file re-sourced!" ; echo ""'
alias va='vi ~/.oh-my-zsh/custom/aliases.zsh'

###########################
# Finding files           #
###########################

function fnd () { find -L . -print -type f -exec grep -n $* {} \; | grep $* -B 1 }
#alias f='iname \!*'

#alias never     'ssh -l tony neverest.spundreams.net'
#alias vqo       'vi $SCRIPTHOME/sig_quotes.txt'
#alias hack      'telnet nethack.alt.org '
#function dos       '~/local/bin/dosbox \!* &'
#alias play      'cd ~/.www/nonpublic/snes ; zsnes &'
#function bt        'bittorrent-curses --minport 44730 --maxport 44739 --max_upload_rate 7 \!*'

#alias mame      'sudo mount -t smbfs //legends/d$ /media/mame -o credentials=/root/.smbcredentials'

#alias tun       'ssh -p 21577 -N -D 7070 moongate.bouncelimit.org'
#alias bigf  'ssh -p 20693 bigfeather'
#alias bigf      'ssh tonye@bigfeather'
#alias minoc     'ssh tonye@minoc.tonyetienne.com'
#alias codex     'ssh -i ~/.ssh/codex.key ubuntu@codex2.maradine.com'
alias home='ssh -p 8822 tonye@bouncelimit.org'
#alias ebot      'ssh marvinbot@moongate.bouncelimit.org'
alias oldhome='ssh tonye@192.168.1.7'
alias getip='wget -q -O - checkip.dyndns.org'

alias wakeup='wakeonlan -i 192.168.1.255 -p 9 00:1f:5b:30:51:ec'


###########################
# Doing Things            #
###########################

alias tm='tmux attach -d'
alias tran='transmission-remote-cli'
alias sf='sudo chown -R tonye:tonye /media/space/transmission/complete/*'
alias irb='pry'
alias gpull='find . -maxdepth 1 -type d -exec sh -c "(cd {} && git pull)" ";"'
alias mdiff='/Applications/IntelliJ\ IDEA.app/Contents/MacOS/idea diff'
alias vu='vagrant up --provision'
alias vh='vagrant halt'

###########################
# Doing Ruby Things       #
###########################

function ppr () { echo '$*' | jsonf | pygmentize -l json }

###########################
# Doing Shotgun Things    #
###########################

alias webrick='cd /usr/local/shotgun/shotgun/.idea/runConfigurations/ ; git checkout Shotgun_Server__WEBrick_.xml ; cd /usr/local/shotgun/shotgun; /usr/bin/open /Applications/IntelliJ\ IDEA.app/'
alias sg='cd /usr/local/shotgun/shotgun'
alias eg='cd /opt/etiennt/git'

###########################
# Doing Github Things     #
###########################

# git push <branch name>
alias gpcb='git push origin `git rev-parse --abbrev-ref HEAD`'
# vim edit all changed files
alias gvi='~/scripts/vim_changed_files_git.rc'
# get tag name
alias ggt='git describe --abbrev=0 --tags'
# delete tag from branch
alias rtcb='git push origin :refs/tags/`git describe --abbrev=0 --tags`; git tag --delete `git describe --abbrev=0 --tags`'
# git grep with context
alias gg='git grep -n --break --heading -1 -p'
# grep in the git log (for ticket numbers, usually)
alias glg='git log |grep'
# grep through branch names
alias ggb='git branch -a |grep'
alias gc='git checkout'
alias gs='git status'
alias gb='git branch'
alias gt='git tag'

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

# start docker and follow logs
alias dup='docker-compose up -d app && docker-compose logs -f app'
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

