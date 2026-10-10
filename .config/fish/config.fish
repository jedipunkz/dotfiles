set -g fish_greeting ""

# ============================================================
# PATH
# ============================================================
# ベース。mise / ~/.bin / pnpm などの優先パスは各セクションで先頭に追加する
set -gx PATH \
    /opt/homebrew/bin \
    /opt/homebrew/opt/libpq/bin \
    /opt/homebrew/opt/mysql-client/bin \
    $HOME/.cargo/bin \
    /usr/local/bin \
    /usr/local/sbin \
    /bin \
    /usr/bin \
    /sbin \
    /usr/sbin \
    /usr/local/sessionmanagerplugin/bin \
    $HOME/google-cloud-sdk/bin \
    $HOME/.local/bin \
    $HOME/.lmstudio/bin

# ============================================================
# OS 別
# ============================================================
switch (uname -s)
    case Darwin
        set -gx EDITOR nvim
        alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
        /opt/homebrew/bin/mise activate fish | source
    case Linux
        # WSL 上の VS Code
        alias code="/mnt/c/Users/tomok/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code"

        set -gx GTK_IM_MODULE fcitx
        set -gx QT_IM_MODULE fcitx
        set -gx XMODIFIERS "@im=fcitx"

        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

        # win32yank: Windows クリップボード連携
        if test -f "$HOME/.local/bin/win32yank.exe"
            set -gx CLIPBOARD "$HOME/.local/bin/win32yank.exe"
        end

        /home/linuxbrew/.linuxbrew/bin/mise activate fish | source
end

# ============================================================
# 優先パス（mise activate の後に置き、shims と ~/.bin を brew より優先する）
# ============================================================
set -gx PATH $HOME/.local/share/mise/shims $PATH
set -gx PATH $HOME/.bin $PATH

# ============================================================
# 環境変数
# ============================================================
set -gx AWS_PROFILE default
set -gx EZA_CONFIG_DIR "$HOME/.config/eza"
set -gx STARSHIP_CONFIG ~/.config/starship/config.toml

# ============================================================
# alias
# ============================================================
alias vim="nvim"
if type -q bat
    alias cat="bat"
else if type -q batcat
    alias cat="batcat"
end

alias ls="eza"
alias la="ls -a"
alias l="ls -alF"
alias lt='eza -T -L 3 -a -I "node_modules|.git|.cache" --icons'

alias grep="grep --color"
alias ssh="ssh -o UserKnownHostsFile=/dev/null -o 'StrictHostKeyChecking no'"
alias zz="bunx ccgwz"

alias gs="git switch"
alias gsc="git switch -c"
alias pm="echo 'pull main' && git pull origin main"
alias pms="echo 'pull master' && git pull origin master"

# ============================================================
# ツール初期化
# ============================================================
zoxide init fish | source

# sponge: 失敗・マッチしたコマンドを次のプロンプト前に履歴から消す
set -g sponge_delay 0

# gm: Ctrl-G でリポジトリ検索。conf.d の fish-ghq の bind を後から上書きする
if type -q gm
    gm shell fish | source
end

function starship_transient_prompt_func
    starship prompt --profile transient
end
starship init fish | source
enable_transience

# ============================================================
# テーマ: TokyoNight Night
# ============================================================
set -l background 1a1b26
set -l foreground a0d8f0
set -l selection 283457
set -l comment 565f89
set -l red f7768e
set -l orange ff9e64
set -l yellow e0af68
set -l green 9ece6a
set -l purple bb9af7
set -l cyan 7dcfff
set -l blue 7aa2f7

# conf.d/fish_frozen_theme.fish の global 値を上書きするため -g で設定する
set -g fish_color_normal $foreground
set -g fish_color_command $blue
set -g fish_color_keyword $purple
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_option $purple
set -g fish_color_error $red
set -g fish_color_param $cyan
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $purple
set -g fish_color_autosuggestion $comment

set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $blue
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
set -g fish_pager_color_selected_background --background=$selection

# fish は list を空白区切りで export する
set -gx FZF_DEFAULT_OPTS \
    --info=inline-right \
    --ansi \
    --border=none \
    --color=bg+:#$selection \
    --color=bg:#$background \
    --color=border:#$cyan \
    --color=fg:#$foreground \
    --color=gutter:#$background \
    --color=header:#$orange \
    --color=hl+:#$cyan \
    --color=hl:#$blue \
    --color=info:#$comment \
    --color=marker:#$purple \
    --color=pointer:#$purple \
    --color=prompt:#$blue \
    --color=query:#$foreground:regular \
    --color=scrollbar:#$cyan \
    --color=separator:#$orange \
    --color=spinner:#$purple

# ============================================================
# インストーラが追記するブロック
# ============================================================
# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not contains -- $PNPM_HOME $PATH
    set -gx PATH $PNPM_HOME $PATH
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.fish.inc" ]; . "$HOME/google-cloud-sdk/path.fish.inc"; end

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/thirai/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
