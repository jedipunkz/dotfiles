" packer
" lua require('plugins')
" lua require('lsp')

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

" telescope
" nnoremap <leader>ff <cmd>Telescope find_files previewer=bat_maker hidden=true layout_config={"prompt_position":"top"} prompt_prefix=🚀<cr>
nnoremap <leader>ff <cmd>Telescope find_files hidden=true layout_config={"prompt_position":"top","width":0.95} prompt_prefix=🚀<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" tab settings
nnoremap ,tt :<C-u>tabnew<CR>
nnoremap ,tn gt
nnoremap ,tp gT
nnoremap ,tT :<C-u>Unite tab<CR>

" Trouble
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>

" colors
set t_Co=256
syntax enable
set termguicolors
set background=dark
"colorscheme darkblue
"colorscheme desert
"set background=dark
" colorschem solarized
colorschem gruvbox
" colorschem nightfox
" colorschem dracula
"let g:solarized_termcolors=256
"colorscheme wombat256
"colorscheme wombat256mod
" colorscheme molokai
"colorscheme zenburn

set number
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

" jump
nnoremap <C-g> <C-t>

" file type plugins
filetype plugin on

" mouse disable
set mouse=

" lang
source ~/.config/nvim/lang.vim

" local environment
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE
