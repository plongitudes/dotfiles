-- Copyright Epic Games, Inc. All Rights Reserved.
-- CONTAINS AI GENERATED CODE
local M = {}

local state_file = vim.fn.stdpath("data") .. "/last_project.json"

--- Save the last selected project to disk
--- @param name string
--- @param path string
function M.save_last_project(name, path)
    local data = vim.fn.json_encode({ name = name, path = path })
    local f = io.open(state_file, "w")
    if f then
        f:write(data)
        f:close()
    end
end

--- Read the last selected project from disk
--- @return {name: string, path: string}|nil
function M.get_last_project()
    local f = io.open(state_file, "r")
    if not f then
        return nil
    end
    local content = f:read("*a")
    f:close()
    local ok, data = pcall(vim.fn.json_decode, content)
    if ok and data and data.name and data.path then
        return data
    end
    return nil
end

--- Restore the last project's working directory on startup
function M.restore()
    local proj = M.get_last_project()
    if proj and vim.fn.isdirectory(proj.path) == 1 then
        vim.cmd("cd " .. vim.fn.fnameescape(proj.path))
    end
end

-- Queries zoxide database and returns path -> rank lookup table
-- Lower rank = higher frecency (rank 1 is most frequently/recently used)
local function get_zoxide_ranks()
    local ranks = {}
    local handle = io.popen("zoxide query --list 2>/dev/null")

    if not handle then
        return ranks
    end

    local rank = 1
    for line in handle:lines() do
        ranks[line] = rank
        rank = rank + 1
    end

    handle:close()
    return ranks
end

-- Scans predetermined project roots for subdirectories (one level deep)
-- Returns table with {name, path, source, zoxide_rank} for each project directory
local function get_project_directories()
    local projects = {}
    local base_dirs = { "~/github/plongitudes/", "~/github/" }

    -- Get zoxide frecency data
    local zoxide_ranks = get_zoxide_ranks()

    for _, raw in ipairs(base_dirs) do
        local base = vim.fn.expand(raw)
        -- Check if base directory exists before scanning
        if vim.fn.isdirectory(base) == 1 then
            -- Wrap in pcall to handle permission errors gracefully
            local ok, subdirs = pcall(vim.fn.readdir, base, function(item)
                return vim.fn.isdirectory(base .. "/" .. item) == 1
            end)

            if ok then
                for _, dir in ipairs(subdirs) do
                    local path = base .. "/" .. dir
                    table.insert(projects, {
                        name = dir,
                        path = path,
                        source = base,
                        zoxide_rank = zoxide_ranks[path] or 99999, -- Unvisited paths get low priority
                    })
                end
            else
                vim.notify("Error reading directory: " .. base, vim.log.levels.ERROR)
            end
        end
    end

    -- Sort by zoxide rank (lower = more frequently/recently used)
    table.sort(projects, function(a, b)
        return a.zoxide_rank < b.zoxide_rank
    end)

    return projects
end

-- Opens a picker to select a project directory and changes working directory
function M.switch_to_project()
    local projects = get_project_directories()

    if #projects == 0 then
        vim.notify("No project directories found.", vim.log.levels.WARN)
        return
    end

    -- Transform projects into picker items
    local items = {}
    for idx, proj in ipairs(projects) do
        table.insert(items, {
            idx = idx,
            text = proj.name,
            path = proj.path,
            source = proj.source,
        })
    end

    require("snacks").picker.pick({
        items = items,
        title = "Switch Project",
        preview = false, -- Disable preview pane since we're selecting directories
        format = function(item)
            return {
                { "󰉋 ", "SnacksPickerIcon" },
                { item.text, "SnacksPickerFile" },
                { " (" .. item.source .. ")", "SnacksPickerComment" },
            }
        end,
        confirm = function(picker, item)
            picker:close()
            if item and item.path then
                vim.cmd("cd " .. vim.fn.fnameescape(item.path))
                M.save_last_project(item.text, item.path)
                vim.notify("Switched to project: " .. item.text, vim.log.levels.INFO)
            end
        end,
    })
end

return M
