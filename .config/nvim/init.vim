"""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

" General plugins.
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-zsh' }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-grepper'
Plug 'ntpeters/vim-better-whitespace'
Plug 'spolu/dwm.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'

" File type support. (Find more at github.com/sheerun/vim-polyglot.)
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
Plug 'keith/tmux.vim', { 'for': 'tmux' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'stephpy/vim-yaml', { 'for': 'yaml' }
Plug 'tpope/vim-git', { 'for': 'git' }


call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""
set autoread                    " auto read when a file is changed from the outside
set background=dark
set bs=indent,eol,start         " backspace over everything
set expandtab                   " in insert mode, insert spaces instead of tabs
set ffs=unix                    " write out everything as a Unix file
set formatoptions=tcqjn         " see :help fo-table for details
set gdefault                    " default to global substitutions
set hidden                      " allow buffer switching without saving
set ignorecase                  " clear default
set inccommand=nosplit          " enable incremental commands
set laststatus=2                " always show status line
set lazyredraw                  " don't redraw so often, especially mid-macro
set linebreak                   " soft-wrap only at reasonable points
set magic                       " handle common programming characters better in search expressions
set mat=2                       " how many tenths of a second to blink
set mouse=a                     " enable mouse support
set nobackup                    " no backups
set noerrorbells                " don't harass me about errors
set nojoinspaces                " only barbarians double-space between sentences
set noswapfile
set nowb                        " no backups before write
set nu                          " absolute numbering for current line
set number                      " always show line numbers
set rnu                         " relative line numbering
set ru                          " always show cursor position
set ruler                       " show current position
set scrolloff=3
set shell=/bin/zsh
set shiftwidth=4
set showbreak=↪
set showcmd
set showmatch                   " highlight search matches
set showmode                    " show the current mode
set smartcase                   " case-insensitive search unless pattern has capital
set softtabstop=4
set spellfile="~/.en_us.utf-8.add"
set spelllang="en_us"
set spr                         " split right
set tabstop=4
set textwidth=79                " default to wrapping for plain text
set undofile                    " persistent undo
set ve=all                      " virtualedit
set whichwrap=b,s,<,>,~,h,l,[,] " which keys should wrap onto the next line?
set wrap                        " soft-wrap lines
set wrapmargin=2                " wrap 2 characters from the edge

" Use true color if not on Terminal.app.
if $TERM_PROGRAM != "Apple_Terminal"
    set termguicolors
endif

" Show invisible characters.
set list lcs=tab:»\ ,trail:·

" File patterns to ignore in wildcard expansions.
set wig+=*/dist,*.o,*.class,*.pyc,*.pyo

" Use global Python, so plugins work in virtualenvs.
let g:python_host_prog = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'

try
    lang en_US
catch
endtry

colorscheme nord

"""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""
" Jump to existing window if possible.
let g:fzf_buffers_jump = 1

let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#displayed_head_limit = 10
let g:airline#extensions#ale#enabled = 1

let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_term_enabled = 1

let g:go_highlight_generate_tags = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1

let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_chan_whitespace_error = 0
let g:go_highlight_space_tab_error = 0
let g:go_highlight_trailing_whitespace_error = 0

let g:grepper =
            \ {
            \ 'tools': ['rg', 'ag', 'git'],
            \ 'open': 1,
            \ 'switch': 1,
            \ 'jump': 0,
            \ 'dir': 'file',
            \ }

"""""""""""""""""""""""""""""""""""""""""""""""""
" Global Autocommands and Functions
"""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrc_ft_hooks
    autocmd!
    autocmd BufNewFile,BufRead *.bazel set filetype=bzl
    autocmd BufNewFile,BufRead *.mod set filetype=go
    autocmd FileType go call s:SetupGo()
    autocmd FileType html call s:SetupHTML()
    autocmd FileType htmldjango call s:SetupHTML()
    autocmd FileType jinja call s:SetupHTML()
    autocmd FileType markdown call s:SetupHTML()
    autocmd FileType yaml call s:SetupYAML()
augroup end

augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup end

" Trigger :checktime when changing buffers or coming back to vim.
augroup AutoReload
    autocmd!
    autocmd FocusGained,BufEnter * :checktime
augroup end

function! s:ClosePreview()
    if pumvisible() == 0 && bufname('%') != "[Command Line]"
        silent! pclose
    endif
endfunction

" ClosePreviewOnMove closes the preview window once the cursor moves.
function! s:ClosePreviewOnMove()
    autocmd CursorMovedI <buffer> call s:ClosePreview()
    autocmd InsertLeave  <buffer> call s:ClosePreview()
endfunction

" MkNonExDir creates the parent directories for the given file if they don't
" already exist.
function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction

" Run :GoBuild or :GoTestCompile based on the current file.
function! s:BuildGoFile()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
        call go#cmd#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
        call go#cmd#Build(0)
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""
" Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = "\<Space>"
let maplocalleader = ","

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
nmap <C-h> <plug>DWMFocus
nmap <C-l> <plug>DWMRotateClockwise
nmap <C-c> <plug>DWMNew
nmap <C-x> <plug>DWMClose

" Clear highlights on enter.
nnoremap <silent> <CR> :nohlsearch<CR><CR>

" Yank and paste operations preceded by <leader> should use system clipboard.
nnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
vnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Sudo, then write.
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Populate Grepper search.
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

"""""""""""""""""""""""""""""""""""""""""""""""""
" Spacemacs-Style Commands
"""""""""""""""""""""""""""""""""""""""""""""""""
" Buffers: leader-b
nnoremap <leader>bb :Buffers<cr>

" Files: leader-f
nnoremap <leader>ff :Files<cr>
nnoremap <leader>fp :GitFiles<cr>
nnoremap <leader>fh :History<cr>
nnoremap <leader>fv :e $MYVIMRC<cr>
nnoremap <leader>fs :source $MYVIMRC<cr>

" Git: leader-g
nnoremap <leader>gc :Commits<cr>

" Help: leader-h
nnoremap <leader>hh :Helptags<cr>
nnoremap <leader>hk :Maps<cr>
nnoremap <leader>hc :Commands<cr>

" Misc: leader-m
" Capitalize a word.
nnoremap <leader>mc viw~
" Capitalize a Word.
nnoremap <leader>mC viW~

" Search/Select: leader-s
nnoremap <leader>ss :Grepper -tool rg<cr>
nnoremap <leader>sb :BLines<cr>
nnoremap <leader>sw :StripWhitespace<cr>
" Select just-pasted blocks.
nnoremap <leader>sv V`]

" Toggles: leader-t
nnoremap <leader>ts :setlocal spell!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
" Language-Specific Setup Functions
"""""""""""""""""""""""""""""""""""""""""""""""""
function! s:SetupGo()
    call s:ClosePreviewOnMove()

    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal shiftwidth=2
    setlocal smarttab
    setlocal noexpandtab
    setlocal formatoptions=rq
    setlocal commentstring=//\ %s
    setlocal nolist

    " Build: b
    nnoremap <localleader>bb :call <SID>BuildGoFile()<cr>
    nnoremap <localleader>bg :GoGenerate<cr>
    nnoremap <localleader>bp :GoPlay<cr>
    nnoremap <localleader>br :GoRun<cr>

    " Files: f
    nnoremap <localleader>fa :GoAlternate<cr>

    " GoDef: g
    nnoremap <localleader>gb :GoDefPop<cr>
    nnoremap <localleader>gc :GoCallers<cr>
    nnoremap <localleader>gd :GoDef<cr>
    nnoremap <localleader>gi :GoDescribe<cr>
    nnoremap <localleader>gr :GoReferrers<cr>
    nnoremap <localleader>gs :GoDefStack<cr>

    " Refactor: r
    nnoremap <localleader>ri :GoImpl<cr>
    nnoremap <localleader>rr :GoRename<cr>

    " Search: s
    nnoremap <localleader>sd :GoDecls<cr>
    nnoremap <localleader>sdd :GoDeclsDir<cr>

    " Testing: t
    nnoremap <localleader>tt :GoTest<cr>
    nnoremap <localleader>tf :GoTestFunc<cr>
    nnoremap <localleader>tc :GoCoverageToggle<cr>
    nnoremap <localleader>tb :GoCoverageBrowser<cr>

    " Linting: l
    nnoremap <localleader>ll :GoLint<cr>
    nnoremap <localleader>lv :GoVet<cr>
endfunction

function! s:SetupHTML()
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal shiftwidth=2
endfunction

function! s:SetupYAML()
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal shiftwidth=2
endfunction
