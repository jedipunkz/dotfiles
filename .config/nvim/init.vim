" vundle settings
" set nocompatible
" filetype plugin indent on
"
" if has('vim_starting')
"   set nocompatible
"   set runtimepath+=~/.vim/bundle/neobundle.vim/
" endif
"
" " Required:
" call neobundle#begin(expand('~/.vim/bundle/'))
"
" NeoBundle 'Shougo/unite.vim'
" NeoBundle 'vim-airline/vim-airline'
" NeoBundle 'vim-airline/vim-airline-themes'
" NeoBundle 'thinca/vim-quickrun.git'
" NeoBundle 'vim-scripts/tComment'
" NeoBundle 'kien/ctrlp.vim.git'
" NeoBundle 'scrooloose/nerdtree.git'
" NeoBundle 'scrooloose/syntastic.git'
" NeoBundle 'chase/vim-ansible-yaml'
" " NeoBundle 'Valloric/YouCompleteMe'
" NeoBundle 'Shougo/neocomplete.vim'
" NeoBundle 'hashivim/vim-terraform'
" NeoBundle 'juliosueiras/vim-terraform-completion'
" NeoBundle 'kchmck/vim-coffee-script'
" NeoBundle 'othree/yajs.vim'
" NeoBundle 'morhetz/gruvbox'
" NeoBundle 'davidhalter/jedi-vim'
" NeoBundle 'nvie/vim-flake8'
" NeoBundle 'nathanaelkane/vim-indent-guides'
" NeoBundle 'SirVer/ultisnips'
" NeoBundle 'honza/vim-snippets'
" NeoBundle 'fatih/vim-go'
"
" NeoBundleLazy 'fatih/vim-go', {
"             \ 'autoload' : { 'filetypes' : 'go'  }
"             \ }
"
" call neobundle#end()

" dein.vim
if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/dein'))

call dein#add('Shougo/dein.vim')
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/deoplete.nvim')
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')
call dein#add('thinca/vim-quickrun.git')
call dein#add('vim-scripts/tComment')
call dein#add('kien/ctrlp.vim.git')
call dein#add('scrooloose/nerdtree.git')
call dein#add('scrooloose/syntastic.git')
call dein#add('chase/vim-ansible-yaml')
call dein#add('hashivim/vim-terraform')
call dein#add('juliosueiras/vim-terraform-completion')
call dein#add('othree/yajs.vim')
call dein#add('morhetz/gruvbox')
call dein#add('davidhalter/jedi-vim')
call dein#add('nvie/vim-Flake8')
call dein#add('nathanaelkane/vim-indent-guides')
call dein#add('SirVer/ultisnips')
call dein#add('honza/vim-snippets')
call dein#add('fatih/vim-go')

call dein#end()

" Syntastic Config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" (Optional)Remove Info(Preview) window
set completeopt-=preview

" deoplete.nvim
let g:deoplete#enable_at_startup = 1

" NeoComplete
" Disable AutoComplPop.
" let g:acp_enableAtStartup = 0
" " Use neocomplete.
" let g:neocomplete#enable_at_startup = 1
" " Use smartcase.
" let g:neocomplete#enable_smart_case = 1
" " Set minimum syntax keyword length.
" let g:neocomplete#sources#syntax#min_keyword_length = 3
" " Enable omni completion.
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" " Enable heavy omni completion.
" if !exists('g:neocomplete#sources#omni#input_patterns')
"   let g:neocomplete#sources#omni#input_patterns = {}
" endif
" " golang omni completion
" let g:neocomplete#sources#omni#input_patterns.go = '\h\w\.\w*'
" " Plugin key-mappings.
" inoremap <expr><C-g>     neocomplcache#undo_completion()
" inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
imap <C-f> <C-x><C-o>
" <CR>: close popup and save indent.
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function()
"   return neocomplcache#smart_close_popup() . "\<CR>"
" endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
" inoremap <expr><C-y>  neocomplcache#close_popup()
" inoremap <expr><C-e>  neocomplcache#cancel_popup()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
" NeoBundleCheck

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='base16'
" カーソルキーでbuffer移動
nnoremap <Left> :bp<CR>
nnoremap <Right> :bn<CR>

" unite settings
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>
nnoremap <silent> ,uu :<C-u>Unite file buffer<CR>
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
    nmap <buffer> <ESC> <Plug>(unite_exit)
endfunction"}}}

" jedi-vim
set completeopt=menuone
autocmd! User jedi-vim call s:jedivim_hook()
function! s:jedivim_hook()
  let g:jedi#auto_initialization    = 0 " 自動で実行される初期化処理を無効
  let g:jedi#auto_vim_configuration = 0 " 'completeopt' オプションを上書きしない
  let g:jedi#popup_on_dot           = 0 " ドット(.)を入力したとき自動で補完しない
  let g:jedi#popup_select_first     = 0 " 補完候補の1番目を選択しない
  let g:jedi#show_call_signatures   = 0 " 関数の引数表示を無効(ポップアップのバグを踏んだことがあるため)
  autocmd FileType python setlocal omnifunc=jedi#completions   " 補完エンジンはjediを使う
endfunction
let g:jedi#goto_command = "<C-]>"
let g:jedi#goto_assignments_command = "<Localleader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<Localleader>n"
let g:jedi#rename_command = "<Localleader>R" " quickrun と衝突するので回避

" tab settings
nnoremap ,tt :<C-u>tabnew<CR>
nnoremap ,tn gt
nnoremap ,tp gT
nnoremap ,tT :<C-u>Unite tab<CR>

" colors
set t_Co=256
syntax enable
set background=dark
"colorscheme darkblue
"colorscheme desert
"set background=dark
" colorschem solarized
colorschem gruvbox
"let g:solarized_termcolors=256
"colorscheme wombat256
"colorscheme wombat256mod
" colorscheme molokai
"colorscheme zenburn

"set number
set ruler
set autoread
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8Pset ambiwidth=double
set wildmenu
set wildmode=list:longest,full

" search
set ignorecase
set smartcase
set nowrapscan
set hlsearch
set incsearch

" backup
set nobackup
set noswapfile

" edit
"set list
"set listchars=tab:>-,extends:<,trail:-,eol:\--
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
inoremap <C-k> <C-o>D
inoremap <C-u> <C-o>d0

"set autoindent
"set cindent
set backspace=indent,eol,start
set showmatch
set whichwrap=b,s,h,l,<,>,[,]
set showcmd
set showmode

" buffer
set hidden

" status line
set nocompatible " Disable vi-compatibility
set laststatus=2 " Always show the statusline

" :IndentGuideDisable
let g:indent_guides_enable_on_vim_startup = 0

" call Flake8
nnoremap  <leader>l :call Flake8()

" UltiSnips
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Golang
" let g:go_fmt_command = "goimports"
" set rtp+=~/ghq/golang.org/x/lint/misc/vim
" autocmd BufWritePost,FileWritePost *.go execute 'Lint' | cwindow

" file type plugins
filetype plugin on

" lang
source ~/.vimrc.lang

" local environment
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

