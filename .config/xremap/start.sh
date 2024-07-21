#!/bin/bash

if [ "$1" == "stop" ]; then
  sudo pkill -f "/home/thirai/.cargo/bin/xremap"
else
  # download from https://github.com/k0kubun/xremap/releases
  sudo /home/thirai/.local/bin/xremap /home/thirai/.config/xremap/config.yml
fi

