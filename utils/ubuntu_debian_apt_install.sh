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
    luajit
