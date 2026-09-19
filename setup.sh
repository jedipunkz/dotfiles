#!/bin/bash
set -euo pipefail

CONF_HOME=$(cd "$(dirname "$0")" && pwd)

BACKUP_DIR="$HOME/dotfiles.backup"
BACKUP_MARKER="$BACKUP_DIR/.initial-backup-done"
SKIPPED_LINKS=()

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
    local src="$CONF_HOME/$1"
    local dest="$HOME/$1"

    if [[ ! -e "$src" ]]; then
        SKIPPED_LINKS+=("$dest (source missing: $src)")
        return 0
    fi

    if [[ -d "$dest" && ! -L "$dest" ]]; then
        SKIPPED_LINKS+=("$dest (real directory; move it aside and re-run)")
        return 0
    fi

    ln -sfn "$src" "$dest"
}

function copy_if_missing() {
    local src="$CONF_HOME/$1"
    local dest="$HOME/$1"

    if [[ -L "$dest" ]]; then
        unlink "$dest"
    fi

    if [[ ! -e "$dest" ]]; then
        cp "$src" "$dest"
    fi
}

function gitclone() {
    local dest="$HOME/$2"

    if [[ ! -d "$dest" ]]; then
        git clone "$1" "$dest"
    fi
}

function makedir() {
    local dir="$HOME/$1"

    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        chmod "$2" "$dir"
    fi
}

function backup() {
    local src="$HOME/$1"
    local dest="$BACKUP_DIR/${2:-${1##*/}}"

    if [[ -e "$BACKUP_MARKER" ]]; then
        return 0
    fi
    if [[ -L "$src" ]] || [[ ! -e "$src" ]]; then
        return 0
    fi
    if [[ -e "$dest" ]]; then
        return 0
    fi

    mv "$src" "$dest"
}

chkcommand curl
chkcommand git

makedir dotfiles.backup 0755
backup .config
backup .emacs.d
backup .claude/scripts
backup .claude/skills
backup .claude/rules
backup .claude/keybindings.json
backup .gemini/scripts gemini_scripts
backup .gemini/skills gemini_skills
backup .gemini/rules gemini_rules
backup .gemini/keybindings.json gemini_keybindings.json
backup .gemini/settings.json gemini_settings.json
backup .hammerspoon
backup .karabiner

touch "$BACKUP_MARKER"

makedir .config 0700
makedir .agents 0700
makedir .claude 0700
makedir .codex 0700
makedir .gemini 0700

if [[ "$(uname)" == "Linux" ]]; then
    link .gtkrc-2.0
    link .config/regolith
fi

link .emacs.d
link .zshrc
link .dir_colors
link .tmux.conf
link .tmux.conf.macos
link .tmux.conf.linux
link .tigrc

link .agents/skills

link .config/nvim
link .config/fish
link .config/wezterm
link .config/i3
link .config/sway
link .config/waybar
link .config/polybar
link .config/alacritty
link .config/gtk-3.0
link .config/xremap
link .config/yabai
link .config/skhd
link .config/zellij
link .config/starship
link .config/ghostty
link .config/opencode
link .config/eza
link .config/karabiner

makedir .config/herdr 0700
link .config/herdr/config.toml

link .claude/CLAUDE.md
link .claude/settings.json
link .claude/scripts
link .claude/skills
link .claude/rules
link .claude/agents
link .claude/keybindings.json
link .claude/hooks

link .codex/AGENTS.md
copy_if_missing .codex/config.toml
link .codex/hooks
link .codex/hooks.json
link .codex/rules

link .gemini/settings.json
link .gemini/scripts
link .gemini/skills
link .gemini/rules
link .gemini/agents
link .gemini/keybindings.json
link .gemini/hooks

link .hammerspoon

gitclone "$URL_TPM" .tmux/plugins/tpm
gitclone "$URL_ZSHCOMP" .zsh-completions

if [[ ${#SKIPPED_LINKS[@]} -gt 0 ]]; then
    echo
    echo "skipped ${#SKIPPED_LINKS[@]} link(s):"
    printf '  %s\n' "${SKIPPED_LINKS[@]}"
    exit 1
fi
