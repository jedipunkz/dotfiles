#!/bin/bash

sudo apt-get update

# pyenv
sudo apt-get -y install gcc make libssl-dev libbz2-dev libreadline-dev libsqlite3-dev zlib1g-dev libffi-dev

# rbenv
sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-dev ruby-dev libxml2-dev libxslt-dev g++

# basics
sudo apt-get -y install zsh git tig tmux htop xclip peco bison
