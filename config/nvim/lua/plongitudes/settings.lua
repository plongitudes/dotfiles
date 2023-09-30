local M = {}

function M.setup()
    M.globals()
    M.options()
    M.commands()
end

function M.globals()
    vim.g.mapleader = " "
    vim.g.loaded_perl_provider = 0
    vim.g.python3_host_prog = "$NVIM_PYTHON_PATH"
    vim.g.noswapfile = true
    vim.g.backup = true
    vim.g.writebackup = true
    --vim.g.completeopt('menu,menuone,preview')
    vim.lsp.set_log_level('debug')
    --vim.g.format_on_save = true
end

function M.options()
    -- set visible characters
    --exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
    --exec "set listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵"
    --set list
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
    --vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
    --vim.opt.smoothscroll = true
    --vim.opt.exrc = true
    --vim.opt.history = 1000
    --vim.opt.joinspaces = false
    --vim.opt.cinkeys:remove ":"

    --vim.opt.incsearch = true
    --vim.opt.infercase = true
    --vim.opt.inccommand = "split"

    --vim.opt.scrolloff = 10
    --vim.opt.sidescrolloff = 10

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
    --vim.opt.ignorecase = true
    vim.opt.smartcase = true
    vim.opt.mouse = "a"

    --vim.opt.shortmess:append "cAIfs"
    --vim.opt.signcolumn = "yes"
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
    --vim.opt.numberwidth = 2
    vim.opt.relativenumber = true
    vim.opt.ruler = true

    --vim.opt.wrap = false

    --vim.opt.listchars = {
        --tab = "!·",
        --nbsp = "␣",
        --trail = "·",
        --eol = "↲",
    --}
    --vim.opt.list = true
    vim.opt.colorcolumn = tostring(100)
    --vim.opt.conceallevel = 1
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
end

M.setup()
