local M = {}

function M.setup()
    M.globals()
    M.options()
    M.commands()
end

function M.globals()
    vim.g.mapleader = " "
    vim.g.loaded_perl_provider = 0

    -- Use mise's Python shim for Neovim provider (has molten deps)
    -- This ignores project venvs so plugins always have their deps
    -- LSP still uses project venv via basedpyright's pythonPath detection
    vim.g.python3_host_prog = vim.fn.expand("~/.local/share/mise/shims/python")
    vim.g.noswapfile = true
    vim.g.backup = true
    vim.g.writebackup = true
    vim.g.format_on_save = true

    -- Only create outline-related autocmds when not in VSCode
    if not vim.g.vscode then
        vim.api.nvim_create_augroup("__on_buffer_delete__", { clear = true })
        vim.api.nvim_create_autocmd("QuitPre", {
            group = "__on_buffer_delete__",
            callback = function()
                if vim.fn.exists(":OutlineClose") == 2 then
                    vim.cmd("OutlineClose")
                end
            end,
        })
    end
end

function M.options()
    -- set visible characters
    --[[
    vim.opt.list = true
    vim.opt.listchars = {
      eol = "⏎",
      tab = "⁘ ",
      space = "·",
      trail = "·",
    }
      ]]
    --

    vim.opt.textwidth = 120
    vim.opt.formatoptions = "2jcroql"
    vim.opt.smartcase = true
    vim.opt.sessionoptions = {
        --"blank",
        --"buffers",
        --"curdir",
        -- "folds",
        -- "help",
        -- "options",
        --"tabpages",
        --"winsize",
        --"resize",
        --"winpos",
        --"terminal",
        --"globals",
    }

    --vim.opt.clipboard = "unnamedplus"
    --vim.opt.backupdir:remove { "." }

    --vim.opt.backup = true
    --vim.opt.backupcopy = "yes"
    --vim.opt.cmdheight = 1
    --vim.opt.history = 1000
    vim.opt.joinspaces = false
    --vim.opt.cinkeys:remove ":"

    --vim.opt.incsearch = true
    --vim.opt.infercase = true
    --vim.opt.inccommand = "split"

    vim.opt.scrolloff = 10
    vim.opt.sidescrolloff = 10

    --vim.opt.showbreak = "↳"
    --vim.opt.splitkeep = "topline"
    --vim.opt.smarttab = true
    -- vim.opt.wildmode = { list = "longest" }

    vim.opt.termguicolors = true

    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 0
    vim.opt.expandtab = true
    --
    -- let's try smartindent instead of autoindent?
    vim.opt.autoindent = false
    vim.opt.smartindent = true

    vim.opt.linebreak = true

    --vim.opt.fillchars = { eob = " " }

    --vim.opt.hidden = true
    vim.opt.ignorecase = true
    --vim.opt.smartcase = true
    vim.opt.mouse = "a"

    --vim.opt.shortmess:append "cAIfs"
    vim.opt.signcolumn = "yes"
    vim.opt.splitbelow = true
    vim.opt.splitright = true

    --vim.opt.timeoutlen = 1200
    --vim.opt.spelloptions:append "noplainbuffer"

    --vim.opt.showmode = false
    vim.opt.hlsearch = true
    --vim.opt.synmaxcol = 150
    vim.opt.cursorline = true
    --vim.opt.updatetime = 250
    --vim.opt.whichwrap:append "<>[]hl"

    vim.opt.undofile = true

    vim.opt.number = true
    vim.opt.numberwidth = 2
    vim.opt.relativenumber = true
    vim.opt.ruler = true

    -- Custom statuscolumn with +1 offset for relative numbers (see plongitudes/utils.lua)
    --vim.opt.statuscolumn = [[%!v:lua.require('plongitudes.utils').statuscolumn()]]

    --vim.opt.wrap = false

    --vim.opt.listchars = {
    --tab = "!·",
    --nbsp = "␣",
    --trail = "·",
    --eol = "↲",
    --}
    --vim.opt.list = true
    vim.opt.colorcolumn = tostring(120)
    --vim.opt.conceevel = 1

    vim.opt.winborder = "rounded"
    if vim.g.neovide then
        vim.o.guifont = "FantasqueSansM Nerd Font:h14"
        vim.g.neovide_opacity = 0.8
        vim.g.neovide_window_blurred = true
    end
end

function M.commands()
    --vim.cmd "set iskeyword-=_"
    --vim.cmd "set fsync"
    --vim.cmd "set t_ZH=^[[3m"
    --vim.cmd "set t_ZR=^[[23m"
    --vim.cmd [[ :cab W w]]
    --vim.cmd [[ :cab Q q]]
    --vim.cmd [[ autocmd BufRead * autocmd FileType <buffer> ++once
    --\ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif]]
    --vim.filetype.add {
    --extension = {
    --rasi = "css",
    --},
    --}
    --FileType json set matprg=jq
    -- vim.api.nvim_create_autocmd("TermResponse", {
    -- 	once = true,
    -- 	callback = function(args)
    -- 		local resp = args.data
    -- 		local r, g, b = resp:match("\x1b%]4;1;rgb:(%w+)/(%w+)/(%w+)")
    -- 	end,
    -- })
end

M.setup()
