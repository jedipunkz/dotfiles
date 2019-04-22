# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="jedipunkz3"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git rake ruby vagrant osx)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# set $PATH
export PATH=$HOME/usr/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games:/sbin:/usr/sbin
export TERM=xterm-256color

case "${OSTYPE}" in
freebsd*|darwin*)
    ;;
linux*)
    ;;
esac

alias ls="ls --color"
alias la="ls -a"
alias l="ls -alF"
alias ssh="ssh -o UserKnownHostsFile=/dev/null -o 'StrictHostKeyChecking no'"

export EDITOR=vim

# peco
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | eval $tac | awk '!a[$0]++' | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
if [ -x "`which peco`" ]; then
    zle -N peco-select-history
    bindkey '^r' peco-select-history
fi

# peco-ghq
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
if [ -x "`which ghq`" -a -x "`which peco`" ]; then
    zle -N peco-src
    bindkey '^G' peco-src
fi

# perl cpanm
if [ -d "$HOME/perl5/bin" ]; then
    export PERL_CPANM_OPT="--local-lib=~/perl5"
    export PATH=$HOME/perl5/bin:$PATH;
    export PERL5LIB=$HOME/perl5/lib/perl5:$PERL5LIB;
fi

# pyenv
if [ -d "$HOME/.pyenv/bin" ]; then
    PYENV_ROOT="$HOME/.pyenv"
    PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# golang
if [ -x "`which go`" ]; then
    export GOPATH=$HOME/go
    export PATH="$GOPATH/bin:$PATH"
fi

# rbenv
if [ -d "$HOME/.rbenv/bin" ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi

# .dir_colors
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
if [ -f ~/.dir_colors ]; then
    eval `dircolors -b ~/.dir_colors`
fi
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# local environment
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
