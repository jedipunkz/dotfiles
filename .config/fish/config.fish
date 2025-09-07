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

# Doom One color palette
set -l doom_bg '#282c34'
set -l doom_bg_alt '#21242b'
set -l doom_dark '#1c1f24'
set -l doom_white '#dfdfdf'
set -l doom_light_grey '#5c6370'
set -l doom_grey '#3f444a'
set -l doom_dark_grey '#2c313c'
set -l doom_red '#ff6c6b'
set -l doom_orange '#da8548'
set -l doom_green '#98be65'
set -l doom_teal '#4db5bd'
set -l doom_yellow '#ecbe7b'
set -l doom_blue '#51afef'
set -l doom_dark_blue '#2257a0'
set -l doom_magenta '#c678dd'
set -l doom_violet '#a9a1e1'
set -l doom_cyan '#46d9ff'

# Fish color settings (Doom One theme)
set -U fish_color_normal $doom_white
set -U fish_color_command $doom_blue
set -U fish_color_quote $doom_green
set -U fish_color_redirection $doom_violet
set -U fish_color_end $doom_red
set -U fish_color_error $doom_red
set -U fish_color_param $doom_white
set -U fish_color_comment $doom_light_grey
set -U fish_color_match $doom_cyan
set -U fish_color_selection --background=$doom_grey
set -U fish_color_search_match --background=$doom_grey
set -U fish_color_history_current --bold
set -U fish_color_operator $doom_violet
set -U fish_color_escape $doom_cyan
set -U fish_color_cwd $doom_green
set -U fish_color_cwd_root $doom_red
set -U fish_color_valid_path --underline
set -U fish_color_autosuggestion $doom_light_grey
set -U fish_color_user $doom_green
set -U fish_color_host $doom_blue
set -U fish_color_cancel $doom_red

# Pager colors
set -U fish_pager_color_completion $doom_white --bold
set -U fish_pager_color_description $doom_cyan
set -U fish_pager_color_prefix $doom_yellow --bold
set -U fish_pager_color_progress $doom_green

set -l FZF_NON_COLOR_OPTS

for arg in (echo $FZF_DEFAULT_OPTS | tr " " "\n")
    if not string match -q -- "--color*" $arg
        set -a FZF_NON_COLOR_OPTS $arg
    end
end

set -Ux FZF_DEFAULT_OPTS "$FZF_NON_COLOR_OPTS"\
" --color=bg+:$doom_grey,bg:$doom_bg,spinner:$doom_cyan,hl:$doom_blue"\
" --color=fg:$doom_white,header:$doom_blue,info:$doom_yellow,pointer:$doom_cyan"\
" --color=marker:$doom_green,fg+:$doom_white,prompt:$doom_blue,hl+:$doom_cyan"

set -x STARSHIP_CONFIG ~/.starship
set -x AWS_PROFILE default
starship init fish | source

