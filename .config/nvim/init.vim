"""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""
if isdirectory("/usr/local/opt/fzf")
  set rtp+=/usr/local/opt/fzf
endif

call plug#begin('~/.config/nvim/plugged')

" Colors.
Plug 'altercation/vim-colors-solarized'

" Fancy prompts everywhere.
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/promptline.vim'
Plug 'edkolev/tmuxline.vim'

" File type support. (Find more at github.com/sheerun/vim-polyglot.)
Plug 'tpope/vim-git'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'tejr/vim-tmux', { 'for': 'tmux' }
Plug 'solarnz/thrift.vim', { 'for': 'thrift' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'stephpy/vim-yaml', { 'for': 'yaml' }
Plug 'rodjek/vim-puppet', {'for': 'puppet'}

" Other plugins.
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree'
Plug 'myusuf3/numbers.vim'
Plug 'neomake/neomake'
Plug 'spolu/dwm.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'Valloric/YouCompleteMe'

call plug#end()

let g:go_fmt_command = "goimports"
let g:ycm_autoclose_preview_window_after_insertion = 1
autocmd! BufWritePost * Neomake

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

"""""""""""""""""""""""""""""""""""""""""""""""""
" Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""
" I never want to be in Ex mode.
nnoremap Q <nop>

" Escape insert mode with 'jj'.
inoremap jj <ESC>

" For the love of God, stop F1 from launching help.
noremap <F1> <ESC>

" Convenient sudo write alias.
cnoremap sudow w !sudo tee % >/dev/null

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set the leader for custom commands.
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"
let maplocalleader = "\<Space>"
let g:maplocalleader = "\<Space>"

" Hide search highlighting.
nnoremap <silent> <leader>/ :nohlsearch<cr>

" Strip all trailing whitespace.
nmap <leader>w :%s/\s\+$//<cr>:let @/=''<cr>:nohlsearch<cr>

" Toggle relative numbering.
nnoremap <leader>n :NumbersToggle<cr>

" Fuzzy file finder.
nmap <leader>f :GitFiles<cr>

" Fuzzy history matcher.
nmap <leader>h :History<cr>

" Select just-pasted blocks.
nnoremap <leader>v V`]

" Toggle spellcheck.
map <leader>ss :setlocal spell!<cr>

" Capitalize a word.
nnoremap <leader>` viw~

" Show the undo tree.
nnoremap <leader>u :UndotreeToggle<cr>

" Test the local Go function.
nmap <leader>t :GoTestFunc<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show mode and current command.
set showmode
set showcmd

" Show line numbers.
set number

" Pretty line wraps.
set showbreak=↪

"Always show current position.
set ruler

" Keep 3 lines of context at bottom of screen.
set scrolloff=3

" Show matching brackets when text indicator is over them.
set showmatch

" How many tenths of a second to blink.
set mat=2

" Don't redraw so often - especially mid-macro.
set lazyredraw

" Highlight current line, but only in current window.
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

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
set shell=/bin/zsh

set t_Co=256
let g:solarized_termtrans=1
set background=dark
colorscheme solarized

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
set spellfile="~/.vim/en_us.utf-8.add"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2
let g:airline_powerline_fonts = 1
