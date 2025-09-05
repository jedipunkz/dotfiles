if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_greeting ""

set -x PATH $HOME/.cargo/bin $HOME/.bin /usr/local/bin /usr/local/sbin /opt/homebrew/bin /bin /usr/bin /sbin /usr/sbin /usr/local/sessionmanagerplugin/bin $HOME/google-cloud-sdk/bin $HOME/.local/bin

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

# fzf color settings
set -l color00 '#1c1e26'
set -l color01 '#232530'
set -l color02 '#2e303e'
set -l color03 '#6f6f70'
set -l color04 '#9da0a2'
set -l color05 '#cbced0'
set -l color06 '#dcdfe4'
set -l color07 '#e3e6ee'
set -l color08 '#e93c58'
set -l color09 '#e58d7d'
set -l color0A '#efb993'
set -l color0B '#efaf8e'
set -l color0C '#24a8b4'
set -l color0D '#df5273'
set -l color0E '#b072d1'
set -l color0F '#e4a382'

set -l FZF_NON_COLOR_OPTS

for arg in (echo $FZF_DEFAULT_OPTS | tr " " "\n")
    if not string match -q -- "--color*" $arg
        set -a FZF_NON_COLOR_OPTS $arg
    end
end

set -Ux FZF_DEFAULT_OPTS "$FZF_NON_COLOR_OPTS"\
" --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
" --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
" --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"

set -x STARSHIP_CONFIG ~/.starship
set -x AWS_PROFILE default
starship init fish | source

