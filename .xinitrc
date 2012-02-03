xrdb -merge $HOME/.Xresources
#export LANG=ja_JP.UTF-8
export LANG=ja_JP.eucJP
export XMODIFIERS=@im=uim
export GTK_IM_MODULE=uim
export QT_IM_MODULE=uim
exec uim-xim &
exec uim-toolbar-gtk &
exec e16
