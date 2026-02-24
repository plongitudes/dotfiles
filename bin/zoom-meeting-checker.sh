#!/usr/bin/env bash

# 2025/06/01
# v0.9.0
# requires: ~/.ha_webhook_url containing the full webhook URL
# raw cmdline:
# curl -X POST -H "Content-Type: application/json" -d 'false' "$HA_WEBHOOK_URL"

# add to task scheduler:
# trigger:
#    begin: At log on
#    specific user (you)
#    stop if running longer than 12 hours
# actions:
#    action: start a program
#    program: cmd.exe
#    args: /c /c start /min "" powershell -windowstyle hidden -noprofile -File "G:\My Drive\.dotfiles\bin\zoom-detect.ps1"
# notes:
#    as of this writing, powershell takes ~750ms to run, pwsh takes about ~840ms.

# load webhook URL from file or environment
HA_WEBHOOK_URL="${HA_WEBHOOK_URL:-$(< ~/bin/.ha_webhook_url)}"
if [[ -z "$HA_WEBHOOK_URL" ]]; then
    echo "error: set HA_WEBHOOK_URL or create ~/.ha_webhook_url"
    exit 1
fi

# hit the home assistant webhook to turn the sign on or off
function set_on_air() {
    # TODO: if we need to talk to home assistant, ask what the light's status is
    #get_sign_status()

    if [[ $1 -eq 0 ]]; then
        payload="false"
    elif [[ $1 -eq 1 ]]; then
        payload="true"
    fi

    curl --silent --request POST --data $payload "$HA_WEBHOOK_URL"
    echo $1 > /tmp/on_air
}

function get_sign_status() {
    true
}

function check_and_report() {
    # count the number of UDP zoom endpoints that are active (usually 4 if no meetings are taking place, but this
    # number needs testing) and reports back to home assistant to turn "on air" sign on or off depending on the state
    # of a zoom call.)

    # get the current state if we know it
    if [[ ! -f /tmp/on_air ]]; then
        # echo "creating temp file"
        echo 0 > /tmp/on_air
    fi

    export ON_AIR=$(</tmp/on_air)

    # count the actual endpoints in use
    zoom_udp_count=$(/usr/sbin/lsof -i 4UDP | grep zoom | wc -l | awk '{$1=$1};1')

    if [[ ($zoom_udp_count -gt 0) && ($ON_AIR -eq 0) ]]; then
        # echo "zoom threads: $zoom_udp_count and light is off, turning on"
        # echo "true: on air was: $ON_AIR"
        set_on_air 1
        # echo "true: on air is now: $ON_AIR"
    elif [[ ($zoom_udp_count -lt 1) && ($ON_AIR -eq 1) ]]; then
        # echo "zoom threads: $zoom_udp_count and light is on, turning off"
        # echo "false: on air was: $ON_AIR"
        set_on_air 0
        # echo "false: on air is now: $ON_AIR"
    fi
}

# only run if zoom is also up and about
if [[ $(pgrep zoom) ]]; then
    check_and_report
    sleep 25
    check_and_report
fi
