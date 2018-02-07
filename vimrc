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
"Plugin 'vim-airline/vim-airline'
"Plugin 'tpope/vim-sensible'
"Plugin 'tpope/vim-surround'
"Plugin 'morhetz/gruvbox'
"Plugin 'maksimr/vim-jsbeautify'
"Plugin 'tpope/vim-fugitive'
"Plugin 'Raimondi/delimitMate'

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

set autoindent "autoindent when applicable
set smarttab "insert blanks according to shiftwidth when <Tab> is hit
set expandtab "turn tabs into spaces
set shiftwidth=4 "set # of spaces to indent
set softtabstop=4 "how many spaces a tab counts as
filetype plugin indent on
autocmd FileType ruby setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4
"don't indent when pasting
map <F2> :set invpaste<CR>

"=============================
" Word wrap settings
"=============================

"(t) autowrap using textwidth (t)
"(c) autowrap comments using textwidth, inserting the current commend leader
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

" Gruvbox
let g:gruvbox_bold=1
let g:gruvbox_italic=0
let g:gruvbox_underline=1
let g:gruvbox_undercurl=1
let g:gruvbox_contrast_dark="soft"
let g:gruvbox_contrast_light="soft"
colorscheme gruvbox
set background=dark

" JsBeautify
map <c-p> :call JsBeautify()<cr>
" or
autocmd FileType javascript noremap <buffer>  <c-p> :call JsBeautify()<cr>
" for json
autocmd FileType json noremap <buffer> <c-p> :call JsonBeautify()<cr>
" for jsx
autocmd FileType jsx noremap <buffer> <c-p> :call JsxBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <c-p> :call HtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <c-p> :call CSSBeautify()<cr>

" DelimitMate
let delimitMate_expand_space = 1
let delimitMate_expand_cr = 1

"=============================
" Custom functions
"=============================

" Tab completion for words
set complete=.,w,t,b,i
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>

" Make the 81st column stand out
highlight ColorColumn ctermbg=grey guifg=yellow
call matchadd('ColorColumn', '\%81v', 100)

" This rewires n and N to do the highlighing...
nnoremap <silent> n   n:call HLNext(0.4)<cr>
nnoremap <silent> N   N:call HLNext(0.4)<cr>

" highlight the next match in red
function! HLNext (blinktime)
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    let target_pat = '\c\%#\%('.@/.'\)'
    let ring = matchadd('Error', target_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction

" make tabs, trailing whitespace, and nbs visible
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

" swap : and ; to make colon commands easier to type
nnoremap  ;  :

