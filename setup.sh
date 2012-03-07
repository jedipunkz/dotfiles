#!/bin/sh

# backup old files
mkdir $HOME/dotold
mv -f $HOME/.emacs $HOME/.emacs.d $HOME/.mew-theme.el $HOME/.conkyrc \
    $HOME/.Xresources $HOME/.twmrc $HOME/.zshrc $HOME/.vimrc \
    $HOME/.vim $HOME/.screenrc $HOME/.xinitrc $HOME/.gtkrc-2.0 $HOME/.dir_colors \
    $HOME/dotold/

# download oh-my-zsh
mv $HOME/.zshrc $HOME/.zshrc.orig
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

ln -s $HOME/dotfiles/.oh-my-zsh/custom/custom-aliases.zsh $HOME/.oh-my-zsh/custom/custom-aliases.zsh
ln -s $HOME/dotfiles/.oh-my-zsh/custom/custom-env.zsh $HOME/.oh-my-zsh/custom/custom-env.zsh

# symlink to $HOME
ln -s $HOME/dotfiles/.emacs $HOME/.emacs
cp -Rp $HOME/dotfiles/.emacs.d $HOME/.emacs.d
ln -s $HOME/dotfiles/.mew-theme.el $HOME/.mew-theme.el
ln -s $HOME/dotfiles/.conkyrc $HOME/.conkyrc
ln -s $HOME/dotfiles/.Xresources $HOME/.Xresources
ln -s $HOME/dotfiles/.twmrc $HOME/.twmrc
ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc
ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc
ln -s $HOME/dotfiles/.vim $HOME/.vim
ln -s $HOME/dotfiles/.screenrc $HOME/.screenrc
ln -s $HOME/dotfiles/.xinitrc $HOME/.xinitrc
ln -s $HOME/dotfiles/.gtkrc-2.0 $HOME/.gtkrc-2.0
ln -s $HOME/dotfiles/.dir_colors $HOME/.dir_colors

# download neobundle
git clone git://github.com/Shougo/neobundle.vim.git $HOME/.vim/bundle/neobundle.vim
