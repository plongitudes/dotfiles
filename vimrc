"=============================
" Some preload stuff
"=============================

set nocompatible              " be iMproved, required
filetype off                  " required

" unsure if this is still needed
" Define autocmd for some highlighting *before* the colorscheme is loaded
"augroup VimrcColors
"au!
  "autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=#444444
  "autocmd ColorScheme * highlight Tab             ctermbg=darkblue  guibg=darkblue
"augroup END

" unsure if this is still needed
" from https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim
"autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
"autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

"set termguicolors if using nvim
if has('nvim')
    set termguicolors
endif

"=============================
" General Vim setup
"=============================

syntax on
set autowrite "autosave when losing focus
set cmdheight=2 "use 2 lines for command-line
set cpo&vim "set vimpatible-options to vim defaults
set encoding=utf-8
set foldlevelstart=20 "folds to start open
set foldmethod=indent "how to fold
set helplang=en
set hlsearch "highlight searches
set incsearch "search incrementally
set laststatus=0 "always show status line: 0 never, 1 only when # windows > 1, always
set statusline=
set linebreak "break on words
set modelines=0 "don't check any lines for set commands
set mouse=a "enable mouse for all modes
set nu "turn on line numbers
set relativenumber
set showmatch "briefly highlight matching bracket if visible
set wrap "wrap long lines
set visualbell "flash the screen for a bell

"trying to not use tags anymore, move to treesitter
"set tags+=$HOME/.tags

set autoindent "autoindent when applicable
set smarttab "insert blanks according to shiftwidth when <Tab> is hit
set expandtab "turn tabs into spaces
set shiftwidth=4 "set # of spaces to indent
set softtabstop=4 "how many spaces a tab counts as
filetype plugin indent on
autocmd FileType go setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType ruby setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType javascript setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType lua setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4

let g:loaded_perl_provider = 0

"don't indent when pasting
map <F2> :set invpaste<CR>

" put search results in the middle of the screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Make the 81st column stand out
highlight ColorColumn ctermbg=grey guifg=yellow
call matchadd('ColorColumn', '\%81v', 100)

" make tabs, trailing whitespace, and nbs visible
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
exec "set listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵"
set list

" i never use these anymore
" Navigating tabs
"nnoremap th  :tabnew<CR>
"nnoremap tj  :tabprev<CR>
"nnoremap tk  :tabnext<CR>
"nnoremap tl  :tabclose<CR>
"nnoremap tt  :tabedit<Space>
"nnoremap tm  :tabm<Space>

"=============================
" Word wrap settings
"=============================

"(t) autowrap using textwidth (t)
"(c) autowrap comments using textwidth, inserting the current comment leader
"    automatically.
"(r) Automatically insert the current comment leader after hitting <Enter> in
"    Insert mode.
"(q) Allow formatting of comments with `gq`.
"(2) When formatting text, recognize numbered lists.
set formatoptions=tcrq2

"=============================
" Old R&H syntax highlighting :(
"=============================

"autocmd BufNewFile,BufReadPost *.opa  so ~/.vim/syntax/opa.vim
"autocmd BufNewFile,BufReadPost *.opn  so ~/.vim/syntax/opa.vim
"autocmd BufNewFile,BufReadPost *.upa  so ~/.vim/syntax/opa.vim
"autocmd BufNewFile,BufReadPost *.ren  so ~/.vim/syntax/parsley.vim

"=============================
" Plugin-specific settings
"=============================

" vim-airline
"let g:airline_powerline_fonts=1
"let g:airline#extensions#tabline#enabled=1

" coc-pydocstring
"nmap <silent> ga <Plug>(coc-codeaction-line)
"xmap <silent> ga <Plug>(coc-codeaction-selected)
"nmap <silent> gA <Plug>(coc-codeaction)

" Black
"autocmd BufWritePre *.py execute ':Black'
"nnoremap <C-k> :Black<CR>

" Gruvbox
"let g:gruvbox_bold=1
"let g:gruvbox_italic=0
"let g:gruvbox_underline=1
"let g:gruvbox_undercurl=1
"let g:gruvbox_contrast_dark="soft"
"let g:gruvbox_contrast_light="soft"
"colorscheme gruvbox
"set background=dark

" DelimitMate
"let delimitMate_expand_space = 1
"let delimitMate_expand_cr = 1

" Context
"let g:context_add_mappings = 1
"let g:context_add_autocmds = 1
"let g:context_nvim_no_redraw = 1

"=============================
" monitor macOS to detect light/dark theme changes
"=============================

"function! SetBackgroundMode(...)
    "let s:new_bg = "dark"
    "if ($TERM_PROGRAM ==? "iTerm.app") || has("gui_vimr")
        "let s:mode = systemlist("defaults read -g AppleInterfaceStyle")[0]
        "if s:mode ==? "dark"
            "let s:new_bg = "dark"
        "else
            "let s:new_bg = "light"
        "endif
    "else
        "" This is for Linux where I use an environment variable for this:
        "if $VIM_BACKGROUND ==? "light"
            "let s:new_bg = "light"
        "else
            "let s:new_bg = "dark"
        "endif
    "endif
    "if &background !=? s:new_bg
        "let &background = s:new_bg
    "endif
"endfunction
"call SetBackgroundMode()
"
"call timer_start(30000, "SetBackgroundMode", {"repeat": -1})

"=============================
" some tips and tricks to keep track of
"=============================

" movement and selecting
"
" select blocks of code
" i selects block exclusively
" a selects block inclusively (including borders)
" ctrl+v a then ( or [ or {
" also:
" v a then ( or [ or {
" can also be expanded
" select out the the second level of nested blocks:
" v 2 i 
" equivalently:
" v i ( i (

"critical plugins
"------------------------------------------------------
"Plug 'morhetz/gruvbox'              "movedToPacker - colorscheme
"Plug 'vim-airline/vim-airline'      "the best status bar!
"Plug 'tpope/vim-sensible'           "sensible defaults
"Plug 'Raimondi/delimitMate'         "automatic pair closing, but does an LSP provide that also?

"good plugins
"------------------------------------------------------
"Plug 'bogado/file-line'             "open file at line with file.name:line_num
"Plug 'wincent/terminus'             "terminal enhancements like diff cursors in insert mode
"Plug 'wellle/context.vim'           "badass block level context clues
"Plug 'psf/black'                    "good python formatter, very unforgiving
"Plug 'mtdl9/vim-log-highlighting'   "generic log highlighting
"Plug 'vim-scripts/matchit.zip'      "navigating with % for more than just characters

"plugins to try out
"------------------------------------------------------
"Plug 'williamboman/mason.nvim'
"Plug 'williamboman/mason-lspconfig.nvim'
"Plug 'neovim/nvim-lspconfig'

"plugins to comment out but not forget about completely
"------------------------------------------------------
"Plug 'tpope/vim-fugitive'           "lazygit? does git commands inside vim but i never use that, i use tig
"Plug 'airblade/vim-gitgutter'       "lazygit here too?
"Plug 'Chiel92/vim-autoformat'       "code formatter, but maybe too old?
"Plug 'tpope/vim-rails'              "don't need this one so much
"Plug 'alvan/vim-closetag'           "html tag closer, possibly superceded with an LSP?
"Plug 'dag/vim-fish'                 "syntax highlighting for the fish shell
"Plug 'jparise/vim-graphql'          "graphql file detection, syntax highlighting, and indentation

"plugins we should just dump
"------------------------------------------------------
"Plug 'neoclide/coc.nvim'            "good lsp
"Plug 'yaegassy/coc-pydocstring', {'do': 'yarn install --frozen-lockfile'} "I should use this but haven't been.
"Plug 'pangloss/vim-javascript'      "syntax highlighting and indenting for js
"Plug 'leafgarland/typescript-vim'   "syntax file and other options for typescript
"Plug 'MaxMEllon/vim-jsx-pretty'     "indenting and highlighting for jsx
"Plug 'peitalin/vim-jsx-typescript'  "indenting and highlighting for jsx in typescript
"Plug 'styled-components/vim-styled-components' "no longer maintained
"Plug 'HiPhish/repl.nvim'            "repl inside vim, but just use tmux

"call plug#end()

"=============================
" Some terminal stuff
"=============================

"let g:airline_powerline_fonts=1
"let g:airline#extensions#tabline#enabled=1


