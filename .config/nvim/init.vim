"""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""
set shell=/bin/zsh
if isdirectory("/usr/local/opt/fzf")
  set rtp+=/usr/local/opt/fzf
endif

call plug#begin('~/.config/nvim/plugged')

" Fancy prompts everywhere.
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" General plugins.
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree'
Plug 'myusuf3/numbers.vim'
Plug 'spolu/dwm.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'Valloric/YouCompleteMe'

" File type support. (Find more at github.com/sheerun/vim-polyglot.)
Plug 'tpope/vim-git', { 'for': 'git' }
Plug 'fatih/vim-go', { 'for': 'go' }
" vim-go uses CtrlP.
Plug 'ctrlpvim/ctrlp.vim', { 'for': 'go' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'keith/tmux.vim', { 'for': 'tmux' }
Plug 'solarnz/thrift.vim', { 'for': 'thrift' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'stephpy/vim-yaml', { 'for': 'yaml' }
Plug 'voxpupuli/vim-puppet', { 'for': 'puppet' }


call plug#end()

let g:ycm_autoclose_preview_window_after_insertion = 1

"""""""""""""""""""""""""""""""""""""""""""""""""
" Tabs, Indents, and Linebreaks
"""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Soft-wrap lines.
set wrap

" Wrap 2 characters from the edge.
set wrapmargin=2

" Soft-wrap only at reasonable points.
set linebreak

" Default to wrapping/formatting behavior appropriate for plain text.
" Override this for code files!
set textwidth=80

" See :help fo-table for details.
set formatoptions=tcqjn

fun! s:strip_trailing_whitespace()
    let l = line(".")
    let c = col(".")
    let s=@/
    %s/\s\+$//e
    call cursor(l, c)
    let @/=s
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""
" Universal Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""
" I never want to be in Ex mode.
nnoremap Q <nop>

" Escape insert mode with 'jj'.
inoremap jj <ESC>

" The default makes no sense.
nnoremap Y y$

" For the love of God, stop F1 from launching help.
noremap <F1> <ESC>

" No arrow keys for movement. Vi or death!
nmap <up> [e
nmap <down> ]e
nmap <left> <<
nmap <right> >>
vmap <up> [egv
vmap <down> ]egv
vmap <left> <gv
vmap <right> >gv
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Remap movement keys to work with visual, not actual, lines. (This
" makes keyboard navigation useful with auto-soft-wrapping, below.)
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Use DWM to manage splits.
let g:dwm_map_keys = 0 " Don't use the standard bindings
nmap <C-j> <C-w>w
nmap <C-k> <C-w>W
nmap <bs> <plug>DWMFocus
nmap <C-l> <plug>DWMRotateClockwise
nmap <C-c> <plug>DWMNew
nmap <C-x> <plug>DWMClose

" Which keys should wrap onto the next line?
set whichwrap=b,s,<,>,~,h,l,[,]

" Add an alias for sudo write.
cnoremap sudow w !sudo tee % >/dev/null

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom Commands, like Spacemacs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set the leader for custom commands.
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"
let maplocalleader = ","
let g:maplocalleader = ","

" Buffers: leader-b
" Jump to the existing window if possible
let g:fzf_buffers_jump = 1
nnoremap <leader>bb :Buffers<cr>

" Files: leader-f
nnoremap <leader>ff :Files<cr>
nnoremap <leader>fp :GitFiles<cr>
nnoremap <leader>fh :History<cr>
nnoremap <leader>fv :e $MYVIMRC<cr>

" Git: leader-g
nnoremap <leader>gg :Commits<cr>

" Help: leader-h
nnoremap <leader>hh :Helptags<cr>
nnoremap <leader>hk :Maps<cr>
nnoremap <leader>hc :Commands<cr>

" Misc: leader-m
nnoremap <leader>mc viw~ " capitalize a word.

" Search/Select: leader-s
nnoremap <leader>ss :Ag<Space>
nnoremap <leader>sb :BLines<Space>
nnoremap <silent> <leader>sc :nohlsearch<cr>
nnoremap <leader>sw :call <SID>strip_trailing_whitespace()<cr>
" select just-pasted blocks
nnoremap <leader>sv V`]

" Toggles: leader-t
nnoremap <leader>tn :NumbersToggle<cr>
nnoremap <leader>ts :setlocal spell!<cr>
nnoremap <leader>tu :UndotreeToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable incremental commands
set inccommand=nosplit

" Show mode and current command.
set showmode
set showcmd

" Show line numbers.
set number

" Pretty line wraps.
set showbreak=↪

"Always show current position.
set ruler

" Highlight the current line.
set cursorline

" Keep 3 lines of context at bottom of screen.
set scrolloff=3

" Show matching brackets when text indicator is over them.
set showmatch

" How many tenths of a second to blink.
set mat=2

" Don't redraw so often - especially mid-macro.
set lazyredraw

" Allow buffer switching without saving.
set hidden

" Don't harass me about errors.
set noerrorbells

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Search, Find, and Replace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ignore case unless pattern has a capital letter.
set ignorecase
set smartcase

" Show matches as pattern is typed. (NB, this is infuriating without the
" leader mapping to clear highlights.)
set showmatch

" By default, apply substitutions globally on lines.
set gdefault

" Handle common programming characters better in search expressions.
set magic

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark
colorscheme default

set fillchars+=vert:\|

hi clear IncSearch
hi def link IncSearch Search
hi clear VertSplit
hi def link VertSplit Comment
hi clear StatusLine
hi def link StatusLine ModeMsg
hi clear StatusLineNC
hi def link StatusLineNC ModeMsg

try
    lang en_US
catch
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Write out everything as a Unix file.
set ffs=unix

" Turn backup off, since important things are already
" version-controlled.
set nobackup
set nowb
set noswapfile

" Set to auto read when a file is changed from the outside.
set autoread

" Persistent undo.
set undofile

" The unnamed register is the system clipboard.
set clipboard+=unnamedplus

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spelling
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set spelllang="en_us"
set spellfile="~/.en_us.utf-8.add"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2
let g:airline_powerline_fonts = 1
