" vundle settings
set nocompatible
filetype plugin indent off

if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
 call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundle 'Shougo/unite.vim'
" NeoBundle 'itchyny/lightline.vim'
NeoBundle 'vim-airline/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'
NeoBundle 'thinca/vim-quickrun.git'
NeoBundle 'vim-scripts/tComment'
NeoBundle 'kien/ctrlp.vim.git'
NeoBundle 'scrooloose/nerdtree.git'
NeoBundle 'scrooloose/syntastic.git'
NeoBundle 'chase/vim-ansible-yaml'
" NeoBundle 'Valloric/YouCompleteMe'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'hashivim/vim-terraform'
NeoBundle 'kchmck/vim-coffee-script'
" NeoBundle 'wsdjeg/FlyGrep.vim'

" NeoBundle 'Shougo/vimproc', {
"     \ 'build' : {
"     \     'windows' : 'make -f make_mingw32.mak',
"     \     'cygwin' : 'make -f make_cygwin.mak',
"     \     'mac' : 'make -f make_mac.mak',
"     \     'unix' : 'make -f make_unix.mak',
"     \    },
"     \ }
" NeoBundle 'kevinw/pyflakes-vim', {
"     \ 'build' : {
"     \     'mac' : 'git submodule update --init',
"     \     'unix' : 'git submodule update --init',
"     \    },
"     \ }
" NeoBundle 'davidhalter/jedi-vim', {
"     \ 'build' : {
"     \     'mac' : 'git submodule update --init',
"     \     'unix' : 'git submodule update --init',
"     \    },
"     \ }

call neobundle#end()

" NeoComplete
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

" jedi , quickrun conflict
command! -nargs=0 JediRename :call jedi#rename()
let g:jedi#rename_command = ""

" pyflake
let g:syntastic_mode_map = {
            \ 'mode': 'active',
            \ 'active_filetypes': ['php', 'coffeescript', 'sh', 'vim'],
            \ 'passive_filetypes': ['html', 'haskell', 'python']
            \}

" lightline theme
" let g:lightline = {
"       \ 'colorscheme': 'solarized',
"       \ }

" airline
" let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='powerlineish'
" let g:airline_solarized_bg='dark'

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

"filetype plugin indent on

set t_Co=256
syntax enable
set background=dark

syntax enable
"colorscheme darkblue
"colorscheme desert
"set background=dark
colorscheme solarized
"let g:solarized_termcolors=256
"colorscheme wombat256
"colorscheme wombat256mod
" colorscheme molokai
"colorscheme zenburn
if &diff
        colorscheme leo
endif

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

" file type plugins
filetype plugin on

" terraform syntax "
au BufRead,BufNewFile *.tf setlocal filetype=terraform
:autocmd FileType terraform set shiftwidth=2
:autocmd FileType terraform set softtabstop=2
:autocmd FileType terraform set autoindent
:autocmd FileType terraform set smartindent
:autocmd FileType terraform set expandtab
:autocmd FileType terraform map <leader>k :w<CR>:Tabularize /=<CR>

" powerline
" python from powerline.vim import setup as powerline_setup
" python powerline_setup()
" python del powerline_setup
" set laststatus=2 " Always display the statusline in all windows
" set showtabline=2 " Always display the tabline, even if there is only one tab
" set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

" IME Off
" if has('mac')
"   set ttimeoutlen=1
"   let g:imeoff = 'osascript -e "tell application \"System Events\" to key code 102"'
"   augroup MyIMEGroup
"     autocmd!
"     autocmd InsertLeave * :call system(g:imeoff)
"   augroup END
"   noremap <silent> <ESC> <ESC>:call system(g:imeoff)<CR>
" endif
