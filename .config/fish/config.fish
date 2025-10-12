if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_greeting ""

set -x PATH $HOME/.cargo/bin $HOME/.bin /usr/local/bin /usr/local/sbin /opt/homebrew/bin /bin /usr/bin /sbin /usr/sbin /usr/local/sessionmanagerplugin/bin $HOME/google-cloud-sdk/bin $HOME/.local/bin $HOME/.lmstudio/bin

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

# Tokyo Night color palette
set -l foreground c0caf5
set -l selection 283457
set -l comment 565f89
set -l red f7768e
set -l orange ff9e64
set -l yellow e0af68
set -l green 9ece6a
set -l purple 9d7cd8
set -l cyan 7dcfff
set -l pink bb9af7

# Fish color settings (Tokyo Night theme)
set -U fish_color_normal $foreground
set -U fish_color_command $cyan
set -U fish_color_keyword $pink
set -U fish_color_quote $yellow
set -U fish_color_redirection $foreground
set -U fish_color_end $orange
set -U fish_color_option $pink
set -U fish_color_error $red
set -U fish_color_param $purple
set -U fish_color_comment $comment
set -U fish_color_selection --background=$selection
set -U fish_color_search_match --background=$selection
set -U fish_color_operator $green
set -U fish_color_escape $pink
set -U fish_color_autosuggestion $comment

# Pager colors
set -U fish_pager_color_progress $comment
set -U fish_pager_color_prefix $cyan
set -U fish_pager_color_completion $foreground
set -U fish_pager_color_description $comment
set -U fish_pager_color_selected_background --background=$selection

set -l FZF_NON_COLOR_OPTS

for arg in (echo $FZF_DEFAULT_OPTS | tr " " "\n")
    if not string match -q -- "--color*" $arg
        set -a FZF_NON_COLOR_OPTS $arg
    end
end

# FZF Tokyo Night color scheme
set -Ux FZF_DEFAULT_OPTS "$FZF_NON_COLOR_OPTS"\
" --highlight-line"\
" --info=inline-right"\
" --ansi"\
" --border=none"\
" --color=bg+:#283457"\
" --color=bg:#16161e"\
" --color=border:#27a1b9"\
" --color=fg:#c0caf5"\
" --color=gutter:#16161e"\
" --color=header:#ff9e64"\
" --color=hl+:#2ac3de"\
" --color=hl:#2ac3de"\
" --color=info:#545c7e"\
" --color=marker:#ff007c"\
" --color=pointer:#ff007c"\
" --color=prompt:#2ac3de"\
" --color=query:#c0caf5:regular"\
" --color=scrollbar:#27a1b9"\
" --color=separator:#ff9e64"\
" --color=spinner:#ff007c"

set -x STARSHIP_CONFIG ~/.starship
set -x AWS_PROFILE default
starship init fish | source

