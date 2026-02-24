#!/usr/bin/env zsh

function find_in_zsh_manpages() {
    dirs_to_search = `echo ${MANPATH}`

    for dir in dirs_to_search; do
        rg $argv1 $dir

    for manpage in zsh_man_page_list; do
         man $ZMP | rg 'CONDITIONAL'
    done

    select ip in $(cat server.list); do 
       echo $REPLY $ip
    done
}
