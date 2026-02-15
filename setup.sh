#!/bin/bash
set -euo pipefail

# set envs
CONF_HOME=$(cd "$(dirname "$0")" && pwd)

URL_TPM="https://github.com/tmux-plugins/tpm"
URL_ZSHCOMP="https://github.com/zsh-users/zsh-completions.git"

function chkcommand() {
    if hash "$1" 2>/dev/null; then
        return 0
    else
        echo "you need $1 command"
        exit 1
    fi
}

function link() {
    ln -f -s "$CONF_HOME/$1" "$2" || return 1
    return 0
}

function gitclone() {
    if [[ ! -d "$2" ]]; then
        git clone "$1" "$2" || return 1
    fi
    return 0
}

function makedir() {
    if [[ ! -d "$1" ]]; then
        mkdir "$1" && chmod "$2" "$1" || return 1
    fi
}

function backup() {
    if [[ -d "$1" ]]; then
        rm -rf "$2"
        mv "$1" "$2"
    fi
}

chkcommand curl
chkcommand git

makedir "$HOME/dotfiles.backup" 0755
backup "$HOME/.config" "$HOME/dotfiles.backup/.config"
backup "$HOME/.emacs.d" "$HOME/dotfiles.backup/.emacs.d"
backup "$HOME/.claude/scripts" "$HOME/dotfiles.backup/scripts"
backup "$HOME/.claude/skills" "$HOME/dotfiles.backup/skills"
backup "$HOME/.hammerspoon" "$HOME/dotfiles.backup/.hammerspoon"
backup "$HOME/aqua.yaml" "$HOME/dotfiles.backup/aqua.yaml"

makedir "$HOME/.config" 700
makedir "$HOME/.claude" 700

# Linux-specific links
if [[ "$(uname)" == "Linux" ]]; then
    link .gtkrc-2.0 "$HOME/.gtkrc-2.0"
    link .Xresources "$HOME/.Xresources"
    link .imwheelrc "$HOME/.imwheelrc"
    link .config/regolith "$HOME/.config/regolith"
fi

# Common dotfiles
link .xbindkeysrc "$HOME/.xbindkeysrc"
link .xinitrc "$HOME/.xinitrc"
link .emacs.d "$HOME/.emacs.d"
link .zshrc "$HOME/.zshrc"
link .dir_colors "$HOME/.dir_colors"
link .tmux.conf "$HOME/.tmux.conf"
link .tmux.conf.macos "$HOME/.tmux.conf.macos"
link .tmux.conf.linux "$HOME/.tmux.conf.linux"
link .starship "$HOME/.starship"
link .vim "$HOME/.vim"
link .tigrc "$HOME/.tigrc"

# .config directory links
link .config/nvim "$HOME/.config/nvim"
link .config/fish "$HOME/.config/fish"
link .config/wezterm "$HOME/.config/wezterm"
link .config/i3 "$HOME/.config/i3"
link .config/sway "$HOME/.config/sway"
link .config/waybar "$HOME/.config/waybar"
link .config/polybar "$HOME/.config/polybar"
link .config/alacritty "$HOME/.config/alacritty"
link .config/gtk-3.0 "$HOME/.config/gtk-3.0"
link .config/xremap "$HOME/.config/xremap"
link .config/yabai "$HOME/.config/yabai"
link .config/skhd "$HOME/.config/skhd"
link .config/zellij "$HOME/.config/zellij"
link .config/starship "$HOME/.config/starship"
link .config/ghostty "$HOME/.config/ghostty"
link .config/opencode "$HOME/.config/opencode"
link .config/eza "$HOME/.config/eza"

# .claude directory links
link .claude/settings.json "$HOME/.claude/settings.json"
link .claude/scripts "$HOME/.claude/scripts"
link .claude/skills "$HOME/.claude/skills"

# Other application links
link .hammerspoon "$HOME/.hammerspoon"
link aqua.yaml "$HOME/aqua.yaml"

gitclone "$URL_TPM" ~/.tmux/plugins/tpm
gitclone "$URL_ZSHCOMP" "$HOME/.zsh-completions"

# Install rustup safely via temp file
rustup_installer=$(mktemp)
curl https://sh.rustup.rs -sSf -o "$rustup_installer"
sh "$rustup_installer"
rm -f "$rustup_installer"
