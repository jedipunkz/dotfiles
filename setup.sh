#!/bin/bash

# set envs
CONF_HOME=$(cd $(dirname "$0") && pwd)
BACKUPDIR=$HOME/.dotbackup

URL_OHMYZSH="git://github.com/robbyrussell/oh-my-zsh.git"
URL_NEOBUNDLE="git://github.com/Shougo/neobundle.vim.git"
URL_RBENV="git://github.com/sstephenson/rbenv.git"
URL_RUBY_BUILD="git://github.com/sstephenson/ruby-build.git"
URL_PYENV="git://github.com/pyenv/pyenv.git"

function chkcommand() {
    if hash $1 2>/dev/null; then
        return 0
    else
        echo "you need $1 command"
        exit 1
    fi
}

function backup() {
    if [ -e $HOME/$1 -o  -d $HOME/$1 ]; then
        mv $HOME/$1 $BACKUPDIR/$1
    fi
}

function link() {
    if [ $(uname) = 'Darwin' ]; then
        gln -is "$CONF_HOME/$1" $2 || return 1
    else
        ln -is "$CONF_HOME/$1" $2 || return 1
    fi
    return 0
}

function gitclone() {
    git clone $1 $2 || return 1
    return 0
}

function makedir() {
    if [ ! -d $1 ]; then
        mkdir $1 && chmod $2 $1 || return 1
    fi
}

chkcommand git
makedir $BACKUPDIR 0755
rm -rf $BACKUPDIR/.*
makedir $HOME/gitwork 0755

backup .oh-my-zsh
backup .emacs.d
backup .Xresources
backup .zshrc
backup .vimrc
backup .vim
backup .dir_colors
backup .tmux.conf
backup .config/powerline

makedir $HOME/.config 0755

gitclone $URL_OHMYZSH $HOME/.oh-my-zsh

link .oh-my-zsh/custom/custom-aliases.zsh $HOME/.oh-my-zsh/custom/custom-aliases.zsh
link .oh-my-zsh/custom/custom-env.zsh $HOME/.oh-my-zsh/custom/custom-env.zsh
link jedipunkz.zsh-theme $HOME/.oh-my-zsh/themes/jedipunkz.zsh-theme
link jedipunkz2.zsh-theme $HOME/.oh-my-zsh/themes/jedipunkz2.zsh-theme
link jedipunkz3.zsh-theme $HOME/.oh-my-zsh/themes/jedipunkz3.zsh-theme
link jedipunkz4.zsh-theme $HOME/.oh-my-zsh/themes/jedipunkz4.zsh-theme
link jedipunkz5.zsh-theme $HOME/.oh-my-zsh/themes/jedipunkz5.zsh-theme
link .emacs.d $HOME/.emacs.d
link .Xresources $HOME/.Xresources
link .zshrc $HOME/.zshrc
link .dir_colors $HOME/.dir_colors
link .tmux.conf $HOME/.tmux.conf
link .config/powerline $HOME/.config/powerline
link .vim $HOME/.vim
link .vimrc $HOME/.vimrc

gitclone $URL_NEOBUNDLE $HOME/.vim/bundle/neobundle.vim

if [ ! -d $HOME/.rbenv ]; then
    gitclone $URL_RBENV $HOME/.rbenv
    gitclone $URL_RUBY_BUILD $HOME/.rbenv/plugins/ruby-build
fi

if [ ! -d $HOME/.pyenv ]; then
    gitclone $URL_PYENV $HOME/.pyenv
fi
