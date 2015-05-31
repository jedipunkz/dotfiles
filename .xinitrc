xrdb -merge $HOME/.Xresources
export DefaultImModule=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export LANG=ja_JP.UTF-8
exec i3
