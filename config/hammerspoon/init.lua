-- Hammerspoon config. Nix-managed: edit this file in ~/.dotfiles, `switch`,
-- then Hammerspoon menu bar → Reload Config. `@blueutil@` is substituted by
-- Nix (home/common/darwin.nix) with the store path of the Nix blueutil.

local BLUEUTIL = "@blueutil@"

-- Device to release on lock/sleep: name or MAC as printed by `blueutil --paired`.
-- 14-3f-a6-91-c5-7c, not connected, not favourite, paired, name: "WH-1000XM4"
local DEVICE = "14-3f-a6-91-c5-7c"

-- Messages land in Hammerspoon menu bar → Console. Useful for confirming which
-- events actually fire on this machine for lid close vs. ⌃⌘Q.
local log = hs.logger.new("bt", "info")

-- action: "disconnect" | "connect"
local function bt(action)
    -- hs.execute is synchronous on purpose: on systemWillSleep the command must
    -- finish before the radio goes down, and we get no second chance.
    -- 2>&1: hs.execute captures only stdout, and blueutil reports errors on stderr.
    local out, ok, _, rc = hs.execute(string.format('%s --%s "%s" 2>&1', BLUEUTIL, action, DEVICE))
    log.f("%s %s → %s", action, DEVICE, ok and "ok" or string.format("failed (rc=%s): %s", tostring(rc), out))
end

-- event → blueutil action. Lock and sleep both release; unlock deliberately
-- does NOT reconnect — the phone may be holding the headphones mid-call.
-- Reconnect from the headphones themselves or the menu bar.
-- Other events available if this needs tuning: screensDidUnlock,
-- systemDidWake, screensDidSleep/Wake (display only), sessionDidResignActive.
local ACTIONS = {
    [hs.caffeinate.watcher.screensDidLock] = "disconnect",
    [hs.caffeinate.watcher.systemWillSleep] = "disconnect",
}

-- Global, not local: a local watcher gets garbage-collected and silently stops.
btWatcher = hs.caffeinate.watcher
    .new(function(ev)
        local action = ACTIONS[ev]
        if action then
            bt(action)
        end
    end)
    :start()
