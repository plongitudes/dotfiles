#!/usr/bin/env python

import subprocess
import json
import sys
from workflow import Workflow

def _scan_aps():
    airport = "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport"
    proc = subprocess.Popen(['./blueutil', '--paired', '--format=JSON'], stdout=subprocess.PIPE)

    devices_raw = json.loads(proc.stdout.read())
    bluetooth_devices = []


def main(wf):
    if wf.update_available:
        wf.add_item('Update available for Bluetooth Connector!',
                    autocomplete='workflow:update',
                    valid=False)

    #query = wf.args[0] if len(wf.args) else None
    args = wf.args
    devices = _read_devices()

    filtered_devices = wf.filter(query, devices, key=lambda k: k['title'])

    for device in filtered_devices:
        item = wf.add_item(
            type=device['type'],
            title=device['title'],
            subtitle=device['subtitle'],
            arg=device['arg'],
            icon=device['icon'],
            valid=True
        )

        item.setvar('title', device['title'])

    wf.send_feedback()
