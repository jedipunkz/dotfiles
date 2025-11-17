if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_greeting ""

set -x PATH /opt/homebrew/bin $HOME/.cargo/bin $HOME/.bin /usr/local/bin /usr/local/sbin /bin /usr/bin /sbin /usr/sbin /usr/local/sessionmanagerplugin/bin $HOME/google-cloud-sdk/bin $HOME/.local/bin $HOME/.lmstudio/bin

if test (uname -s) = "Darwin"
    alias cat="bat"
    alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
    set -x EDITOR nvim
    alias vim="nvim"
else
    alias cat="batcat"
    alias vim="nvim"
end

if test (uname -s) = "Linux"
    # xset r rate 190 35
    set -gx GTK_IM_MODULE fcitx
    set -gx QT_IM_MODULE fcitx
    set -gx XMODIFIERS "@im=fcitx"
    # linux homebrew
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end

alias ls="eza"
alias lt='eza -T -L 3 -a -I "node_modules|.git|.cache" --icons'
alias la="ls -a"
alias l="ls -alF"
alias ssh="ssh -o UserKnownHostsFile=/dev/null -o 'StrictHostKeyChecking no'"
alias grep="grep --color"

# mise
if test (uname -s) = "Linux"
    /home/linuxbrew/.linuxbrew/bin/mise activate fish | source
else if test (uname -s) = "Darwin"
    mise activate fish | source
end

if test ! -d "$HOME/ghq"
    mkdir $HOME/ghq
end

# TokyoNight Night color palette
set -l foreground c0c5db
set -l selection 283457
set -l comment 565f89
set -l red f7768e
set -l orange ff9e64
set -l yellow e0af68
set -l green 9ece6a
set -l purple bb9af7
set -l cyan 7dcfff
set -l blue 7aa2f7

# Fish color settings (TokyoNight Night theme)
set -U fish_color_normal $foreground
set -U fish_color_command $blue
set -U fish_color_keyword $purple
set -U fish_color_quote $yellow
set -U fish_color_redirection $foreground
set -U fish_color_end $orange
set -U fish_color_option $purple
set -U fish_color_error $red
set -U fish_color_param $cyan
set -U fish_color_comment $comment
set -U fish_color_selection --background=$selection
set -U fish_color_search_match --background=$selection
set -U fish_color_operator $green
set -U fish_color_escape $purple
set -U fish_color_autosuggestion $comment

# Pager colors
set -U fish_pager_color_progress $comment
set -U fish_pager_color_prefix $blue
set -U fish_pager_color_completion $foreground
set -U fish_pager_color_description $comment
set -U fish_pager_color_selected_background --background=$selection

# Clear FZF_DEFAULT_OPTS to remove any old incompatible options
set -e FZF_DEFAULT_OPTS

set -l FZF_NON_COLOR_OPTS

# FZF TokyoNight Night color scheme
set -Ux FZF_DEFAULT_OPTS "$FZF_NON_COLOR_OPTS"\
" --info=inline-right"\
" --ansi"\
" --border=none"\
" --color=bg+:#283457"\
" --color=bg:#1a1b26"\
" --color=border:#7dcfff"\
" --color=fg:#c0c5db"\
" --color=gutter:#1a1b26"\
" --color=header:#ff9e64"\
" --color=hl+:#7dcfff"\
" --color=hl:#7aa2f7"\
" --color=info:#565f89"\
" --color=marker:#bb9af7"\
" --color=pointer:#bb9af7"\
" --color=prompt:#7aa2f7"\
" --color=query:#c0c5db:regular"\
" --color=scrollbar:#7dcfff"\
" --color=separator:#ff9e64"\
" --color=spinner:#bb9af7"

set -x STARSHIP_CONFIG ~/.config/starship/config.toml
set -x AWS_PROFILE default
starship init fish | source

# pnpm
set -gx PNPM_HOME "/Users/thirai/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

if type -q kiro
    string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)
end
