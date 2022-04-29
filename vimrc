"=============================
" Some preload stuff
"=============================

set nocompatible              " be iMproved, required
filetype off                  " required

" Define autocmd for some highlighting *before* the colorscheme is loaded
augroup VimrcColors
au!
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=#444444
  autocmd ColorScheme * highlight Tab             ctermbg=darkblue  guibg=darkblue
augroup END

" from https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

"=============================
" Vundle settings
"=============================

"set the runtime path to include Vundle and initialize
"set rtp+=~/.vim/bundle/vundle/
"let path='~/.vim/bundle'
"call vundle#rc()
set rtp+=~/.vim/bundle/Vundle.vim
let s:bootstrap = 0
try
    call vundle#begin()
catch /E117:/
    let s:bootstrap = 1
    silent !mkdir -p ~/.vim/bundle
    silent !unset GIT_DIR && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    redraw!
    call vundle#begin()
endtry
" alternatively, pass a path where Vundle should install plugins
"let path = '~/some/path/here'
"call vundle#rc(path)

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-rails'
Plugin 'morhetz/gruvbox'
Plugin 'tpope/vim-fugitive'
Plugin 'Raimondi/delimitMate'
Plugin 'bogado/file-line'
Plugin 'plytophogy/vim-virtualenv'
Plugin 'Chiel92/vim-autoformat'
Plugin 'wakatime/vim-wakatime'
Plugin 'airblade/vim-gitgutter'
Plugin 'wincent/terminus'
Bundle 'wellle/context.vim'
Plugin 'neoclide/coc.nvim'
Plugin 'psf/black'
"Plugin 'tweekmonster/impsort.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'leafgarland/typescript-vim'
Plugin 'MaxMEllon/vim-jsx-pretty'
Plugin 'peitalin/vim-jsx-typescript'
Plugin 'styled-components/vim-styled-components'
Plugin 'alvan/vim-closetag'
Plugin 'jparise/vim-graphql'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'mtdl9/vim-log-highlighting'

call vundle#end()
if s:bootstrap
    silent PluginInstall
    quit
end

filetype plugin indent on     " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Plugin commands are not allowed.
" Put your stuff after this line


"=============================
" Some pyenv stuff
"=============================
"let g:python_host_prog="$HOME/.pyenv/shims/python"
"let g:python3_host_prog="$HOME/.pyenv/shims/python"

"=============================
" Some coc.nvim stuff
"=============================
set hidden                    " for coc.nvim, TextEdit might fail without this
set nobackup                  " some server have issues with backup files, see coc.nvim #649
set nowritebackup             " same as above

" smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" indent curly braces better
inoremap {<CR> {<CR>}<C-o>O

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
"not using this anymore because it overrides shift-tab for getting out of
"completions
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" unmap Y from y*
silent!  nunmap Y

"=============================
" Some terminal stuff
"=============================

let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1

"set termguicolors if using nvim
if has('nvim')
    set termguicolors
endif

"=============================
" General Vim setup
"=============================

syntax on
set autowrite "autosave when losing focus
"set cinoptions=(s "indent style preference
"set cinkeys=0{,0},!,o,O,e "indent keys for triggering reindenting
set cmdheight=2 "use 2 lines for command-line
set cpo&vim "set vimpatible-options to vim defaults
set encoding=utf-8
set foldlevelstart=20 "folds to start open
set foldmethod=indent "how to fold
set helplang=en
set hlsearch "highlight searches
set incsearch "search incrementally
set laststatus=2 "always show status line
set linebreak "break on words
set modelines=0 "don't check any lines for set commands
set mouse=a "enable mouse for all modes
set nu "turn on line numbers
set showmatch "briefly highlight matching bracket if visible
set wrap "wrap long lines
set visualbell "flash the screen for a bell
set tags+=$HOME/.tags

set autoindent "autoindent when applicable
set smarttab "insert blanks according to shiftwidth when <Tab> is hit
set expandtab "turn tabs into spaces
set shiftwidth=4 "set # of spaces to indent
set softtabstop=4 "how many spaces a tab counts as
filetype plugin indent on
autocmd FileType go setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType ruby setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType javascript setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4
"don't indent when pasting
map <F2> :set invpaste<CR>

" put search results in the middle of the screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

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
" Navigating tabs
"=============================

nnoremap th  :tabnew<CR>
nnoremap tj  :tabprev<CR>
nnoremap tk  :tabnext<CR>
nnoremap tl  :tabclose<CR>
nnoremap tt  :tabedit<Space>
nnoremap tm  :tabm<Space>

"=============================
" Plugin-specific settings
"=============================

" Black
autocmd BufWritePre *.py execute ':Black'
nnoremap <C-k> :Black<CR>

" Gruvbox
let g:gruvbox_bold=1
let g:gruvbox_italic=0
let g:gruvbox_underline=1
let g:gruvbox_undercurl=1
let g:gruvbox_contrast_dark="soft"
let g:gruvbox_contrast_light="soft"
colorscheme gruvbox
set background=dark

" DelimitMate
let delimitMate_expand_space = 1
let delimitMate_expand_cr = 1

" Context
" setting this to 0 in hopes of speeding up _some_ parts of Context
let g:context_add_mappings = 1
let g:context_add_autocmds = 1
let g:context_nvim_no_redraw = 1

" vim-closetag
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.erb'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml,erb'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
"
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>>'


"=============================
" Custom functions
"=============================

" Make the 81st column stand out
highlight ColorColumn ctermbg=grey guifg=yellow
call matchadd('ColorColumn', '\%81v', 100)

" This rewires n and N to do the highlighing...
"nnoremap <silent> n   n:call HLNext(0.1)<cr>zz
"nnoremap <silent> N   N:call HLNext(0.1)<cr>zz

" highlight the next match in red
"function! HLNext (blinktime)
    "let [bufnum, lnum, col, off] = getpos('.')
    "let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    "let target_pat = '\c\%#\%('.@/.'\)'
    "let ring = matchadd('Error', target_pat, 101)
    "redraw
    "exec 'sleep ' . float2nr(a:blinktime * 100) . 'm'
    "call matchdelete(ring)
    "redraw
"endfunction

" make tabs, trailing whitespace, and nbs visible
"exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
exec "set listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵"
set list

"=============================
" monitor macOS to detect light/dark theme changes
"=============================

function! SetBackgroundMode(...)
    let s:new_bg = "dark"
    if ($TERM_PROGRAM ==? "iTerm.app") || has("gui_vimr")
        let s:mode = systemlist("defaults read -g AppleInterfaceStyle")[0]
        if s:mode ==? "dark"
            let s:new_bg = "dark"
        else
            let s:new_bg = "light"
        endif
    else
        " This is for Linux where I use an environment variable for this:
        if $VIM_BACKGROUND ==? "light"
            let s:new_bg = "light"
        else
            let s:new_bg = "dark"
        endif
    endif
    if &background !=? s:new_bg
        let &background = s:new_bg
    endif
endfunction
call SetBackgroundMode()
call timer_start(30000, "SetBackgroundMode", {"repeat": -1})

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
