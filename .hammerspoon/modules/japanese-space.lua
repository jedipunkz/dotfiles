-- 日本語入力中のスペース挙動をカスタマイズ
-- Space       → 半角スペース（変換中は通常の変換・候補選択）
-- Shift+Space → 全角スペース（変換中は通常のシフト＋スペース動作）
--
-- AXMarkedRange はアプリによって動作しないため、キーイベントで変換状態を自前管理する:
--   文字キー入力     → composing = true
--   Enter / Escape  → composing = false
--   ナビゲーション系 → composing は変化させない

local eventtap = hs.eventtap
local keycodes = hs.keycodes

local composing = false

-- 入力ソース切り替え時に変換状態をリセット
keycodes.inputSourceChanged(function()
    composing = false
end)

local function isJapaneseSource(source)
    return source
        and source:find("com.apple.inputmethod.Kotoeri")
        and source:find("Japanese")
end

-- composing フラグを変化させないキー（ナビゲーション・削除系）
local passthroughKeys = {
    [48]  = true,  -- Tab
    [51]  = true,  -- Delete (Backspace)
    [117] = true,  -- Forward Delete
    [123] = true,  -- Left
    [124] = true,  -- Right
    [125] = true,  -- Down
    [126] = true,  -- Up
    [115] = true,  -- Home
    [119] = true,  -- End
    [116] = true,  -- Page Up
    [121] = true,  -- Page Down
}

local jpSpaceWatcher = eventtap.new({ eventtap.event.types.keyDown }, function(event)
    local keyCode = event:getKeyCode()
    local flags = event:getFlags()
    local source = keycodes.currentSourceID()

    if not isJapaneseSource(source) then
        composing = false
        return false
    end

    if flags.cmd or flags.ctrl then
        return false
    end

    -- Enter / numpad Enter → 変換確定
    if keyCode == 36 or keyCode == 76 then
        composing = false
        return false
    end

    -- Escape → 変換キャンセル
    if keyCode == 53 then
        composing = false
        return false
    end

    -- スペース以外のキー: 文字キーなら変換開始とみなす
    if keyCode ~= 49 then
        if not passthroughKeys[keyCode] then
            composing = true
        end
        return false
    end

    -- スペースキーの処理
    if flags.alt then
        return false
    end

    if composing then
        -- 変換中はIMEに任せる（候補選択など）
        return false
    end

    if flags.shift then
        eventtap.keyStrokes("\u{3000}")  -- 全角スペース
    else
        eventtap.keyStrokes(" ")         -- 半角スペース
    end
    return true
end)

jpSpaceWatcher:start()
