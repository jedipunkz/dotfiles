#!/bin/bash
set -euo pipefail

# set envs
CONF_HOME=$(cd "$(dirname "$0")" && pwd)

BACKUP_DIR="$HOME/dotfiles.backup"
# Written after the first backup pass. Its presence means every backup target is
# now either a symlink this script created or already saved, so re-runs skip them.
BACKUP_MARKER="$BACKUP_DIR/.initial-backup-done"
SKIPPED_LINKS=()

URL_TPM="https://github.com/tmux-plugins/tpm"
URL_ZSHCOMP="https://github.com/zsh-users/zsh-completions.git"

# Every helper below takes a path relative to $HOME. link and copy_if_missing use
# that same relative path inside this repository as the source.

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

    # ln puts the link inside dest when dest is a real directory, which silently
    # creates a nested link instead of replacing it. Refuse and report instead.
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

# Move pre-existing user state aside exactly once. Never overwrite an existing
# backup: after the first run the targets are this script's own symlinks, and
# overwriting would replace the real originals with links into this repository.
# The second argument renames the backup; it defaults to the basename of the path.
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

# Linux-specific links
if [[ "$(uname)" == "Linux" ]]; then
    link .gtkrc-2.0
    link .config/regolith
fi

# Common dotfiles
link .emacs.d
link .zshrc
link .dir_colors
link .tmux.conf
link .tmux.conf.macos
link .tmux.conf.linux
link .tigrc

# .agents directory links
link .agents/skills

# .config directory links
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

# herdr stores runtime state (sockets, logs, session.json) under ~/.config/herdr,
# so link only the config.toml file rather than the directory.
makedir .config/herdr 0700
link .config/herdr/config.toml

# .claude directory links
link .claude/CLAUDE.md
link .claude/settings.json
link .claude/scripts
link .claude/skills
link .claude/rules
link .claude/agents
link .claude/keybindings.json
link .claude/hooks

# .codex directory links
link .codex/AGENTS.md
# Codex stores mutable user state such as trusted projects in config.toml.
# Keep this as a real file so Codex does not write runtime state into dotfiles.
copy_if_missing .codex/config.toml
link .codex/hooks
link .codex/hooks.json
link .codex/rules

# .gemini directory links
link .gemini/settings.json
link .gemini/scripts
link .gemini/skills
link .gemini/rules
link .gemini/agents
link .gemini/keybindings.json
link .gemini/hooks

# Other application links
link .hammerspoon

gitclone "$URL_TPM" .tmux/plugins/tpm
gitclone "$URL_ZSHCOMP" .zsh-completions

if [[ ${#SKIPPED_LINKS[@]} -gt 0 ]]; then
    echo
    echo "skipped ${#SKIPPED_LINKS[@]} link(s):"
    printf '  %s\n' "${SKIPPED_LINKS[@]}"
    exit 1
fi
