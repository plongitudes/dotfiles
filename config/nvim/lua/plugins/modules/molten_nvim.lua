return {
	"benlubas/molten-nvim",
	version = "^1.0.0",
	build = ":UpdateRemotePlugins",
	ft = { "python" },
	dependencies = {
		"3rd/image.nvim",
	},
	init = function()
		-- Output configuration
		vim.g.molten_auto_open_output = true
		vim.g.molten_output_win_max_height = 20
		vim.g.molten_virt_text_output = true
		vim.g.molten_virt_lines_off_by_1 = true

		-- Image rendering via image.nvim
		vim.g.molten_image_provider = "image.nvim"

		-- Wrap long output lines
		vim.g.molten_wrap_output = true
	end,
	config = function()
		-- Setup command for Home Assistant Pyscript kernel
		vim.api.nvim_create_user_command("MoltenSetupPyscript", function()
			local ha_url = os.getenv("HA_URL")
			local ha_token = os.getenv("HA_TOKEN")

			-- Validate env vars
			if not ha_url or ha_url == "" then
				vim.notify("HA_URL environment variable not set!", vim.log.levels.ERROR)
				return
			end
			if not ha_token or ha_token == "" then
				vim.notify("HA_TOKEN environment variable not set!", vim.log.levels.ERROR)
				return
			end

			-- Parse host and port from HA_URL
			local host, port = ha_url:match("https?://([^:]+):?(%d*)")
			if not host then
				vim.notify("Could not parse HA_URL: " .. ha_url, vim.log.levels.ERROR)
				return
			end
			port = port ~= "" and port or "8123"

			-- Ensure Jupyter runtime directory exists (platform-specific)
			local sysname = vim.loop.os_uname().sysname
			local runtime_dir
			if sysname == "Darwin" then
				runtime_dir = vim.fn.expand("~/Library/Jupyter/runtime")
			elseif sysname == "Windows_NT" then
				runtime_dir = vim.fn.expand("$APPDATA/jupyter/runtime")
			else -- Linux and others
				local xdg_data = os.getenv("XDG_DATA_HOME") or vim.fn.expand("~/.local/share")
				runtime_dir = xdg_data .. "/jupyter/runtime"
			end

			if vim.fn.isdirectory(runtime_dir) == 0 then
				vim.fn.mkdir(runtime_dir, "p")
				vim.notify("Created Jupyter runtime directory: " .. runtime_dir, vim.log.levels.INFO)
			end

			-- Check if pyscript kernel is installed
			local kernelspec_output = vim.fn.system("jupyter kernelspec list 2>/dev/null")
			local kernel_installed = kernelspec_output:match("pyscript")

			if not kernel_installed then
				vim.notify("Installing pyscript kernel...", vim.log.levels.INFO)
				local install_output = vim.fn.system("jupyter pyscript install 2>&1")
				if vim.v.shell_error ~= 0 then
					vim.notify("Failed to install pyscript kernel: " .. install_output, vim.log.levels.ERROR)
					return
				end
				vim.notify("Pyscript kernel installed!", vim.log.levels.INFO)
			else
				vim.notify("Pyscript kernel already installed", vim.log.levels.INFO)
			end

			-- Find pyscript kernel directory from kernelspec
			local kernel_path = nil
			for line in kernelspec_output:gmatch("[^\n]+") do
				if line:match("pyscript") then
					kernel_path = line:match("%s+(%S+)$")
					break
				end
			end

			if not kernel_path then
				-- Fallback: re-run to get fresh output after install
				kernelspec_output = vim.fn.system("jupyter kernelspec list 2>/dev/null")
				for line in kernelspec_output:gmatch("[^\n]+") do
					if line:match("pyscript") then
						kernel_path = line:match("%s+(%S+)$")
						break
					end
				end
			end

			if not kernel_path then
				vim.notify("Could not find pyscript kernel path", vim.log.levels.ERROR)
				return
			end

			-- Write pyscript.conf in kernel directory (INI format with section header)
			local conf_path = kernel_path .. "/pyscript.conf"
			local scheme = ha_url:match("^(https?)://") or "http"
			local conf_content = string.format(
				"[homeassistant]\nhass_host = %s\nhass_url = %s://%s:%s\nhass_token = %s\n",
				host,
				scheme,
				host,
				port,
				ha_token
			)

			local file = io.open(conf_path, "w")
			if file then
				file:write(conf_content)
				file:close()
				vim.notify("Wrote " .. conf_path, vim.log.levels.INFO)
			else
				vim.notify("Failed to write " .. conf_path, vim.log.levels.ERROR)
				return
			end

			vim.notify("Pyscript setup complete! Use :MoltenInit and select 'pyscript'", vim.log.levels.INFO)
		end, { desc = "Setup Home Assistant Pyscript kernel and config" })
	end,
}
