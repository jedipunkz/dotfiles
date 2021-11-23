if status is-interactive
    # Commands to run in interactive sessions can go here
end

# PATH
set -x PATH $HOME/.bin /usr/local/bin /usr/local/sbin /opt/homebrew/bin /bin /usr/bin /sbin /usr/sbin

## vi mode
# fish_vi_key_bindings
# vi modeではなんか[I]みたいなの出るからオーバーライド
# function fish_mode_prompt 
# end

# Alias
if test (uname -s) = "Darwin"
    alias ls="exa"
else
    alias ls="ls --color"
end

alias vim="nvim"
alias cat="bat"
alias la="ls -a"
alias l="ls -alF"
alias ssh="ssh -o UserKnownHostsFile=/dev/null -o 'StrictHostKeyChecking no'"
alias grep="grep --color"

# perl cpanm
if test -d "$HOME/perl5/bin"
    set -x PERL_CPANM_OPT "--local-lib=~/perl5"
    set -x PATH $HOME/perl5/bin $PATH
    set -x PERL5LIB $HOME/perl5/lib/perl5 $PERL5LIB
end

# pyenv
if test -d "$HOME/.pyenv/bin"
    set -x PYENV_ROOT $HOME/.pyenv
    set -x PATH $PYENV_ROOT/bin $PATH
    # pyenv init - | source
    status is-login; and pyenv init --path | source
    status is-interactive; and pyenv init - | source

end

# rbenv
if test -d "$HOME/.rbenv/bin"
    set -x PATH $HOME/.rbenv/bin $PATH
    rbenv init - | source
end

# gvm & golang
function gvm
  bass source ~/.gvm/scripts/gvm ';' gvm $argv
end

if test ! -d "$HOME/ghq"
    mkdir $HOME/ghq
end
set -x GOPATH $HOME/ghq
set -x PATH $GOPATH/bin $PATH

# fzf
set -Ux FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"


# starship.rs
set -x STARSHIP_CONFIG ~/.starship
set -x AWS_PROFILE default
starship init fish | source
