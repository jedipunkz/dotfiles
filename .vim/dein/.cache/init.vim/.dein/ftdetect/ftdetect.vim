" Determine if normal YAML or Ansible YAML
" Language:        YAML (with Ansible)
" Maintainer:      Benji Fisher, Ph.D. <benji@FisherFam.org>
" Author:          Chase Colman <chase@colman.io>
" Version:         1.0
" Latest Revision: 2015-03-23
" URL:             https://github.com/chase/vim-ansible-yaml

autocmd BufNewFile,BufRead *.yml,*.yaml,*/{group,host}_vars/*  call s:SelectAnsible("ansible")
autocmd BufNewFile,BufRead hosts call s:SelectAnsible("ansible_hosts")

fun! s:SelectAnsible(fileType)
  " Bail out if 'filetype' is already set to "ansible".
  if index(split(&ft, '\.'), 'ansible') != -1
    return
  endif

  let fp = expand("<afile>:p")
  let dir = expand("<afile>:p:h")

  " Check if buffer is file under any directory of a 'roles' directory
  " or under any *_vars directory
  if fp =~ '/roles/.*\.y\(a\)\?ml$' || fp =~ '/\(group\|host\)_vars/'
    execute "set filetype=" . a:fileType . '.yaml'
    return
  endif

  " Check if subdirectories in buffer's directory match Ansible best practices
  if v:version < 704
    let directories=split(glob(fnameescape(dir) . '/{,.}*/', 1), '\n')
  else
    let directories=glob(fnameescape(dir) . '/{,.}*/', 1, 1)
  endif

  call map(directories, 'fnamemodify(v:val, ":h:t")')

  for dir in directories
    if dir =~ '\v^%(group_vars|host_vars|roles)$'
      execute "set filetype=" . a:fileType
      return
    endif
  endfor
endfun
" By default, Vim associates .tf files with TinyFugue - tell it not to.
silent! autocmd! filetypedetect BufRead,BufNewFile *.tf
autocmd BufRead,BufNewFile *.tf set filetype=terraform
autocmd BufRead,BufNewFile *.tfvars set filetype=terraform
autocmd BufRead,BufNewFile *.tfstate set filetype=json
autocmd BufRead,BufNewFile *.tfstate.backup set filetype=json
" vint: -ProhibitAutocmdWithNoGroup

" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

" Note: should not use augroup in ftdetect (see :help ftdetect)
au BufRead,BufNewFile *.go setfiletype go
au BufRead,BufNewFile *.s setfiletype asm
au BufRead,BufNewFile *.tmpl setfiletype gohtmltmpl

" remove the autocommands for modsim3, and lprolog files so that their
" highlight groups, syntax, etc. will not be loaded. *.MOD is included, so
" that on case insensitive file systems the module2 autocmds will not be
" executed.
au! BufRead,BufNewFile *.mod,*.MOD
" Set the filetype if the first non-comment and non-blank line starts with
" 'module <path>'.
au BufRead,BufNewFile go.mod call s:gomod()

fun! s:gomod()
  for l:i in range(1, line('$'))
    let l:l = getline(l:i)
    if l:l ==# '' || l:l[:1] ==# '//'
      continue
    endif

    if l:l =~# '^module .\+'
      setfiletype gomod
    endif

    break
  endfor
endfun

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
au BufRead,BufNewFile .tfcompleterc setlocal filetype=tfcompleterc
" recognize .snippet files
if has("autocmd")
    autocmd BufNewFile,BufRead *.snippets setf snippets
endif
