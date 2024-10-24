#!/bin/bash

sudo apt-get update

# pyenv
sudo apt-get -y install gcc make libssl-dev libbz2-dev libreadline-dev libsqlite3-dev zlib1g-dev libffi-dev tk-dev liblzma-dev
# rbenv
sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-dev ruby-dev libxml2-dev libxslt-dev g++
# basics
sudo apt-get -y install zsh fish git tig tree tmux htop xclip peco bison fzf bat eza ripgrep fd-find luajit

case "$1" in
  --with-i3)
    sudo apt-get install -y xorg i3 alsa-utils polybar feh nemo fuse fcitx-mozc xcompmgr rofi mozc-utils-gui fcitx-config-gtk xdotool
    ;;
  --with-sway)
    sudo apt-get install -y sway wdisplays fuse nemo fonts-noto xdotool grim waybar fcitx5-frontend-gtk4 fcitx5-mozc wofi wl-clipboard mozc-utils-gui fcitx-config-gtk
    ;;
  *)
    # 何もしない
    ;;
esac
