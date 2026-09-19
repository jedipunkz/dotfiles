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
    local dest="$2"

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
    local dest="$2"

    if [[ -L "$dest" ]]; then
        unlink "$dest" || return 1
    fi

    if [[ ! -e "$dest" ]]; then
        cp "$src" "$dest" || return 1
    fi

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
        mkdir -p "$1" && chmod "$2" "$1" || return 1
    fi
}

# Move pre-existing user state aside exactly once. Never overwrite an existing
# backup: after the first run the targets are this script's own symlinks, and
# overwriting would replace the real originals with links into this repository.
function backup() {
    local src="$1"
    local dest="$2"

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

makedir "$BACKUP_DIR" 0755
backup "$HOME/.config" "$HOME/dotfiles.backup/.config"
backup "$HOME/.emacs.d" "$HOME/dotfiles.backup/.emacs.d"
backup "$HOME/.claude/scripts" "$HOME/dotfiles.backup/scripts"
backup "$HOME/.claude/skills" "$HOME/dotfiles.backup/skills"
backup "$HOME/.claude/rules" "$HOME/dotfiles.backup/rules"
backup "$HOME/.claude/keybindings.json" "$HOME/dotfiles.backup/keybindings.json"
backup "$HOME/.gemini/scripts" "$HOME/dotfiles.backup/gemini_scripts"
backup "$HOME/.gemini/skills" "$HOME/dotfiles.backup/gemini_skills"
backup "$HOME/.gemini/rules" "$HOME/dotfiles.backup/gemini_rules"
backup "$HOME/.gemini/keybindings.json" "$HOME/dotfiles.backup/gemini_keybindings.json"
backup "$HOME/.gemini/settings.json" "$HOME/dotfiles.backup/gemini_settings.json"
backup "$HOME/.hammerspoon" "$HOME/dotfiles.backup/.hammerspoon"
backup "$HOME/.karabiner" "$HOME/dotfiles.backup/.karabiner"

touch "$BACKUP_MARKER"

makedir "$HOME/.config" 700
makedir "$HOME/.agents" 700
makedir "$HOME/.claude" 700
makedir "$HOME/.codex" 700
makedir "$HOME/.gemini" 700

# Linux-specific links
if [[ "$(uname)" == "Linux" ]]; then
    link .gtkrc-2.0 "$HOME/.gtkrc-2.0"
    link .config/regolith "$HOME/.config/regolith"
fi

# Common dotfiles
link .emacs.d "$HOME/.emacs.d"
link .zshrc "$HOME/.zshrc"
link .dir_colors "$HOME/.dir_colors"
link .tmux.conf "$HOME/.tmux.conf"
link .tmux.conf.macos "$HOME/.tmux.conf.macos"
link .tmux.conf.linux "$HOME/.tmux.conf.linux"
link .tigrc "$HOME/.tigrc"

# .agents directory links
link .agents/skills "$HOME/.agents/skills"

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
link .config/karabiner "$HOME/.config/karabiner"

# herdr stores runtime state (sockets, logs, session.json) under ~/.config/herdr,
# so link only the config.toml file rather than the directory.
makedir "$HOME/.config/herdr" 700
link .config/herdr/config.toml "$HOME/.config/herdr/config.toml"

# .claude directory links
link .claude/CLAUDE.md "$HOME/.claude/CLAUDE.md"
link .claude/settings.json "$HOME/.claude/settings.json"
link .claude/scripts "$HOME/.claude/scripts"
link .claude/skills "$HOME/.claude/skills"
link .claude/rules "$HOME/.claude/rules"
link .claude/agents "$HOME/.claude/agents"
link .claude/keybindings.json "$HOME/.claude/keybindings.json"
link .claude/hooks "$HOME/.claude/hooks"

# .codex directory links
link .codex/AGENTS.md "$HOME/.codex/AGENTS.md"
# Codex stores mutable user state such as trusted projects in config.toml.
# Keep this as a real file so Codex does not write runtime state into dotfiles.
copy_if_missing .codex/config.toml "$HOME/.codex/config.toml"
link .codex/hooks "$HOME/.codex/hooks"
link .codex/hooks.json "$HOME/.codex/hooks.json"
link .codex/rules "$HOME/.codex/rules"

# .gemini directory links
link .gemini/settings.json "$HOME/.gemini/settings.json"
link .gemini/scripts "$HOME/.gemini/scripts"
link .gemini/skills "$HOME/.gemini/skills"
link .gemini/rules "$HOME/.gemini/rules"
link .gemini/agents "$HOME/.gemini/agents"
link .gemini/keybindings.json "$HOME/.gemini/keybindings.json"
link .gemini/hooks "$HOME/.gemini/hooks"

# Other application links
link .hammerspoon "$HOME/.hammerspoon"

gitclone "$URL_TPM" ~/.tmux/plugins/tpm
gitclone "$URL_ZSHCOMP" "$HOME/.zsh-completions"

if [[ ${#SKIPPED_LINKS[@]} -gt 0 ]]; then
    echo
    echo "skipped ${#SKIPPED_LINKS[@]} link(s):"
    printf '  %s\n' "${SKIPPED_LINKS[@]}"
    exit 1
fi
