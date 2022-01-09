#!/bin/bash

if ! [ -x "$(command -v curl)" ]; then
    echo "error: could not find curl command, install curl command." >&2
    exit 1
fi

# set envs
CONF_HOME=$(cd $(dirname "$0") && pwd)
BACKUPDIR=$HOME/.dotbackup

URL_NEOBUNDLE="https://github.com/Shougo/neobundle.vim.git"
URL_RBENV="https://github.com/sstephenson/rbenv.git"
URL_RUBY_BUILD="https://github.com/sstephenson/ruby-build.git"
URL_PYENV="https://github.com/pyenv/pyenv.git"
URL_NODENV="https://github.com/nodenv/nodenv.git"
URL_NODE_BUILD="https://github.com/nodenv/node-build.git"
URL_TPM="https://github.com/tmux-plugins/tpm"
URL_ZSHCOMP="https://github.com/zsh-users/zsh-completions.git"

function chkcommand() {
    if hash $1 2>/dev/null; then
        return 0
    else
        echo "you need $1 command"
        exit 1
    fi
}

function link() {
    if [ -e $2 ]; then
        mv  $2 "$BACKUPDIR/"
        ln -s "$CONF_HOME/$1" $2 || return 1
    else
        ln -s "$CONF_HOME/$1" $2 || return 1
    fi
    return 0
}

function gitclone() {
    if [ ! -d $2 ]; then
        git clone $1 $2 || return 1
    fi
    return 0
}

function makedir() {
    if [ ! -d $1 ]; then
        mkdir $1 && chmod $2 $1 || return 1
    fi
}

chkcommand git
makedir $HOME/gitwork 0755
makedir $BACKUPDIR 0755
makedir $HOME/.config 700

link .gtkrc-2.0 $HOME/.gtkrc-2.0
link .emacs.d $HOME/.emacs.d
link .Xresources $HOME/.Xresources
link .zshrc $HOME/.zshrc
link .dir_colors $HOME/.dir_colors
link .tmux.conf $HOME/.tmux.conf
link .tmux.conf.macos $HOME/.tmux.conf.macos
link .tmux.conf.linux $HOME/.tmux.conf.linux
link .vim $HOME/.vim
link .vimrc $HOME/.vimrc
link .vimrc.lang $HOME/.vimrc.lang
link .imwheelrc $HOME/.imwheelrc
link .starship $HOME/.starship
link .config/nvim $HOME/.config/nvim
link .config/fish $HOME/.config/fish
link .config/regolith $HOME/.config/regolith

gitclone $URL_TPM ~/.tmux/plugins/tpm
gitclone $URL_RBENV $HOME/.rbenv
gitclone $URL_RUBY_BUILD $HOME/.rbenv/plugins/ruby-build
gitclone $URL_PYENV $HOME/.pyenv
gitclone $URL_ZSHCOMP $HOME/.zsh-completions
gitclone $URL_NODENV $HOME/.nodenv
gitclone $URL_NODE_BUILD $HOME/.nodenv/plugins/node-build

