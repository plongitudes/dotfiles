return {
    "mfussenegger/nvim-dap",
    lazy = false,
    enabled = true,
    config = function()
        local dap = require("dap")

        -- Note: nvim-dap-python automatically loads .vscode/launch.json
        -- so we don't need to call load_launchjs() here (it would cause duplicates)

        -- Helper function to find project root using LSP's detection logic
        local function find_project_root()
            -- Try to get workspace folder from LSP (if available)
            local workspace_folders = vim.lsp.buf.list_workspace_folders()
            if workspace_folders and #workspace_folders > 0 then
                return workspace_folders[1]
            end

            -- Fallback: use lspconfig's root detection patterns
            local root_markers = { ".git", "pyrightconfig.json", "pyproject.toml", ".venv" }
            local current_file = vim.api.nvim_buf_get_name(0)
            local current_dir = vim.fn.fnamemodify(current_file, ":p:h")

            -- Search upward for root markers
            local root = vim.fs.find(root_markers, {
                path = current_dir,
                upward = true,
            })[1]

            if root then
                return vim.fs.dirname(root)
            end

            -- Final fallback: use cwd
            return vim.fn.getcwd()
        end

        -- Variable substitution for launch.json configurations
        -- This ensures ${workspaceFolder} and other variables are properly resolved
        local function substitute_variables(config)
            local workspace_root = find_project_root()

            -- Function to recursively substitute variables in strings
            local function substitute_string(str)
                if type(str) ~= "string" then
                    return str
                end
                -- Replace ${workspaceFolder} with project root
                str = str:gsub("${workspaceFolder}", workspace_root)
                -- Replace ${file} with current file
                str = str:gsub("${file}", vim.fn.expand("%:p"))
                -- Replace ${fileBasename} with current file basename
                str = str:gsub("${fileBasename}", vim.fn.expand("%:t"))
                -- Replace ${fileDirname} with current file directory
                str = str:gsub("${fileDirname}", vim.fn.expand("%:p:h"))
                return str
            end

            -- Recursively process the config table
            local function process_value(value)
                if type(value) == "string" then
                    return substitute_string(value)
                elseif type(value) == "table" then
                    local result = {}
                    for k, v in pairs(value) do
                        result[k] = process_value(v)
                    end
                    return result
                else
                    return value
                end
            end

            return process_value(config)
        end

        -- Hook into DAP to substitute variables before launching
        local original_run = dap.run
        dap.run = function(config, opts)
            config = substitute_variables(config)
            original_run(config, opts)
        end

        -- DAP UI signs
        vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "⚫", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapLogPoint", { text = "💬", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })

        -- Command to initialize DAP project structure
        vim.api.nvim_create_user_command("DapInitProject", function()
            -- Use the same project root detection logic
            local project_root = find_project_root()
            local vscode_dir = project_root .. "/.vscode"
            local launch_json = vscode_dir .. "/launch.json"

            -- Notify user of detected project root
            vim.notify("Detected project root: " .. project_root, vim.log.levels.INFO)

            -- Create .vscode directory if it doesn't exist
            if vim.fn.isdirectory(vscode_dir) == 0 then
                vim.fn.mkdir(vscode_dir, "p")
                vim.notify("Created .vscode directory", vim.log.levels.INFO)
            end

            -- Check if launch.json already exists
            if vim.fn.filereadable(launch_json) == 1 then
                vim.notify("launch.json already exists", vim.log.levels.WARN)
                return
            end

            -- Write the template to launch.json
            local file = io.open(launch_json, "w")
            if file then
                file:write(template)
                file:close()
                vim.notify("Created launch.json\nRun :e .vscode/launch.json to customize", vim.log.levels.INFO)
            else
                vim.notify("Error: Could not create launch.json", vim.log.levels.ERROR)
            end
        end, { desc = "Initialize DAP project with .vscode/launch.json" })
    end,
}
