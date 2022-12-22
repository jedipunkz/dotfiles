#!/bin/bash

# set envs
CONF_HOME=$(cd $(dirname "$0") && pwd)

URL_RBENV="https://github.com/sstephenson/rbenv.git"
URL_RUBY_BUILD="https://github.com/sstephenson/ruby-build.git"
URL_PYENV="https://github.com/pyenv/pyenv.git"
URL_NODENV="https://github.com/nodenv/nodenv.git"
URL_NODE_BUILD="https://github.com/nodenv/node-build.git"
URL_TPM="https://github.com/tmux-plugins/tpm"
URL_ZSHCOMP="https://github.com/zsh-users/zsh-completions.git"
URL_PACKER="https://github.com/wbthomason/packer.nvim"

function chkcommand() {
    if hash $1 2>/dev/null; then
        return 0
    else
        echo "you need $1 command"
        exit 1
    fi
}

function link() {
    ln -f -s "$CONF_HOME/$1" $2 || return 1
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

function backup() {
    if [ -d $1 ]; then
        rm -rf $2
        mv $1 $2
    fi
}

chkcommand curl
chkcommand git

makedir $HOME/dotfiles.backup 0755
backup $HOME/.config $HOME/dotfiles.backup/.config
backup $HOME/.emacs.d $HOME/dotfiles.backup/.emacs.d

makedir $HOME/gitwork 0755
makedir $HOME/.config 700

if [ "`uname`" == "Linux" ]; then
    link .gtkrc-2.0 $HOME/.gtkrc-2.0
    link .Xresources $HOME/.Xresources
    link .imwheelrc $HOME/.imwheelrc
    link .config/regolith $HOME/.config/regolith
fi

link .emacs.d $HOME/.emacs.d
link .zshrc $HOME/.zshrc
link .dir_colors $HOME/.dir_colors
link .tmux.conf $HOME/.tmux.conf
link .tmux.conf.macos $HOME/.tmux.conf.macos
link .tmux.conf.linux $HOME/.tmux.conf.linux
link .starship $HOME/.starship
link .vim $HOME/.vim
link .config/nvim $HOME/.config/nvim
link .config/fish $HOME/.config/fish
link .config/alacritty $HOME/.config/alacritty

gitclone $URL_TPM ~/.tmux/plugins/tpm
gitclone $URL_RBENV $HOME/.rbenv
gitclone $URL_RUBY_BUILD $HOME/.rbenv/plugins/ruby-build
gitclone $URL_PYENV $HOME/.pyenv
gitclone $URL_ZSHCOMP $HOME/.zsh-completions
gitclone $URL_NODENV $HOME/.nodenv
gitclone $URL_NODE_BUILD $HOME/.nodenv/plugins/node-build
gitclone $URL_PACKER $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim

