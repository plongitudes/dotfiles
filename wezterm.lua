-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action
local os_windows, os_darwin, os_linux = false, false, false
local os_string = wezterm.target_triple
local user_home

-- This is where you actually apply your config choices

-- some util functions for testing file IO. with this minimal wezterm config,

-- Check if a file or directory exists in this path
local function exists(file)
    local ok, err, code = os.rename(file, file)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            print("permission denied but it's there.")
            return true
        end
    else
        print("couldn't test existence of file by renaming, but not sure why.")
    end
    print("is " .. file .. " okay?  -->" .. wezterm.to_string(ok) .. "<--")
    if err then
        print("    guess not! the err is  -->" .. wezterm.to_string(err) .. "<--")
    end
    return ok, err
end

-- Check if a directory exists in this path
local function isdir(path)
    -- "/" works on both Unix and Windows
    return exists(path .. "/")
end

local function split(str, pattern)
    local parts = {}
    for match in string.gmatch(str, "[^" .. pattern .. "]+") do
        table.insert(parts, match)
    end
    return parts
end

local function get_win_path(path_str)
    local parts = {}
    local win_path = ""
    if string.gmatch(path_str, "/") then
        parts = split(path_str, "/")
    end
    win_path = table.concat(parts, "\\")
    return win_path
end

local function detect_os()
    local dir_separator
    if os_string:find("windows") then
        config.default_domain = "WSL:Ubuntu"
        user_home = "USERPROFILE"
        dir_separator = "\\"
        os_windows = true
    elseif os_string:find("darwin") then
        user_home = "HOME"
        dir_separator = "/"
        os_darwin = true
    elseif os_string:find("linux") then
        user_home = "HOME"
        dir_separator = "/"
        os_linux = true
    end
end

detect_os()

-- wezterm.on("window-config-reloaded", function(window, pane)
--     window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
-- end)

-- how to remember the last window size/position
local cache_dir = os.getenv(user_home) .. "/.cache/wezterm/"
local cache_file = cache_dir .. "wezterm_window_geometry.txt"

if os_windows then
    cache_dir = get_win_path(cache_dir)
    cache_file = get_win_path(cache_file)
end

-- workspace layouts (Windows only — on macOS, tmux handles this)
-- each workspace is a function that receives the initial pane and creates the layout.
-- TODO: customize these for your work machine's typical project dirs.
local workspaces = {
    default = function(first_pane)
        -- example: editor on the left, terminal on the right, small pane bottom-right
        local right_pane = first_pane:split({ direction = "Right", size = 0.35 })
        right_pane:split({ direction = "Bottom", size = 0.3 })
        -- uncomment and set cwds when you know your Windows project paths:
        -- first_pane:send_text("cd ~/projects/main\n")
        -- right_pane:send_text("cd ~/projects/main\n")
    end,
}

local function spawn_workspace(name)
    local ws = workspaces[name or "default"]
    if not ws then
        return
    end
    local tab, pane, window = mux.spawn_window({ workspace = name or "default" })
    ws(pane)
    return window
end

wezterm.on("gui-startup", function()
    if not exists(cache_file) then
        print("file didn't exist")
        os.execute("mkdir " .. cache_dir)
        local success = exists(cache_dir)
        if success then
            print("cache dir created")
            local fh, err = io.open(cache_file, "w")
            if fh then
                fh:write("160,50")
                fh:close()
                print("cache file init complete")
            else
                print("error opening cache file: " .. err)
            end
        else
            print("could not create cache dir")
        end
    end
    local fh = io.open(cache_file, "r")
    if fh ~= nil then
        print("hurray, fh found!")
        -- TODO: add position info (x,y) from halostatue's post here: https://github.com/wezterm/wezterm/discussions/6041
        local _, _, width, height = string.find(fh:read(), "(%d+),(%d+)")
        if os_windows then
            -- on Windows, use workspace layout since we don't have tmux
            spawn_workspace("default")
        else
            mux.spawn_window({ width = tonumber(width), height = tonumber(height) })
        end
        fh:close()
    else
        print("sorry, fh was nil")
        if os_windows then
            spawn_workspace("default")
        else
            local tab, pane, window = mux.spawn_window({})
            window:gui_window():maximize()
        end
    end
end)

wezterm.on("window-resized", function(window, pane)
    local fh = io.open(cache_file, "r")
    local tab_size = pane:tab():get_size()
    -- print("tab_size: " .. wezterm.to_string(tab_size))
    -- tab_size: {
    --     "cols": int,
    --     "dpi": int,
    --     "pixel_height": int,
    --     "pixel_width": int,
    --     "rows": int,
    -- }
    local cols = tab_size["cols"]
    local rows = tab_size["rows"] + 2 -- without adding the 2 here, the window doesn't maximize
    local contents = string.format("%d,%d", cols, rows)
    fh = assert(io.open(cache_file, "w"))
    fh:write(contents)
    fh:close()
end)

-- appearance
config.color_scheme = "Gruvbox dark, medium (base16)"
config.font = wezterm.font("FantasqueSansM Nerd Font")
config.font_size = 10
config.initial_rows = 50
config.initial_cols = 120

config.tab_bar_at_bottom = true
config.debug_key_events = false
config.use_fancy_tab_bar = true
config.tab_max_width = 32
config.colors = {
    tab_bar = {
        active_tab = {
            -- I use a solarized dark theme; this gives a teal background to the active tab
            fg_color = "#fe8019",
            bg_color = "#282828",
        },
        inactive_tab = {
            fg_color = "#d65d0e",
            bg_color = "#3c3836",
        },
    },
}
-- Switch to the last active tab when I close a tab
config.switch_to_last_active_tab_when_closing_tab = true

-- set leader key
config.leader = { key = "a", mods = "META", timeout_milliseconds = 500 }

-- do some key configs
config.keys = {

    {
        key = "Tab",
        mods = "CMD",
        action = wezterm.action.DisableDefaultAssignment,
    },
    ---- LEADER combos (leader key + other key or key combo)
    -- create new tab
    { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },

    -- META keys (opt/alt key combos with no leader)
    { key = "/", mods = "META", action = act.ActivateCopyMode },
    { key = "z", mods = "META", action = act.TogglePaneZoomState },
    { key = "=", mods = "META", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "-", mods = "META", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "i", mods = "META", action = act.ActivateTabRelative(1) },
    { key = "u", mods = "META", action = act.ActivateTabRelative(-1) },
    { key = "w", mods = "LEADER", action = act.ShowTabNavigator },

    { key = "h", mods = "META", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "META", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "META", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "META", action = act.ActivatePaneDirection("Right") },

    -- SUPER keys (cmd/win key combos with no leader)
    --
    -- some callbacks or other functions initiated by keybinds

    -- rename active tab
    {
        key = ",",
        mods = "LEADER",
        action = act.PromptInputLine({
            description = "(active_tab:set_title)",
            action = wezterm.action_callback(function(window, _, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        }),
    },
}

-- have wezterm pick a random color scheme for each new window.
-- first, create a table with the name of every builtin scheme.
local schemes = {}
for name, _ in pairs(wezterm.get_builtin_color_schemes()) do
    table.insert(schemes, name)
end

-- when the config is loaded or reloaded (saving the config or opening a new window):
--[[
wezterm.on("window-config-reloaded", function(window, pane)
    -- don't proceed if the config has already been overridden, otherwise we'll enter an infinite
    -- loop of neverending, vomitous color scheme changes.
    if window:get_config_overrides() then
        return
    end
    scheme = schemes[math.random(#schemes)]
    window:set_config_overrides({ color_scheme = scheme })
    wezterm.log_info("Color scheme is: " .. scheme)
end)
--]]

-- resurrect.wezterm: session save/restore (partial Windows support)
-- save: Leader + s, restore: Leader + r
local resurrect_ok, resurrect = pcall(function()
    return wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
end)

if resurrect_ok then
    resurrect.periodic_save({ interval_seconds = 300 })

    table.insert(config.keys, {
        key = "s",
        mods = "LEADER",
        action = wezterm.action_callback(function(win, pane)
            resurrect.save_state(resurrect.workspace_state.get_workspace_state())
        end),
    })

    table.insert(config.keys, {
        key = "r",
        mods = "LEADER",
        action = wezterm.action_callback(function(win, pane)
            resurrect.fuzzy_load(win, pane, function(id, label)
                local state = resurrect.load_state(id, "workspace")
                resurrect.workspace_state.restore_workspace(state, {
                    window = win:mux_window(),
                    relative = true,
                    restore_text = true,
                })
            end)
        end),
    })
end

-- and finally, return the configuration to wezterm
return config
