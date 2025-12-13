-- クリップボード履歴モジュール
-- クリップボードの履歴を保存し、chooserで選択して貼り付け

local hyper = {"cmd", "ctrl"}

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
  clipboardChooser:rows(10)
  clipboardChooser:width(50)
  clipboardChooser:searchSubText(false)
  clipboardChooser:show()
end)
