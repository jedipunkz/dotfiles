#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 back|forward"
  exit 1
fi

# 引数を変数に代入
direction=$1

# 方向に応じたキーイベントを設定
case "$direction" in
  back)
    key_event="Alt+Left"
    ;;
  forward)
    key_event="Alt+Right"
    ;;
  *)
    echo "Invalid argument. Use 'back' or 'forward'."
    exit 1
    ;;
esac

# ウィンドウがアクティブでない場合に備えてスリープを挿入
sleep 0.2  # 200 milliseconds

# アクティブウィンドウのIDを取得
active_window=$(xdotool getactivewindow)

# アクティブウィンドウのクラスを取得
window_class=$(xprop -id $active_window | grep "WM_CLASS(STRING)")

# ウィンドウクラスに"Google-chrome"が含まれているか確認
# if [[ $window_class == *'"Google-chrome"'* ]]; then
  xdotool windowactivate $active_window
  xdotool key --window $active_window $key_event
  echo $active_window
# else
#   echo "The active window is not Google Chrome."
# fi

