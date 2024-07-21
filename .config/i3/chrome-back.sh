#!/bin/bash
sleep 0.2  # 200 milliseconds
active_window=$(xdotool getactivewindow)
window_class=$(xprop -id $active_window | grep "WM_CLASS(STRING)")

if [[ $window_class == *'"Google-chrome"'* ]]; then
  xdotool key --window $active_window Alt+Left
fi

