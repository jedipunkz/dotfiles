# Path to your oh-my-zsh configuration.
# ZSH=$HOME/.oh-my-zsh
#
# ZSH_THEME="bullet-train"
#
# BULLETTRAIN_PROMPT_ORDER=(
#     time
#     dir
#     go
#     git
#     status
# )
# BULLETTRAIN_TIME_BG=202
# BULLETTRAIN_TIME_FG=white
# BULLETTRAIN_DIR_BG=033
# BULLETTRAIN_DIR_FG=white
# BULLETTRAIN_GIT_BG=251
# BULLETTRAIN_GIT_FG=236
# BULLETTRAIN_PROMPT_SEPARATE_LINE=false
# BULLETTRAIN_PROMPT_ADD_NEWLINE=false
# BULLETTRAIN_PROMPT_CHAR=""
#
# SOLARIZED_THEME="dark"

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
# plugins=(git rake ruby vagrant osx)
#
# source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# source /Users/thirai/.oh-my-zsh/lib/completion.zsh

# starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.starship

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY
autoload -Uz colors
colors
bindkey -d  # いったんキーバインドをリセット
bindkey -e
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-style unspecified
export WORDCHARS='*?[]~=&;!#$%^(){}<>|'
my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ":chpwd:*" recent-dirs-default true
### 補完
fpath=(~/.zsh-completions $fpath)
autoload -U compinit; compinit -C
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                             /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin \
                             /usr/local/git/bin
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' completer _oldlist _complete _match _ignored _approximate _prefix
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
setopt no_beep  # 補完候補がないときなどにビープ音を鳴らさない。
setopt hist_ignore_all_dups  # 重複したヒストリは追加しない
setopt auto_cd  # ディレクトリ名だけで移動
setopt auto_pushd  # cd したら pushd
setopt auto_list  # 補完候補が複数ある時に、一覧表示
setopt auto_menu  # 補完候補が複数あるときに自動的に一覧表示する
setopt pushd_ignore_dups
setopt magic_equal_subst  # コマンドライン引数の --prefix=/usr とか=以降でも補完
setopt correct
if [[ "$CASE_SENSITIVE" = true ]]; then
  zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
else
  if [[ "$HYPHEN_INSENSITIVE" = true ]]; then
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
  else
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
  fi
fi
unset CASE_SENSITIVE HYPHEN_INSENSITIVE

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
alias grep="grep --color"
alias vim="nvim"

export EDITOR=vim

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
    # export GOPATH=$HOME/go
    export PATH="$GOPATH/bin:$PATH"
fi

# rbenv
if [ -d "$HOME/.rbenv/bin" ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi

# gvm
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

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

if [ -x /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

# for display AWS_PROFILE on prompt via starship
export AWS_PROFILE=default
#export AWS_REGION=ap-northeast-1
