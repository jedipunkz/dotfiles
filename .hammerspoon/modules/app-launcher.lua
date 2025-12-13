-- アプリケーション起動モジュール
-- よく使うアプリケーションをホットキーで起動/フォーカス

local hyper = {"cmd", "ctrl"}

-- cmd+ctrl+t: Alacritty を起動/フォーカス
hs.hotkey.bind(hyper, "t", function()
  hs.application.launchOrFocus("Alacritty")
end)

-- cmd+ctrl+g: Google Chrome を起動/フォーカス
hs.hotkey.bind(hyper, "g", function()
  hs.application.launchOrFocus("Google Chrome")
end)

-- cmd+ctrl+s: Slack を起動/フォーカス
hs.hotkey.bind(hyper, "s", function()
  hs.application.launchOrFocus("Slack")
end)
