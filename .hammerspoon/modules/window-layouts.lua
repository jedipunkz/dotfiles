-- ウィンドウレイアウト保存/復元モジュール
-- WiFi SSID別にウィンドウ配置を保存・復元
-- マルチモニター・全Spaces対応

local hyper = {"cmd", "ctrl"}

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

-- cmd+ctrl+[: 全ウィンドウの位置を現在のWiFi SSIDで保存（マルチモニター・全Spaces対応）
hs.hotkey.bind(hyper, "[", function()
  local ssid = getCurrentSSID()
  local savedWindows = {}
  local count = 0

  -- 全Spacesのウィンドウを取得（現在のSpace + 他のSpaces）
  local wf_current = hs.window.filter.new():setCurrentSpace(true)
  local wf_other = hs.window.filter.new():setCurrentSpace(false)

  local allWindows = {}
  -- 他のSpacesのウィンドウを追加
  for _, win in ipairs(wf_other:getWindows()) do
    table.insert(allWindows, win)
  end
  -- 現在のSpaceのウィンドウを追加
  for _, win in ipairs(wf_current:getWindows()) do
    table.insert(allWindows, win)
  end

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

-- cmd+ctrl+]: 現在のWiFi SSIDに対応する位置を復元（マルチモニター・全Spaces対応）
hs.hotkey.bind(hyper, "]", function()
  local ssid = getCurrentSSID()
  local layouts = loadWindowLayouts()
  local savedWindows = layouts[ssid]

  if not savedWindows or next(savedWindows) == nil then
    hs.alert.show("保存されたレイアウトがありません (" .. ssid .. ")")
    return
  end

  -- 全Spacesのウィンドウを取得（現在のSpace + 他のSpaces）
  local wf_current = hs.window.filter.new():setCurrentSpace(true)
  local wf_other = hs.window.filter.new():setCurrentSpace(false)

  local allWindows = {}
  for _, win in ipairs(wf_other:getWindows()) do
    table.insert(allWindows, win)
  end
  for _, win in ipairs(wf_current:getWindows()) do
    table.insert(allWindows, win)
  end

  -- 保存データの数をカウント
  local savedCount = 0
  for _ in pairs(savedWindows) do
    savedCount = savedCount + 1
  end

  print("=== ウィンドウ復元デバッグ ===")
  print("保存データ数: " .. savedCount)
  print("現在のウィンドウ数: " .. #allWindows)

  -- 復元済みウィンドウIDを記録
  local restoredWindowIDs = {}
  local restoredCount = 0

  -- フェーズ1: タイトル完全一致で復元
  for key, data in pairs(savedWindows) do
    print("\n保存データ: " .. key)
    print("  bundleID: " .. data.bundleID)
    print("  title: " .. data.title)

    for _, win in ipairs(allWindows) do
      local app = win:application()
      if app and app:bundleID() == data.bundleID and not restoredWindowIDs[win:id()] then
        print("  マッチ候補: " .. win:title())

        if win:title() == data.title then
          print("  ✓ 完全一致で復元")

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

          -- Spacesへの移動
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

          restoredWindowIDs[win:id()] = true
          restoredCount = restoredCount + 1
          break
        end
      end
    end
  end

  -- フェーズ2: タイトルが一致しなかったものをbundleIDだけで復元
  print("\n=== フェーズ2: bundleIDマッチング ===")
  for key, data in pairs(savedWindows) do
    for _, win in ipairs(allWindows) do
      local app = win:application()
      if app and app:bundleID() == data.bundleID and not restoredWindowIDs[win:id()] then
        print("\n保存データ: " .. key)
        print("  ✓ bundleIDマッチで復元: " .. win:title())

        -- 適切なスクリーンを見つける
        local targetScreen = findScreen(data.screenUUID, data.screenName)
        local screenFrame = targetScreen:frame()

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

        -- Spacesへの移動
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

        restoredWindowIDs[win:id()] = true
        restoredCount = restoredCount + 1
        break
      end
    end
  end

  print("\n復元完了: " .. restoredCount .. " / " .. savedCount)
  hs.alert.show("復元: " .. restoredCount .. " ウィンドウ (" .. ssid .. ")")
end)
