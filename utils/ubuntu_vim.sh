#!/bin/bash

sudo apt-get remove vim vim-runtime vim-tiny vim-common
sudo apt-get install libncurses5-dev python-dev liblua5.3-dev lua5.3 python3-dev libssl-dev

sudo ln -s /usr/include/lua5.3 /usr/include/lua
sudo ln -s /usr/lib/x86_64-linux-gnu/liblua5.3.so /usr/local/lib/liblua.so

./configure --with-features=huge \
            --enable-multibyte \
            --enable-luainterp \
            --enable-rubyinterp=yes \
            --enable-python3interp=yes \
            --with-python3-config-dir=$(python3-config --configdir) \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-cscope \
            --enable-fontset \
            --enable-terminal \
            --prefix=/usr/local

make
sudo make install
