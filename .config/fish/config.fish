if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_greeting ""

# PATH
set -x PATH $HOME/.bin /usr/local/bin /usr/local/sbin /opt/homebrew/bin /bin /usr/bin /sbin /usr/sbin

# Bind keys
# bind \t forward-char

# Alias
if test (uname -s) = "Darwin"
    alias ls="exa"
    alias cat="bat"
    alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
    set -x EDITOR nvim
else
    alias ls="ls --color"
    alias cat="batcat"
end

alias vim="nvim"
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

# nodenv
if test -d "$HOME/.nodenv"
    set -x PATH $HOME/.nodenv/bin $PATH
    nodenv init - | source
end

if test ! -d "$HOME/ghq"
    mkdir $HOME/ghq
end
set -x GOPATH $HOME/ghq
set -x PATH $GOPATH/bin $PATH

# starship.rs
set -x STARSHIP_CONFIG ~/.starship
set -x AWS_PROFILE default
starship init fish | source
