-- Hammerspoon ウィンドウ管理設定

local hyper = {"cmd", "ctrl"}

-- cmd+ctrl+h: 左半分
hs.hotkey.bind(hyper, "h", function()
  local win = hs.window.focusedWindow()
  if win then
    local screen = win:screen():frame()
    win:setFrame({x = screen.x, y = screen.y, w = screen.w / 2, h = screen.h})
  end
end)

-- cmd+ctrl+l: 右半分
hs.hotkey.bind(hyper, "l", function()
  local win = hs.window.focusedWindow()
  if win then
    local screen = win:screen():frame()
    win:setFrame({x = screen.x + screen.w / 2, y = screen.y, w = screen.w / 2, h = screen.h})
  end
end)

-- cmd+ctrl+j: 下半分
hs.hotkey.bind(hyper, "j", function()
  local win = hs.window.focusedWindow()
  if win then
    local screen = win:screen():frame()
    win:setFrame({x = screen.x, y = screen.y + screen.h / 2, w = screen.w, h = screen.h / 2})
  end
end)

-- cmd+ctrl+k: 上半分
hs.hotkey.bind(hyper, "k", function()
  local win = hs.window.focusedWindow()
  if win then
    local screen = win:screen():frame()
    win:setFrame({x = screen.x, y = screen.y, w = screen.w, h = screen.h / 2})
  end
end)

-- cmd+ctrl+n: 左 2/5
hs.hotkey.bind(hyper, "n", function()
  local win = hs.window.focusedWindow()
  if win then
    local screen = win:screen():frame()
    win:setFrame({x = screen.x, y = screen.y, w = screen.w * 2 / 5, h = screen.h})
  end
end)

-- cmd+ctrl+m: 左 3/5
hs.hotkey.bind(hyper, "m", function()
  local win = hs.window.focusedWindow()
  if win then
    local screen = win:screen():frame()
    win:setFrame({x = screen.x, y = screen.y, w = screen.w * 3 / 5, h = screen.h})
  end
end)

-- cmd+ctrl+,: 右 3/5
hs.hotkey.bind(hyper, ",", function()
  local win = hs.window.focusedWindow()
  if win then
    local screen = win:screen():frame()
    win:setFrame({x = screen.x + screen.w * 2 / 5, y = screen.y, w = screen.w * 3 / 5, h = screen.h})
  end
end)

-- cmd+ctrl+.: 右 2/5
hs.hotkey.bind(hyper, ".", function()
  local win = hs.window.focusedWindow()
  if win then
    local screen = win:screen():frame()
    win:setFrame({x = screen.x + screen.w * 3 / 5, y = screen.y, w = screen.w * 2 / 5, h = screen.h})
  end
end)

-- cmd+ctrl+t: Alacritty を起動/フォーカス
hs.hotkey.bind(hyper, "t", function()
  local app = hs.application.find("Alacritty")
  if app then
    app:activate()
  else
    hs.application.launchOrFocus("Alacritty")
  end
end)

-- cmd+ctrl+g: Google Chrome を起動/フォーカス
hs.hotkey.bind(hyper, "g", function()
  local app = hs.application.find("Google Chrome")
  if app then
    app:activate()
  else
    hs.application.launchOrFocus("Google Chrome")
  end
end)

-- cmd+ctrl+s: Slack を起動/フォーカス
hs.hotkey.bind(hyper, "s", function()
  local app = hs.application.find("Slack")
  if app then
    app:activate()
  else
    hs.application.launchOrFocus("Slack")
  end
end)

-- 設定リロード時の通知
hs.alert.show("Hammerspoon 設定を読み込みました")
