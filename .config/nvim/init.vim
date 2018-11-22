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
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'roxma/nvim-yarp' " required by ncm2
Plug 'spolu/dwm.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'trevordmiller/nova-vim'
Plug 'vim-airline/vim-airline'

" File type support. (Find more at github.com/sheerun/vim-polyglot.)
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
Plug 'keith/tmux.vim', { 'for': 'tmux' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'solarnz/thrift.vim', { 'for': 'thrift' }
Plug 'stephpy/vim-yaml', { 'for': 'yaml' }
Plug 'tpope/vim-git', { 'for': 'git' }


call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""
set autoread                    " auto read when a file is changed from the outside
set background=dark
set bs=indent,eol,start         " backspace over everything
set completeopt=noinsert,menuone,noselect,preview
set cursorline
set expandtab
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
set mouse=a                     " mouse support
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
set sb                          " split below
set scrolloff=3
set shell=/bin/zsh
set shiftwidth=4
set shortmess+=c
set showbreak=↪
set showcmd
set showmatch
set showmatch                   " highlight search matches
set showmode
set signcolumn=yes              " always draw the sign column (recommended by languageclient-neovim)
set smartcase                   " case-insensitive search unless pattern has capital
set softtabstop=4
set spellfile="~/.en_us.utf-8.add"
set spelllang="en_us"
set spr                         " split right
set tabstop=4
set textwidth=78                " default to wrapping for plain text
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
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

try
    lang en_US
catch
endtry

colorscheme nova

"""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""
" Jump to existing window if possible.
let g:fzf_buffers_jump = 1

let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#displayed_head_limit = 10
let g:airline#extensions#ale#enabled = 1

let g:LanguageClient_serverCommands = {
    \ 'go': ['~/bin/go-langserver', '-diagnostics', '-gocodecompletion', '-lint-tool', 'golint'],
    \ 'python': ['pyls'],
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ }

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
    autocmd BufEnter * call s:AddLanguageClientKeybindings()
    autocmd BufNewFile,BufRead *.bazel set filetype=bzl
    autocmd FileType go call s:SetupGo()
    autocmd FileType html call s:SetupHTML()
    autocmd FileType htmldjango call s:SetupHTML()
    autocmd FileType jinja call s:SetupHTML()
    autocmd FileType markdown call s:SetupHTML()
    autocmd FileType yaml call s:SetupYAML()
augroup end

" Highlight the current line, but only in the focused split.
augroup vimrc_cursor_hooks
    autocmd!
    autocmd WinEnter * setlocal cul
    autocmd BufEnter * setlocal cul
    autocmd WinLeave * setlocal nocul
augroup end
setlocal cul

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

" FilterQuickfix is a utility function used to define the Cfilter and Lfilter
" commands to filter the quickfix and location lists. (It's copied from the
" neovim project's runtime/pack/dist/opt/cfilter directory, which isn't
" distributed with the AppImage version of the code.)
func s:FilterQuickfix(qf, pat, bang)
    if a:qf
        let Xgetlist = function('getqflist')
        let Xsetlist = function('setqflist')
        let cmd = ':Cfilter' . a:bang
    else
        let Xgetlist = function('getloclist', [0])
        let Xsetlist = function('setloclist', [0])
        let cmd = ':Lfilter' . a:bang
    endif

    if a:bang == '!'
        let cond = 'v:val.text !~# a:pat && bufname(v:val.bufnr) !~# a:pat'
    else
        let cond = 'v:val.text =~# a:pat || bufname(v:val.bufnr) =~# a:pat'
    endif

    let items = filter(Xgetlist(), cond)
    let title = cmd . ' ' . a:pat
    call Xsetlist([], ' ', {'title' : title, 'items' : items})
endfunc

com! -nargs=+ -bang Cfilter call s:FilterQuickfix(1, <q-args>, <q-bang>)
com! -nargs=+ -bang Lfilter call s:FilterQuickfix(0, <q-args>, <q-bang>)

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

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Instead, close the menu and also start a new line.
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
" Use <TAB> to select within the popup menu.
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"""""""""""""""""""""""""""""""""""""""""""""""""
" Spacemacs-Style Commands
"""""""""""""""""""""""""""""""""""""""""""""""""
" Language Server: local leader
function! s:AddLanguageClientKeybindings()
	if has_key(g:LanguageClient_serverCommands, &filetype)
        " Use ncm2 for completion.
        call ncm2#enable_for_buffer()

		" Use the language server for `gq` formatting.
		set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

		" LSP menus.
		nnoremap <buffer> <silent> <localleader>m :call LanguageClient_contextMenu()<cr>
		nnoremap <buffer> <silent> <localleader>a :call LanguageClient#textDocument_codeAction()<cr>

		" Hover info, including short documentation.
		nnoremap <buffer> <silent> <localleader>? :call LanguageClient#textDocument_hover()<cr>

		" Jump to definition.
		nnoremap <buffer> <silent> <localleader>d :call LanguageClient#textDocument_definition()<cr>

		" Rename.
		nnoremap <buffer> <silent> <localleader>r :call LanguageClient#textDocument_rename()<cr>

		" Show symbols.
		nnoremap <buffer> <silent> <localleader>sd :call LanguageClient#textDocument_documentSymbol()<cr>
		nnoremap <buffer> <silent> <localleader>s :call LanguageClient#workspace_symbol()<cr>

		" Show references.
		nnoremap <buffer> <silent> <localleader>rf :call LanguageClient#textDocument_references()<cr>

		" Format file.
		nnoremap <buffer> <silent> <localleader>f :call LanguageClient#textDocument_formatting()<cr>
	endif
endfunction

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
nnoremap <leader>tn :NumbersToggle<cr>
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
    if has_key(g:LanguageClient_serverCommands, &filetype)
        " Show diagnostics, filtering out vendored code.
        nnoremap <buffer> <silent> <localleader>e :cw<cr>:Cfilter! vendor<cr>
    endif
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
