" Save anytime we call :make, including vim-go's build commands.
setlocal autowrite

setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal smarttab
setlocal noexpandtab

setlocal textwidth=79
setlocal formatoptions=rq
setlocal commentstring=//\ %s

" run :GoBuild or :GoTestCompile based on the current file.
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

let g:go_fmt_command = 'goimports'
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_metalinter_autosave = 1
let g:go_term_enabled = 1

" Build/Run: b
nnoremap <localleader>bb :call <SID>build_go_files()<cr>
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
nnoremap <localleader>lm :GoMetaLinter<cr>
nnoremap <localleader>ll :GoLint<cr>
nnoremap <localleader>lv :GoVet<cr>
