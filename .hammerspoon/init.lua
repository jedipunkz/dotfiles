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

-- ウィンドウ位置の保存/復元
local SAVED_WINDOWS_KEY = "savedWindowPositions"

-- cmd+ctrl+\: 全ウィンドウの位置を一括保存
hs.hotkey.bind(hyper, "\\", function()
  local allWindows = hs.window.allWindows()
  local savedWindows = {}
  local count = 0

  for _, win in ipairs(allWindows) do
    local app = win:application()
    if app and win:isStandard() then
      local frame = win:frame()
      local key = app:bundleID() .. ":" .. win:title()
      savedWindows[key] = {
        bundleID = app:bundleID(),
        appName = app:name(),
        title = win:title(),
        x = frame.x,
        y = frame.y,
        w = frame.w,
        h = frame.h
      }
      count = count + 1
    end
  end

  hs.settings.set(SAVED_WINDOWS_KEY, savedWindows)
  hs.alert.show("保存: " .. count .. " ウィンドウ")
end)

-- cmd+ctrl+`: 保存した位置を一括復元
hs.hotkey.bind(hyper, "`", function()
  local savedWindows = hs.settings.get(SAVED_WINDOWS_KEY)
  if not savedWindows or next(savedWindows) == nil then
    hs.alert.show("保存されたウィンドウ位置がありません")
    return
  end

  local restoredCount = 0
  for _, data in pairs(savedWindows) do
    local app = hs.application.get(data.bundleID)
    if app then
      local wins = app:allWindows()
      for _, win in ipairs(wins) do
        if win:title() == data.title then
          win:setFrame({x = data.x, y = data.y, w = data.w, h = data.h})
          restoredCount = restoredCount + 1
          break
        end
      end
    end
  end

  hs.alert.show("復元: " .. restoredCount .. " ウィンドウ")
end)

-- 設定リロード時の通知
hs.alert.show("Hammerspoon 設定を読み込みました")
