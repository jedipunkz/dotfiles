if status is-interactive
    # Commands to run in interactive sessions can go here
end

# disable greeting msg
set -U fish_greeting ""

# PATH
set -x PATH $HOME/.cargo/bin $HOME/.bin /usr/local/go/bin /usr/local/bin /usr/local/sbin /opt/homebrew/bin /bin /usr/bin /sbin /usr/sbin /usr/local/sessionmanagerplugin/bin $HOME/google-cloud-sdk/bin $HOME/.local/bin

# Bind keys
# bind \t forward-char

# Alias
if test (uname -s) = "Darwin"
    alias cat="bat"
    alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
    set -x EDITOR nvim
else
    alias cat="batcat"
end

# KeyRepeat
if test (uname -s) = "Linux"
    xset r rate 190 35
    alias vim="neovim"
end

alias ls="exa"
alias lt='exa -T -L 3 -a -I "node_modules|.git|.cache" --icons'
alias vim="nvim"
alias la="ls -a"
alias l="ls -alF"
alias ssh="ssh -o UserKnownHostsFile=/dev/null -o 'StrictHostKeyChecking no'"
alias grep="grep --color"

# fzf
set -x FZF_DEFAULT_OPTS '--color fg:255,bg:236,hl:84,fg+:255,bg+:236,hl+:215  --color info:141,prompt:84,spinner:212,pointer:212,marker:212'

# perl cpanm
if test -d "$HOME/perl5/bin"
    set -x PERL_CPANM_OPT "--local-lib=~/perl5"
    set -x PATH $HOME/perl5/bin $PATH
    set -x PERL5LIB $HOME/perl5/lib/perl5 $PERL5LIB
end

# pyenv
set -x PYENV_ROOT $HOME/.pyenv
set -x PATH $PYENV_ROOT/bin $PATH
if command -v pyenv 1>/dev/null 2>&1
    switch (uname)
    case Darwin
        set -x PYENV_ROOT $HOME/.pyenv
        set -x PATH $PYENV_ROOT/bin $PATH
        # pyenv init - | source
        # source (pyenv init - | psub)
        status is-login; and pyenv init --path | source
        status is-interactive; and pyenv init - | source
    case Linux
        pyenv init - | source
        set -x PATH $PYENV_ROOT/shims $PYENV_ROOT/bin $PATH
        pyenv rehash
    end
end

# rbenv
if test -d "$HOME/.rbenv/bin"
    set -x PATH $HOME/.rbenv/bin $PATH
    rbenv init - | source
end

# nodenv
if test -d "$HOME/.nodenv"
    set -x PATH $HOME/.nodenv/bin $PATH
    nodenv init - | source
end

if test ! -d "$HOME/ghq"
    mkdir $HOME/ghq
end

# golang
if test ! -d "$HOME/go"
    mkdir $HOME/go
end
set -x GOPATH $HOME/go
set -x PATH $GOPATH/bin $PATH

# fzf
set -Ux FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"


# starship.rs
set -x STARSHIP_CONFIG ~/.starship
set -x AWS_PROFILE default
starship init fish | source
