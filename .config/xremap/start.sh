#!/bin/bash

if [ "$1" == "restart" ]; then
  sudo pkill -f "/home/thirai/.cargo/bin/xremap"
else
  sudo /home/thirai/.cargo/bin/xremap /home/thirai/.config/xremap/config.yml
fi

