-- 日本語入力中のスペース挙動をカスタマイズ
-- Space       → 半角スペース（変換中は通常のスペース＝候補選択をそのまま使用）
-- Shift+Space → 全角スペース（変換中は通常のシフト＋スペース動作）

local eventtap = hs.eventtap
local keycodes = hs.keycodes

-- AXMarkedRange でIMEの変換中状態を検出する
-- 変換中（マークドテキストあり）なら true を返す
local function isIMEComposing()
    local ok, result = pcall(function()
        local focused = hs.axuielement.systemWideElement():attributeValue("AXFocusedUIElement")
        if not focused then return false end
        local markedRange = focused:attributeValue("AXMarkedRange")
        return markedRange ~= nil and (markedRange.length or 0) > 0
    end)
    return ok and result
end

local jpSpaceWatcher = eventtap.new({ eventtap.event.types.keyDown }, function(event)
    if event:getKeyCode() ~= 49 then
        return false
    end

    local flags = event:getFlags()
    if flags.ctrl or flags.alt or flags.cmd then
        return false
    end

    local source = keycodes.currentSourceID()
    if not (source and source:find("com.apple.inputmethod.Kotoeri") and source:find("Japanese")) then
        return false
    end

    -- 変換中はイベントをそのまま通す（候補選択などIME本来の動作を維持）
    if isIMEComposing() then
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
