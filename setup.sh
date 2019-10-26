#!/bin/bash

# set envs
CONF_HOME=$(cd $(dirname "$0") && pwd)
BACKUPDIR=$HOME/.dotbackup

URL_OHMYZSH="git://github.com/robbyrussell/oh-my-zsh.git"
URL_NEOBUNDLE="git://github.com/Shougo/neobundle.vim.git"
URL_RBENV="git://github.com/sstephenson/rbenv.git"
URL_RUBY_BUILD="git://github.com/sstephenson/ruby-build.git"
URL_PYENV="git://github.com/pyenv/pyenv.git"
URL_TPM="https://github.com/tmux-plugins/tpm"

function chkcommand() {
    if hash $1 2>/dev/null; then
        return 0
    else
        echo "you need $1 command"
        exit 1
    fi
}

function link() {
    if [ ! -h $2 ]; then
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

gitclone $URL_OHMYZSH $HOME/.oh-my-zsh

link .oh-my-zsh/custom/custom-aliases.zsh $HOME/.oh-my-zsh/custom/custom-aliases.zsh
link .oh-my-zsh/custom/custom-env.zsh $HOME/.oh-my-zsh/custom/custom-env.zsh
link .oh-my-zsh/custom/themes/jedipunkz.zsh-theme $HOME/.oh-my-zsh/custom/themes/jedipunkz.zsh-theme
link .oh-my-zsh/custom/themes/jedipunkz-colorfull.zsh-theme $HOME/.oh-my-zsh/custom/themes/jedipunkz-colorfull.zsh-theme
link .oh-my-zsh/custom/themes/jedipunkz-gruvbox.zsh-theme $HOME/.oh-my-zsh/custom/themes/jedipunkz-gruvbox.zsh-theme
link .oh-my-zsh/custom/themes/gruvbox.zsh-theme $HOME/.oh-my-zsh/custom/themes/gruvbox.zsh-theme
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

gitclone $URL_TPM ~/.tmux/plugins/tpm
gitclone $URL_NEOBUNDLE $HOME/.vim/bundle/neobundle.vim
gitclone $URL_RBENV $HOME/.rbenv
gitclone $URL_RUBY_BUILD $HOME/.rbenv/plugins/ruby-build
gitclone $URL_PYENV $HOME/.pyenv
