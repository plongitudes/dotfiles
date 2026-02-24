# 2025/05/31
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
$webhookFile = Join-Path $env:USERPROFILE "bin/.ha_webhook_url"
if ($env:HA_WEBHOOK_URL) {
    $global:ha_webhook_url = $env:HA_WEBHOOK_URL
} elseif (Test-Path $webhookFile) {
    $global:ha_webhook_url = (Get-Content $webhookFile -Raw).Trim()
} else {
    Write-Error "Set HA_WEBHOOK_URL or create ~/.ha_webhook_url"
    exit 1
}

function set_on_air($payload) {
    $params = @{
        Uri = $global:ha_webhook_url
        Method = "Post"
        ContentType = "application/json"
        Body = "false"
    }

    if ($payload) {
        $params["Body"] = "true"
    }

    $global:on_air = $payload

    Invoke-WebRequest @params
}
function check_and_report() {
    # count the number of UDP zoom endpoints that are active (usually 4 if no meetings are taking place, but this
    # number needs testing) and reports back to home assistant to turn "on air" sign on or off depending on the state
    # of a zoom call.)

    $num_udp_endpoints = 0

    # count the actual endpoints in use
    if ($zoomProcess = Get-Process -Name Zoom -EA 0) {
        $num_udp_endpoints = (Get-NetUDPEndpoint -OwningProcess $zoomProcess.Id -EA 0 | Measure-Object).Count
        Write-Host "endpoints: " $num_udp_endpoints
    }

    if (($num_udp_endpoints -gt 4) -and (-not $global:on_air)) {
        set_on_air $true
    } elseif (($num_udp_endpoints -le 4) -and ($global:on_air)) {
        set_on_air $false
    }

}

$global:on_air = $false

While ($true) {
    check_and_report
    Start-Sleep -Seconds 30
}
