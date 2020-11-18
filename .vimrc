" dein.vim
if &compatible
  set nocompatible
endif

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

call dein#begin(expand('~/.vim/dein'))

call dein#add('Shougo/dein.vim')
call dein#add('Shougo/unite.vim')
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')
call dein#add('thinca/vim-quickrun.git')
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
call dein#add('vim-scripts/tComment')
call dein#add('kien/ctrlp.vim.git')
call dein#add('scrooloose/nerdtree.git')
" call dein#add('scrooloose/syntastic.git')
call dein#add('vim-syntastic/syntastic')
call dein#add('chase/vim-ansible-yaml')
call dein#add('hashivim/vim-terraform')
call dein#add('juliosueiras/vim-terraform-completion')
call dein#add('juliosueiras/terraform-lsp')
call dein#add('othree/yajs.vim')
call dein#add('morhetz/gruvbox')
call dein#add('nvie/vim-Flake8')
call dein#add('nathanaelkane/vim-indent-guides')
call dein#add('SirVer/ultisnips')
call dein#add('honza/vim-snippets')
call dein#add('prabirshrestha/asyncomplete.vim')
call dein#add('prabirshrestha/asyncomplete-lsp.vim')
call dein#add('prabirshrestha/vim-lsp')
call dein#add('prabirshrestha/async.vim')
call dein#add('mattn/vim-lsp-settings')
call dein#add('thomasfaingnaert/vim-lsp-snippets')
call dein#add('thomasfaingnaert/vim-lsp-ultisnips')
call dein#add('hrsh7th/vim-vsnip')
call dein#add('hrsh7th/vim-vsnip-integ')
call dein#add('mattn/vim-goimports')
call dein#add('sebdah/vim-delve')
call dein#add('go-delve/delve')
call dein#add('vim-test/vim-test')
call dein#add('tpope/vim-dispatch')

call dein#end()

" Syntastic Config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" golint
let g:syntastic_go_checkers = ['golint','govet']
" (Optional)Remove Info(Preview) window
set completeopt-=preview

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

" For snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

set completeopt+=menuone

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

" no wrap the next line for nvim
set ww=<,>,[,]

" file type plugins
filetype plugin on

" lang
source ~/.vimrc.lang

" local environment
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

