-- 日本語入力中のスペース挙動をカスタマイズ
-- Space       → 半角スペース
-- Shift+Space → 全角スペース（　）

local eventtap = hs.eventtap
local keycodes = hs.keycodes

local jpSpaceWatcher = eventtap.new({ eventtap.event.types.keyDown }, function(event)
    if event:getKeyCode() ~= 49 then
        return false
    end

    local flags = event:getFlags()
    if flags.ctrl or flags.alt or flags.cmd then
        return false
    end

    local source = keycodes.currentSourceID()
    if source and source:find("com.apple.inputmethod.Kotoeri") and source:find("Japanese") then
        if flags.shift then
            eventtap.keyStrokes("\u{3000}")  -- 全角スペース
        else
            eventtap.keyStrokes(" ")         -- 半角スペース
        end
        return true
    end

    return false
end)

jpSpaceWatcher:start()
