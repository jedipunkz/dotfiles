#!/bin/bash

if ! [ -x "$(command -v curl)" ]; then
    echo "error: could not find curl command, install curl command." >&2
    exit 1
fi

# set envs
CONF_HOME=$(cd $(dirname "$0") && pwd)
BACKUPDIR=$HOME/.dotbackup

URL_OHMYZSH="git://github.com/robbyrussell/oh-my-zsh.git"
URL_NEOBUNDLE="git://github.com/Shougo/neobundle.vim.git"
URL_RBENV="git://github.com/sstephenson/rbenv.git"
URL_RUBY_BUILD="git://github.com/sstephenson/ruby-build.git"
URL_PYENV="git://github.com/pyenv/pyenv.git"
URL_TPM="https://github.com/tmux-plugins/tpm"
URL_ZSHCOMP="https://github.com/zsh-users/zsh-completions.git"
# URL_DEIN=" https://github.com/Shougo/dein.vim.git"

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

gitclone $URL_OHMYZSH $HOME/.oh-my-zsh

link .oh-my-zsh/custom/custom-aliases.zsh $HOME/.oh-my-zsh/custom/custom-aliases.zsh
link .oh-my-zsh/custom/custom-env.zsh $HOME/.oh-my-zsh/custom/custom-env.zsh
link .oh-my-zsh/custom/themes/jedipunkz.zsh-theme $HOME/.oh-my-zsh/custom/themes/jedipunkz.zsh-theme
link .oh-my-zsh/custom/themes/jedipunkz-colorfull.zsh-theme $HOME/.oh-my-zsh/custom/themes/jedipunkz-colorfull.zsh-theme
link .oh-my-zsh/custom/themes/jedipunkz-gruvbox.zsh-theme $HOME/.oh-my-zsh/custom/themes/jedipunkz-gruvbox.zsh-theme
link .oh-my-zsh/custom/themes/gruvbox.zsh-theme $HOME/.oh-my-zsh/custom/themes/gruvbox.zsh-theme
link .oh-my-zsh/custom/themes/bullet-train.zsh-theme $HOME/.oh-my-zsh/custom/themes/bullet-train.zsh-theme
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

if [ ! -d $HOME/.config/nvim ]; then
	mkdir -p $HOME/.config/nvim
fi
link .vimrc $HOME/.config/nvim/init.vim

gitclone $URL_TPM ~/.tmux/plugins/tpm
gitclone $URL_RBENV $HOME/.rbenv
gitclone $URL_RUBY_BUILD $HOME/.rbenv/plugins/ruby-build
gitclone $URL_PYENV $HOME/.pyenv
gitclone $URL_ZSHCOMP $HOME/.zsh-completions
# gitclone $URL_DEIN $HOME/.vim/dein/repos/github.com/Shougo/dein.vim

if [ ! -d $HOME/.gvm ]; then
    bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
fi

# case "${OSTYPE}" in
# freebsd*|darwin*)
#     mv -f $HOME/.gvm/environments/default /tmp/
#     link .gvm/environments/default $HOME/.gvm/environments/default
#     echo "install starship.rs by homebrew."
#     ;;
# linux*)
#     mv -f $HOME/.gvm/environments/default /tmp/
#     link .gvm/environments/default.linux $HOME/.gvm/environments/default
#     echo 'install starship by manualy. https://starship.rs/guide/#%F0%9F%9A%80-installation'
#     ;;
# esac
