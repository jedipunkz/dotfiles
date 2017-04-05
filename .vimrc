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
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'thinca/vim-quickrun.git'
NeoBundle 'vim-scripts/tComment'
NeoBundle 'kien/ctrlp.vim.git'
NeoBundle 'scrooloose/nerdtree.git'
NeoBundle 'scrooloose/syntastic.git'
NeoBundle 'chase/vim-ansible-yaml'

NeoBundle 'Shougo/vimproc', {
    \ 'build' : {
    \     'windows' : 'make -f make_mingw32.mak',
    \     'cygwin' : 'make -f make_cygwin.mak',
    \     'mac' : 'make -f make_mac.mak',
    \     'unix' : 'make -f make_unix.mak',
    \    },
    \ }
NeoBundle 'kevinw/pyflakes-vim', {
    \ 'build' : {
    \     'mac' : 'git submodule update --init',
    \     'unix' : 'git submodule update --init',
    \    },
    \ }
NeoBundle 'davidhalter/jedi-vim', {
    \ 'build' : {
    \     'mac' : 'git submodule update --init',
    \     'unix' : 'git submodule update --init',
    \    },
    \ }

call neobundle#end()

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
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ }

" unite settings
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>

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
"colorscheme molokai
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

" IME Off
if has('mac')
  set ttimeoutlen=1
  let g:imeoff = 'osascript -e "tell application \"System Events\" to key code 102"'
  augroup MyIMEGroup
    autocmd!
    autocmd InsertLeave * :call system(g:imeoff)
  augroup END
  noremap <silent> <ESC> <ESC>:call system(g:imeoff)<CR>
endif
