-- オーディオデバイス選択モジュール
-- オーディオ出力・入力デバイスをchooserで選択

local hyper = {"cmd", "ctrl"}

-- オーディオ出力デバイス選択
local audioOutputChooser = nil
local audioOutputDevicesMap = {}  -- UIDとデバイスのマッピング

-- cmd+ctrl+o: オーディオ出力デバイスを選択
hs.hotkey.bind(hyper, "o", function()
  local choices = {}
  audioOutputDevicesMap = {}  -- マップをリセット
  local currentDevice = hs.audiodevice.defaultOutputDevice()
  local currentUID = currentDevice and currentDevice:uid() or nil

  -- 全ての出力デバイスを取得
  local devices = hs.audiodevice.allOutputDevices()

  for i, device in ipairs(devices) do
    local name = device:name()
    local uid = device:uid()
    local isCurrent = (uid == currentUID)

    -- デバイスをマップに保存
    audioOutputDevicesMap[uid] = device

    table.insert(choices, {
      text = (isCurrent and "✓ " or "  ") .. name,
      subText = uid,
      uid = uid  -- 文字列として保存
    })
  end

  -- 新しいchooserを作成
  audioOutputChooser = hs.chooser.new(function(choice)
    if choice and choice.uid then
      local device = audioOutputDevicesMap[choice.uid]
      if device then
        device:setDefaultOutputDevice()
        hs.alert.show("出力デバイス: " .. device:name())
      end
    end
  end)

  -- 選択肢を設定
  audioOutputChooser:choices(choices)
  audioOutputChooser:rows(7)
  audioOutputChooser:width(40)
  audioOutputChooser:searchSubText(false)
  audioOutputChooser:show()
end)

-- オーディオ入力デバイス選択
local audioInputChooser = nil
local audioInputDevicesMap = {}  -- UIDとデバイスのマッピング

-- cmd+ctrl+i: オーディオ入力デバイスを選択
hs.hotkey.bind(hyper, "i", function()
  local choices = {}
  audioInputDevicesMap = {}  -- マップをリセット
  local currentDevice = hs.audiodevice.defaultInputDevice()
  local currentUID = currentDevice and currentDevice:uid() or nil

  -- 全ての入力デバイスを取得
  local devices = hs.audiodevice.allInputDevices()

  for i, device in ipairs(devices) do
    local name = device:name()
    local uid = device:uid()
    local isCurrent = (uid == currentUID)

    -- デバイスをマップに保存
    audioInputDevicesMap[uid] = device

    table.insert(choices, {
      text = (isCurrent and "✓ " or "  ") .. name,
      subText = uid,
      uid = uid  -- 文字列として保存
    })
  end

  -- 新しいchooserを作成
  audioInputChooser = hs.chooser.new(function(choice)
    if choice and choice.uid then
      local device = audioInputDevicesMap[choice.uid]
      if device then
        device:setDefaultInputDevice()
        hs.alert.show("入力デバイス: " .. device:name())
      end
    end
  end)

  -- 選択肢を設定
  audioInputChooser:choices(choices)
  audioInputChooser:rows(7)
  audioInputChooser:width(40)
  audioInputChooser:searchSubText(false)
  audioInputChooser:show()
end)
