if has("autocmd")
  autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cs         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType diff       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType gitconfig  setlocal ts=4 noet
  autocmd FileType html       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType java       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et
  autocmd FileType typescript setlocal sw=2 sts=2 ts=2 et
  autocmd FileType perl       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType php        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType haml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType sql        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType xhtml      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xml        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType yaml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scala      setlocal sw=2 sts=2 ts=2 et
  autocmd FileType gitconfig  setlocal sw=4 sts=4 ts=4 noet
  autocmd FileType go         setlocal sw=4 sts=4 ts=4 noet
  autocmd FileType markdown   setlocal sw=4 sts=4 ts=4 et tw=0
  autocmd FileType rst        setlocal sw=4 sts=4 ts=4 et tw=0
  autocmd FileType textile    setlocal sw=4 sts=4 ts=4 et tw=0
  autocmd FileType terraform  setlocal sw=2 sts=2 ts=2 et
endif

" language server                                                                                                          
function! s:on_lsp_buffer_enabled() abort                                                                                  
  setlocal omnifunc=lsp#complete                                                                                           
  setlocal signcolumn=yes                                                                                                  
  nmap <buffer> gd <plug>(lsp-definition)                                                                                  
  nmap <buffer> <C-]> <plug>(lsp-definition)                                                                               
  nmap <buffer> <f2> <plug>(lsp-rename)                                                                                    
  nmap <buffer> <Leader>d <plug>(lsp-type-definition)                                                                      
  nmap <buffer> <Leader>r <plug>(lsp-references)                                                                           
  nmap <buffer> <Leader>i <plug>(lsp-implementation)                                                                       
  inoremap <expr> <cr> pumvisible() ? "\<c-y>\<cr>" : "\<cr>"                                                              
endfunction                                                                                                                
                                                                                                                           
augroup lsp_install                                                                                                        
  au!                                                                                                                      
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()                                                           
augroup END                                                                                                                
command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')                                           
                                                                                                                           
let g:lsp_diagnostics_enabled = 1                                                                                          
let g:lsp_diagnostics_echo_cursor = 1                                                                                      
" let g:asyncomplete_auto_popup = 1                                                                                        
" let g:asyncomplete_auto_completeopt = 0                                                                                  
let g:asyncomplete_popup_delay = 200                                                                                       
let g:lsp_text_edit_enabled = 1                                                                                            
let g:lsp_preview_float = 1                                                                                                
let g:lsp_diagnostics_float_cursor = 1                                                                                     
let g:lsp_settings_filetype_go = ['gopls', 'golangci-lint-langserver']                                                     
                                                                                                                           
let g:lsp_settings = {}                                                                                                    
let g:lsp_settings['gopls'] = {                                                                                            
  \  'workspace_config': {                                                                                                 
  \    'usePlaceholders': v:true,                                                                                          
  \    'analyses': {                                                                                                       
  \      'fillstruct': v:true,                                                                                             
  \    },                                                                                                                  
  \  },                                                                                                                    
  \  'initialization_options': {                                                                                           
  \    'usePlaceholders': v:true,                                                                                          
  \    'analyses': {                                                                                                       
  \      'fillstruct': v:true,                                                                                             
  \    },                                                                                                                  
  \  },                                                                                                                    
  \}

" Terraform
au BufRead,BufNewFile *.tf setlocal filetype=terraform
let g:terraform_fmt_on_save=1
" 'juliosueiras/vim-terraform-completion'
" (Optional)Hide Info(Preview) window after completions
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" (Optional) Enable terraform plan to be include in filter
let g:syntastic_terraform_tffilter_plan = 1
" (Optional) Default: 0, enable(1)/disable(0) plugin's keymapping
let g:terraform_completion_keys = 1
" (Optional) Default: 1, enable(1)/disable(0) terraform module registry completion
let g:terraform_registry_module_completion = 0

" Golang
" Test
let test#strategy = "dispatch"
let test#go#runner = 'gotest'

nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
" tのあとにCTRL+dでテストをデバッガ経由で実行する
function! DebugNearest()
  let g:test#go#runner = 'delve'
  TestNearest
  unlet g:test#go#runner
endfunction
nmap <silent> t<C-d> :call DebugNearest()<CR>

au filetype go inoremap <buffer> . .<C-x><C-o>

let g:go_bin_path = $GOPATH.'/bin'
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" goimports
" let g:go_fmt_command = "goimports"
" set rtp+=~/ghq/golang.org/x/lint/misc/vim
" autocmd BufWritePost,FileWritePost *.go execute 'Lint' | cwindow
" mattn/vim-goimports
let g:goimports = 1
" let g:goimports_simplify = 1

" quickrun
let g:quickrun_config = get(g:, 'quickrun_config', {})

" quickrunのランナーにvimprocを使用する
" 成功時はバッファへ
" エラー時はquickfixへ出力
let g:quickrun_config._ = {
\   'runner'    : 'vimproc',
\   'runner/vimproc/updatetime' : 60,
\   'outputter' : 'error',
\   'outputter/error/success' : 'buffer',
\   'outputter/error/error'   : 'quickfix',
\   'outputter/buffer/split'  : ':rightbelow 8sp',
\   'outputter/buffer/close_on_empty' : 1,
\}

" quickrunにgo buildを登録
let g:quickrun_config["gobuild"] = {
\   'command': 'go',
\   'cmdopt' : './...',
\   'exec': '%c build %o',
\}

"" *.goファイルを保存したら非同期にgo buildを実行
" autocmd BufWritePost *.go :QuickRun gobuild

" Python
" https://qiita.com/lighttiger2505/items/3065164798bc9cd615d4
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_virtual_text_enabled = 1
let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '‼'}
let g:lsp_signs_information = {'text': 'i'}
let g:lsp_signs_hint = {'text': '?'}

if (executable('pyls'))
    augroup LspPython
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'pyls',
            \ 'cmd': { server_info -> ['pyls'] },
            \ 'whitelist': ['python'],
            \})
    augroup END
endif

" 定義ジャンプ(デフォルトのctagsによるジャンプを上書きしているのでこのあたりは好みが別れます)
nnoremap <C-]> :<C-u>LspDefinition<CR>
" 定義情報のホバー表示
nnoremap K :<C-u>LspHover<CR>
" 名前変更
nnoremap <LocalLeader>R :<C-u>LspRename<CR>
" 参照検索
nnoremap <LocalLeader>n :<C-u>LspReferences<CR>
" Lint結果をQuickFixで表示
nnoremap <LocalLeader>f :<C-u>LspDocumentDiagnostics<CR>
" テキスト整形
nnoremap <LocalLeader>s :<C-u>LspDocumentFormat<CR>
" オムニ補完を利用する場合、定義の追加
set omnifunc=lsp#complete

" Rust
syntax enable
filetype plugin indent on
let g:rustfmt_autosave = 1

