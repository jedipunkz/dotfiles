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

-- ウィンドウ位置の保存/復元（WiFi SSID別）
local WINDOW_LAYOUTS_FILE = os.getenv("HOME") .. "/.hammerspoon/window_layouts.json"

-- JSONファイルからレイアウトを読み込む
local function loadWindowLayouts()
  local file = io.open(WINDOW_LAYOUTS_FILE, "r")
  if not file then
    return {}
  end

  local content = file:read("*all")
  file:close()

  if content == "" then
    return {}
  end

  local success, layouts = pcall(hs.json.decode, content)
  if success then
    return layouts
  else
    hs.alert.show("レイアウトファイルの読み込みに失敗")
    return {}
  end
end

-- JSONファイルにレイアウトを保存
local function saveWindowLayouts(layouts)
  local success, jsonString = pcall(hs.json.encode, layouts)
  if not success then
    hs.alert.show("JSONエンコードに失敗")
    return false
  end

  local file = io.open(WINDOW_LAYOUTS_FILE, "w")
  if not file then
    hs.alert.show("ファイルの書き込みに失敗")
    return false
  end

  file:write(jsonString)
  file:close()
  return true
end

-- 現在のWiFi SSIDを取得
local function getCurrentSSID()
  local ssid = hs.wifi.currentNetwork()
  if not ssid then
    return "no_wifi"
  end
  return ssid
end

-- cmd+ctrl+\: 全ウィンドウの位置を現在のWiFi SSIDで保存（マルチモニター・Spaces対応）
hs.hotkey.bind(hyper, "\\", function()
  local ssid = getCurrentSSID()
  local allWindows = hs.window.allWindows()
  local savedWindows = {}
  local count = 0

  for _, win in ipairs(allWindows) do
    local app = win:application()
    if app and win:isStandard() then
      local frame = win:frame()
      local screen = win:screen()
      local screenFrame = screen:frame()
      local key = app:bundleID() .. ":" .. win:title()

      -- スクリーン内の相対位置を計算（0.0 ~ 1.0）
      local relativeX = (frame.x - screenFrame.x) / screenFrame.w
      local relativeY = (frame.y - screenFrame.y) / screenFrame.h
      local relativeW = frame.w / screenFrame.w
      local relativeH = frame.h / screenFrame.h

      -- Spaces情報を取得
      local spaces = hs.spaces.windowSpaces(win:id())
      local spaceID = spaces and spaces[1] or nil

      savedWindows[key] = {
        bundleID = app:bundleID(),
        appName = app:name(),
        title = win:title(),
        -- 絶対座標（後方互換性のため残す）
        x = frame.x,
        y = frame.y,
        w = frame.w,
        h = frame.h,
        -- スクリーン情報
        screenUUID = screen:getUUID(),
        screenName = screen:name(),
        screenW = screenFrame.w,
        screenH = screenFrame.h,
        -- スクリーン内相対位置
        relativeX = relativeX,
        relativeY = relativeY,
        relativeW = relativeW,
        relativeH = relativeH,
        -- Spaces情報
        spaceID = spaceID
      }
      count = count + 1
    end
  end

  -- 既存のレイアウトを読み込んで更新
  local layouts = loadWindowLayouts()
  layouts[ssid] = savedWindows

  if saveWindowLayouts(layouts) then
    hs.alert.show("保存: " .. count .. " ウィンドウ (" .. ssid .. ")")
  end
end)

-- 保存されたスクリーン情報から適切なスクリーンを見つける
local function findScreen(savedScreenUUID, savedScreenName)
  -- まずUUIDで探す
  if savedScreenUUID then
    for _, screen in ipairs(hs.screen.allScreens()) do
      if screen:getUUID() == savedScreenUUID then
        return screen
      end
    end
  end

  -- UUIDで見つからなければ名前で探す
  if savedScreenName then
    for _, screen in ipairs(hs.screen.allScreens()) do
      if screen:name() == savedScreenName then
        return screen
      end
    end
  end

  -- それでも見つからなければメインスクリーンを返す
  return hs.screen.mainScreen()
end

-- cmd+ctrl+`: 現在のWiFi SSIDに対応する位置を復元（マルチモニター・Spaces対応）
hs.hotkey.bind(hyper, "`", function()
  local ssid = getCurrentSSID()
  local layouts = loadWindowLayouts()
  local savedWindows = layouts[ssid]

  if not savedWindows or next(savedWindows) == nil then
    hs.alert.show("保存されたレイアウトがありません (" .. ssid .. ")")
    return
  end

  local restoredCount = 0
  for _, data in pairs(savedWindows) do
    local app = hs.application.get(data.bundleID)
    if app then
      local wins = app:allWindows()
      for _, win in ipairs(wins) do
        if win:title() == data.title then
          -- 適切なスクリーンを見つける
          local targetScreen = findScreen(data.screenUUID, data.screenName)
          local screenFrame = targetScreen:frame()

          -- 相対位置が保存されている場合はそれを使用、なければ絶対座標を使用
          local newFrame
          if data.relativeX and data.relativeY and data.relativeW and data.relativeH then
            -- 相対位置からフレームを計算
            newFrame = {
              x = screenFrame.x + (screenFrame.w * data.relativeX),
              y = screenFrame.y + (screenFrame.h * data.relativeY),
              w = screenFrame.w * data.relativeW,
              h = screenFrame.h * data.relativeH
            }
          else
            -- 後方互換性：絶対座標を使用
            newFrame = {x = data.x, y = data.y, w = data.w, h = data.h}
          end

          win:setFrame(newFrame)

          -- Spacesへの移動（保存されている場合）
          if data.spaceID then
            -- 現在のSpacesを取得
            local allSpaces = hs.spaces.allSpaces()
            local spaceExists = false

            -- spaceIDが存在するか確認
            for _, screenSpaces in pairs(allSpaces) do
              for _, spaceID in ipairs(screenSpaces) do
                if spaceID == data.spaceID then
                  spaceExists = true
                  break
                end
              end
              if spaceExists then break end
            end

            -- Spaceが存在する場合のみ移動
            if spaceExists then
              hs.spaces.moveWindowToSpace(win:id(), data.spaceID)
            end
          end

          restoredCount = restoredCount + 1
          break
        end
      end
    end
  end

  hs.alert.show("復元: " .. restoredCount .. " ウィンドウ (" .. ssid .. ")")
end)

-- cmd+ctrl+enter: スリープ
hs.hotkey.bind(hyper, "return", function()
  hs.caffeinate.systemSleep()
end)

-- クリップボード履歴
local clipboardHistory = {}
local maxClipboardItems = 80
local lastClipboard = ""

-- クリップボード履歴を更新
local function updateClipboardHistory()
  local content = hs.pasteboard.getContents()

  if not content or content == "" then
    return
  end

  if content == lastClipboard then
    return
  end

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

-- クリップボード監視ウォッチャー（メインの監視方法）
local clipboardWatcher = hs.pasteboard.watcher.new(updateClipboardHistory)
clipboardWatcher:start()

-- バックアップ用タイマー（ウォッチャーが停止した場合の保険）
-- 2秒ごとにチェック
local clipboardTimer = hs.timer.new(2, function()
  updateClipboardHistory()
end)
clipboardTimer:start()

-- 初回実行
updateClipboardHistory()

-- クリップボード履歴を表示
local clipboardChooser = nil

-- cmd+ctrl+v: クリップボード履歴を表示
hs.hotkey.bind(hyper, "v", function()
  local choices = {}

  -- 毎回最新の履歴から選択肢を作成
  for i, item in ipairs(clipboardHistory) do
    -- 改行を含む場合は省略表示
    local display = item:gsub("\n", " "):sub(1, 80)
    if #item > 80 then
      display = display .. "..."
    end

    table.insert(choices, {
      text = display,
      subText = "#" .. i .. " (" .. #item .. " 文字)",
      originalText = item
    })
  end

  -- 毎回新しいchooserを作成
  clipboardChooser = hs.chooser.new(function(choice)
    if choice then
      -- ウォッチャーとタイマーを一時停止
      clipboardWatcher:stop()
      clipboardTimer:stop()

      -- クリップボードにセットしてペースト
      hs.pasteboard.setContents(choice.originalText)
      lastClipboard = choice.originalText
      hs.eventtap.keyStroke({"cmd"}, "v")

      -- 0.5秒後に監視を再開
      hs.timer.doAfter(0.5, function()
        clipboardWatcher:start()
        clipboardTimer:start()
      end)
    end
  end)

  -- 選択肢を設定
  clipboardChooser:choices(choices)
  clipboardChooser:rows(15)
  clipboardChooser:width(70)
  clipboardChooser:searchSubText(false)
  clipboardChooser:show()
end)

-- ウィンドウリサイズモード
local resizeAmount = 50  -- ピクセル単位
local edgeThreshold = 10  -- 画面端の判定閾値（ピクセル）
local resizeModal = hs.hotkey.modal.new()

-- リサイズモード中の表示
function resizeModal:entered()
  hs.alert.show("リサイズモード (ESC で終了)", 999999)
end

function resizeModal:exited()
  hs.alert.closeAll()
end

-- ESC でリサイズモードを終了
resizeModal:bind({}, 'escape', function()
  resizeModal:exit()
end)

-- h: 左端を左に移動（拡大）
resizeModal:bind({}, 'h', function()
  local win = hs.window.focusedWindow()
  if win then
    local frame = win:frame()
    frame.x = frame.x - resizeAmount
    frame.w = frame.w + resizeAmount
    win:setFrame(frame)
  end
end)

-- Shift+h: 右端を左に移動（縮小）
resizeModal:bind({'shift'}, 'h', function()
  local win = hs.window.focusedWindow()
  if win then
    local frame = win:frame()
    frame.w = math.max(100, frame.w - resizeAmount)
    win:setFrame(frame)
  end
end)

-- l: 右端を右に移動（拡大）
resizeModal:bind({}, 'l', function()
  local win = hs.window.focusedWindow()
  if win then
    local frame = win:frame()
    frame.w = frame.w + resizeAmount
    win:setFrame(frame)
  end
end)

-- Shift+l: 左端を右に移動（縮小）
resizeModal:bind({'shift'}, 'l', function()
  local win = hs.window.focusedWindow()
  if win then
    local frame = win:frame()
    frame.x = frame.x + resizeAmount
    frame.w = math.max(100, frame.w - resizeAmount)
    win:setFrame(frame)
  end
end)

-- k: 上端を上に移動（拡大）
resizeModal:bind({}, 'k', function()
  local win = hs.window.focusedWindow()
  if win then
    local frame = win:frame()
    frame.y = frame.y - resizeAmount
    frame.h = frame.h + resizeAmount
    win:setFrame(frame)
  end
end)

-- Shift+k: 下端を上に移動（縮小）
resizeModal:bind({'shift'}, 'k', function()
  local win = hs.window.focusedWindow()
  if win then
    local frame = win:frame()
    frame.h = math.max(100, frame.h - resizeAmount)
    win:setFrame(frame)
  end
end)

-- j: 下端を下に移動（拡大）
resizeModal:bind({}, 'j', function()
  local win = hs.window.focusedWindow()
  if win then
    local frame = win:frame()
    frame.h = frame.h + resizeAmount
    win:setFrame(frame)
  end
end)

-- Shift+j: 上端を下に移動（縮小）
resizeModal:bind({'shift'}, 'j', function()
  local win = hs.window.focusedWindow()
  if win then
    local frame = win:frame()
    frame.y = frame.y + resizeAmount
    frame.h = math.max(100, frame.h - resizeAmount)
    win:setFrame(frame)
  end
end)

-- cmd+ctrl+r: リサイズモードに入る
hs.hotkey.bind(hyper, "r", function()
  resizeModal:enter()
end)

-- WiFi切り替え時の自動レイアウト復元（オプション、マルチモニター・Spaces対応）
-- 有効にするには下記のコメントを外してください
--[[
local lastSSID = getCurrentSSID()
local wifiWatcher = hs.wifi.watcher.new(function()
  local currentSSID = getCurrentSSID()
  if currentSSID ~= lastSSID then
    lastSSID = currentSSID
    -- 2秒待ってから復元（WiFi接続が安定するまで）
    hs.timer.doAfter(2, function()
      local layouts = loadWindowLayouts()
      local savedWindows = layouts[currentSSID]
      if savedWindows and next(savedWindows) ~= nil then
        local restoredCount = 0
        for _, data in pairs(savedWindows) do
          local app = hs.application.get(data.bundleID)
          if app then
            local wins = app:allWindows()
            for _, win in ipairs(wins) do
              if win:title() == data.title then
                -- 適切なスクリーンを見つける
                local targetScreen = findScreen(data.screenUUID, data.screenName)
                local screenFrame = targetScreen:frame()

                -- 相対位置が保存されている場合はそれを使用、なければ絶対座標を使用
                local newFrame
                if data.relativeX and data.relativeY and data.relativeW and data.relativeH then
                  newFrame = {
                    x = screenFrame.x + (screenFrame.w * data.relativeX),
                    y = screenFrame.y + (screenFrame.h * data.relativeY),
                    w = screenFrame.w * data.relativeW,
                    h = screenFrame.h * data.relativeH
                  }
                else
                  newFrame = {x = data.x, y = data.y, w = data.w, h = data.h}
                end

                win:setFrame(newFrame)

                -- Spacesへの移動（保存されている場合）
                if data.spaceID then
                  local allSpaces = hs.spaces.allSpaces()
                  local spaceExists = false
                  for _, screenSpaces in pairs(allSpaces) do
                    for _, spaceID in ipairs(screenSpaces) do
                      if spaceID == data.spaceID then
                        spaceExists = true
                        break
                      end
                    end
                    if spaceExists then break end
                  end
                  if spaceExists then
                    hs.spaces.moveWindowToSpace(win:id(), data.spaceID)
                  end
                end

                restoredCount = restoredCount + 1
                break
              end
            end
          end
        end
        if restoredCount > 0 then
          hs.alert.show("自動復元: " .. restoredCount .. " ウィンドウ (" .. currentSSID .. ")")
        end
      end
    end)
  end
end)
wifiWatcher:start()
--]]

-- 自動リロード
function reloadConfig(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
      break
    end
  end
  if doReload then
    hs.reload()
  end
end

-- グローバル変数に格納してガベージコレクトを防ぐ
configWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

-- 設定リロード時の通知
hs.alert.show("Hammerspoon 設定を読み込みました 🔄")
