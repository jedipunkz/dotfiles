-- 日本語入力中のスペース挙動をカスタマイズ
-- Space       → 半角スペース（変換中は通常の変換・候補選択）
-- Shift+Space → 全角スペース（変換中は通常のシフト＋スペース動作）
--
-- AXMarkedTextRange でIME変換中を判定する。
-- 半角スペース挿入には alt+space を使う（keyStrokes(" ") は IME に傍受されるため）。

local eventtap = hs.eventtap
local keycodes = hs.keycodes

local function isJapaneseSource(source)
    if not source then return false end
    return source:find("Japanese") or source:find("Kotoeri")
end

-- AXMarkedTextRange が空でなければ変換中
local function isComposing()
    local elem = hs.uielement.focusedElement()
    if not elem then return false end
    local ok, range = pcall(function()
        return elem:attributeValue("AXMarkedTextRange")
    end)
    if not ok or range == nil then return false end
    return (range.length or 0) > 0
end

local jpSpaceWatcher = eventtap.new({ eventtap.event.types.keyDown }, function(event)
    local keyCode = event:getKeyCode()
    if keyCode ~= 49 then return false end  -- スペース以外はスルー

    local flags = event:getFlags()
    if flags.cmd or flags.ctrl then return false end

    -- alt+space は半角スペース挿入の内部経路として通過させる
    if flags.alt then return false end

    local source = keycodes.currentSourceID()
    if not isJapaneseSource(source) then return false end

    -- 変換中はIMEに任せる（候補選択など）
    if isComposing() then return false end

    if flags.shift then
        eventtap.keyStrokes("\u{3000}")      -- Shift+Space → 全角スペース
    else
        -- keyStrokes(" ") はIMEに全角変換されるため alt+space で迂回
        eventtap.keyStroke({"alt"}, "space") -- Space → 半角スペース
    end
    return true
end)

jpSpaceWatcher:start()
