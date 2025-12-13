-- リサイズモードモジュール
-- モーダルモードでウィンドウを細かくリサイズ

local hyper = {"cmd", "ctrl"}

-- ウィンドウリサイズモード
local resizeAmount = 50  -- ピクセル単位
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
