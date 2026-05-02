-- Hammerspoon モジュール化設定
-- 各機能はmodulesディレクトリに分割されています

-- 位置情報サービスの権限をリクエスト（WiFi SSID取得に必要 - macOS 14+）
hs.location.get()

-- モジュール読み込み
require("modules.window-management")   -- ウィンドウ位置調整、フルスクリーン、スリープ
require("modules.app-launcher")        -- アプリケーション起動
require("modules.window-layouts")      -- ウィンドウレイアウト保存/復元
require("modules.clipboard")           -- クリップボード履歴
require("modules.audio-devices")       -- オーディオデバイス選択
require("modules.resize-mode")         -- リサイズモード
require("modules.japanese-space")     -- 日本語入力中のスペースを半角スペースに変換

-- 自動リロード
function reloadConfig(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
      break
    end
  end
  if doReload then
    hs.reload()
  end
end

-- グローバル変数に格納してガベージコレクトを防ぐ
configWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

-- 設定リロード時の通知
hs.alert.show("Hammerspoon 設定を読み込みました 🔄")
