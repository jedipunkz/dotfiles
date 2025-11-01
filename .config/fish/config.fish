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

# Kanagawa Wave color palette
set -l foreground dcd7ba
set -l selection 2d4f67
set -l comment 727169
set -l red c34043
set -l orange ffa066
set -l yellow c0a36e
set -l green 76946a
set -l purple 957fb8
set -l cyan 6a9589
set -l blue 7e9cd8

# Fish color settings (Kanagawa Wave theme)
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

set -l FZF_NON_COLOR_OPTS

for arg in (echo $FZF_DEFAULT_OPTS | tr " " "\n")
    if not string match -q -- "--color*" $arg
        set -a FZF_NON_COLOR_OPTS $arg
    end
end

# FZF Kanagawa Wave color scheme
set -Ux FZF_DEFAULT_OPTS "$FZF_NON_COLOR_OPTS"\
" --highlight-line"\
" --info=inline-right"\
" --ansi"\
" --border=none"\
" --color=bg+:#2d4f67"\
" --color=bg:#1f1f28"\
" --color=border:#6a9589"\
" --color=fg:#dcd7ba"\
" --color=gutter:#1f1f28"\
" --color=header:#ffa066"\
" --color=hl+:#7fb4ca"\
" --color=hl:#7fb4ca"\
" --color=info:#727169"\
" --color=marker:#957fb8"\
" --color=pointer:#957fb8"\
" --color=prompt:#7e9cd8"\
" --color=query:#dcd7ba:regular"\
" --color=scrollbar:#6a9589"\
" --color=separator:#ffa066"\
" --color=spinner:#957fb8"

set -x STARSHIP_CONFIG ~/.starship
set -x AWS_PROFILE default
starship init fish | source


# pnpm
set -gx PNPM_HOME "/Users/thirai/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
