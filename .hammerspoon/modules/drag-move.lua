-- ドラッグ移動モジュール
-- cmd+ctrl を押しながら左ドラッグで、カーソル下のウィンドウを移動する
-- タイトルバーを隠した ghostty（macos-titlebar-style = hidden）を動かすため

local types = hs.eventtap.event.types

local dragWin = nil
local offset = nil -- ウィンドウ左上からカーソルまでのずれ

local function modifierHeld(event)
  local f = event:getFlags()
  return f.cmd and f.ctrl and not f.alt and not f.shift
end

-- 前面から順に見て、カーソル位置を含む最初の通常ウィンドウを返す
-- ponytail: Dock やメニューバー上で押すと、その背後のウィンドウを掴む
local function windowAt(pos)
  for _, win in ipairs(hs.window.orderedWindows()) do
    if win:isStandard() and pos:inside(win:frame()) then
      return win
    end
  end
end

-- グローバル変数に格納してガベージコレクトを防ぐ
dragMoveTap = hs.eventtap.new(
  { types.leftMouseDown, types.leftMouseDragged, types.leftMouseUp },
  function(event)
    local t = event:getType()
    local pos = hs.geometry.point(event:location())

    if t == types.leftMouseDown then
      if not modifierHeld(event) then return false end
      dragWin = windowAt(pos)
      if not dragWin then return false end
      local tl = dragWin:topLeft()
      offset = { x = pos.x - tl.x, y = pos.y - tl.y }
      dragWin:focus()
      return true
    end

    -- ドラッグ中でなければクリックをそのまま通す
    if not dragWin then return false end

    if t == types.leftMouseDragged then
      dragWin:setTopLeft({ x = pos.x - offset.x, y = pos.y - offset.y })
    else
      dragWin = nil
      offset = nil
    end
    return true
  end
):start()
