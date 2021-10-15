if status is-interactive
    # Commands to run in interactive sessions can go here
end

# PATH
set -x PATH /opt/homebrew/bin /bin /usr/bin /sbin /usr/sbin /usr/local/bin

## vi mode
fish_vi_key_bindings
# vi modeではなんか[I]みたいなの出るからオーバーライド
function fish_mode_prompt 
end

# Alias
if test (uname -s) = "Darwin"
    alias ls="exa"
else
    alias ls="ls --color"
end

alias vim="nvim"
alias la="ls -a"
alias l="ls -alF"
alias ssh="ssh -o UserKnownHostsFile=/dev/null -o 'StrictHostKeyChecking no'"
alias grep="grep --color"

# perl cpanm
# if test "$HOME/perl5/bin"
#     set -x PERL_CPANM_OPT="--local-lib=~/perl5"
#     set -x PATH $HOME/perl5/bin $PATH;
#     set -x PERL5LIB=$HOME/perl5/lib/perl5 $PERL5LIB;
# fi

# pyenv
if test -d "$HOME/.pyenv/bin"
    set -x PYENV_ROOT = $HOME/.pyenv
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

# peco_select_history
function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'
end

# starship.rs
export STARSHIP_CONFIG=~/.starship
export AWS_PROFILE=default
starship init fish | source
