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

-- フルスクリーントグル用の元サイズ保存
local originalFrames = {}

-- cmd+ctrl+f: フルスクリーントグル（通常ウィンドウのまま最大化）
hs.hotkey.bind(hyper, "f", function()
  local win = hs.window.focusedWindow()
  if not win then return end

  local winID = win:id()
  local screen = win:screen():fullFrame()

  if originalFrames[winID] then
    -- 元のサイズに戻す
    win:setFrame(originalFrames[winID])
    originalFrames[winID] = nil
  else
    -- 現在のサイズを保存してフルスクリーンに
    originalFrames[winID] = win:frame()
    win:setFrame(screen)
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

-- cmd+ctrl+enter: スリープ
hs.hotkey.bind(hyper, "return", function()
  hs.caffeinate.systemSleep()
end)

-- クリップボード履歴
local clipboardHistory = {}
local maxClipboardItems = 20
local lastClipboard = ""

-- クリップボード履歴を更新
local function updateClipboardHistory()
  local content = hs.pasteboard.getContents()
  if content and content ~= "" and content ~= lastClipboard then
    lastClipboard = content

    -- 既に履歴にある場合は削除（重複を避ける）
    for i, item in ipairs(clipboardHistory) do
      if item == content then
        table.remove(clipboardHistory, i)
        break
      end
    end

    -- 先頭に追加
    table.insert(clipboardHistory, 1, content)

    -- 最大数を超えたら古いものを削除
    if #clipboardHistory > maxClipboardItems then
      table.remove(clipboardHistory)
    end
  end
end

-- クリップボード監視ウォッチャー
local clipboardWatcher = hs.pasteboard.watcher.new(updateClipboardHistory)
clipboardWatcher:start()

-- 初回実行
updateClipboardHistory()

-- クリップボード履歴を表示
local clipboardChooser = hs.chooser.new(function(choice)
  if choice then
    hs.pasteboard.setContents(choice.text)
    hs.eventtap.keyStroke({"cmd"}, "v")
  end
end)

-- cmd+ctrl+v: クリップボード履歴を表示
hs.hotkey.bind(hyper, "v", function()
  local choices = {}
  for i, item in ipairs(clipboardHistory) do
    -- 改行を含む場合は省略表示
    local display = item:gsub("\n", " "):sub(1, 100)
    if #item > 100 then
      display = display .. "..."
    end

    table.insert(choices, {
      text = item,
      subText = "(" .. #item .. " 文字)",
      image = nil,
      index = i,
      display = display
    })
  end

  clipboardChooser:choices(choices)
  clipboardChooser:show()
end)

-- 設定リロード時の通知
hs.alert.show("Hammerspoon 設定を読み込みました")
