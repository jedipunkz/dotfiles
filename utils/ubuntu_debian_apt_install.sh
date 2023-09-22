#!/bin/bash

sudo apt-get update

# pyenv
sudo apt-get -y install gcc make libssl-dev libbz2-dev libreadline-dev libsqlite3-dev zlib1g-dev libffi-dev tk-dev liblzma-dev

# rbenv
sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-dev ruby-dev libxml2-dev libxslt-dev g++

# mozc util
sudo apt-get -y install mozc-utils-gui fcitx-config-gtk

# basics
sudo apt-get -y install \
    zsh \
    fish \
    git \
    tig \
    tree \
    tmux \
    htop \
    xclip \
    peco \
    bison \
    fzf \
    bat \
    exa \
    ripgrep \
    fd-find \
    luajit

# for Desktop i3
# sudo apt-get install -y xorg i3 install alsa-utils polybar feh nemo fuse fcitx-mozc xcompmgr rofi

# for Desktop sway
# sudo apt-get  install -y sway wdisplays fuse language-pack-ja nemo fonts-noto fcitx-mozc xdotool grim wofi
