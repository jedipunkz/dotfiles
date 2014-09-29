" vundle settings
set nocompatible
filetype plugin indent off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
  call neobundle#rc(expand('~/.vim/bundle'))
endif

NeoBundle 'Shougo/unite.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'git://github.com/thinca/vim-quickrun.git'
NeoBundle 'git://github.com/vim-scripts/tComment'
NeoBundle 'git://github.com/kien/ctrlp.vim.git'
NeoBundle 'git://github.com/scrooloose/nerdtree.git'
NeoBundle 'git://github.com/scrooloose/syntastic.git'

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
" colorscheme molokai
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
