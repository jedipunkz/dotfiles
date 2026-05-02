-- 日本語入力中のスペースを半角スペースにする
-- macOS 標準日本語変換（Kotoeri）使用時、全角スペースの代わりに半角スペースを入力する

local eventtap = hs.eventtap
local keycodes = hs.keycodes

local jpSpaceWatcher = eventtap.new({ eventtap.event.types.keyDown }, function(event)
    if event:getKeyCode() ~= 49 then
        return false
    end

    -- 修飾キーが押されている場合はスキップ
    local flags = event:getFlags()
    if flags.shift or flags.ctrl or flags.alt or flags.cmd then
        return false
    end

    local source = keycodes.currentSourceID()
    if source and source:find("com.apple.inputmethod.Kotoeri") and source:find("Japanese") then
        eventtap.keyStrokes(" ")
        return true
    end

    return false
end)

jpSpaceWatcher:start()
