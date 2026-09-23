#!/bin/bash
set -euo pipefail

CONF_HOME=$(cd "$(dirname "$0")" && pwd)

BACKUP_DIR="$CONF_HOME/backup"
BACKUP_MARKER="$BACKUP_DIR/.initial-backup-done"

URL_TPM="https://github.com/tmux-plugins/tpm"
URL_ZSHCOMP="https://github.com/zsh-users/zsh-completions.git"

DRY_RUN=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--dry-run)
            DRY_RUN=1
            ;;
        -h|--help)
            echo "usage: $0 [-n|--dry-run]"
            exit 0
            ;;
        *)
            echo "unknown option: $1" >&2
            echo "usage: $0 [-n|--dry-run]" >&2
            exit 2
            ;;
    esac
    shift
done

case "$(uname)" in
    Darwin)
        OS=macos
        ;;
    Linux)
        OS=linux
        ;;
    *)
        echo "unsupported platform: $(uname)" >&2
        exit 1
        ;;
esac

N_CREATE=0
N_REPLACE=0
N_OK=0
N_SKIP=0
N_BACKUP=0
PROBLEMS=()

function report() {
    local state="$1"
    local path="$2"
    local detail="${3:-}"

    case "$state" in
        create)
            N_CREATE=$((N_CREATE + 1))
            ;;
        replace)
            N_REPLACE=$((N_REPLACE + 1))
            ;;
        backup)
            N_BACKUP=$((N_BACKUP + 1))
            ;;
        ok)
            N_OK=$((N_OK + 1))
            if [[ $DRY_RUN -eq 0 ]]; then
                return 0
            fi
            ;;
        skip)
            N_SKIP=$((N_SKIP + 1))
            if [[ $DRY_RUN -eq 0 ]]; then
                return 0
            fi
            ;;
    esac

    if [[ -n "$detail" ]]; then
        printf '  %-8s %s (%s)\n' "$state" "$path" "$detail"
    else
        printf '  %-8s %s\n' "$state" "$path"
    fi
}

function problem() {
    PROBLEMS+=("$1 — $2")
    printf '  %-8s %s (%s)\n' "blocked" "$1" "$2"
}

function chkcommand() {
    if hash "$1" 2>/dev/null; then
        return 0
    else
        echo "you need $1 command" >&2
        exit 1
    fi
}

# link <repo-path> [dest-path]
# dest-path defaults to repo-path. Pass it when one file in the repository has
# to appear under a second name in $HOME, e.g. the shared skills directory that
# Codex and Gemini look for at ~/.agents/skills.
function link() {
    local rel="$1"
    local dest_rel="${2:-$rel}"
    local src="$CONF_HOME/$rel"
    local dest="$HOME/$dest_rel"

    if [[ ! -e "$src" ]]; then
        problem "$dest_rel" "source $rel missing in repository"
        return 0
    fi

    if [[ -L "$dest" ]]; then
        if [[ "$(readlink "$dest")" == "$src" ]]; then
            report ok "$dest_rel"
            return 0
        fi
        report replace "$dest_rel" "was -> $(readlink "$dest")"
    elif [[ -d "$dest" ]]; then
        problem "$dest_rel" "real directory in the way; move it aside"
        return 0
    elif [[ -e "$dest" ]]; then
        problem "$dest_rel" "real file in the way; move it aside"
        return 0
    else
        report create "$dest_rel"
    fi

    if [[ $DRY_RUN -eq 0 ]]; then
        ln -sfn "$src" "$dest"
    fi
}

function link_macos() {
    if [[ "$OS" == macos ]]; then
        link "$1"
    else
        report skip "$1" "macos only"
    fi
}

function link_linux() {
    if [[ "$OS" == linux ]]; then
        link "$1"
    else
        report skip "$1" "linux only"
    fi
}

# copy_if_missing <repo-path> [dest-path]
# dest-path defaults to repo-path. Use it for files the tool rewrites itself:
# the repository keeps a template, and the live copy stays untracked.
function copy_if_missing() {
    local rel="$1"
    local dest_rel="${2:-$rel}"
    local src="$CONF_HOME/$rel"
    local dest="$HOME/$dest_rel"

    if [[ ! -e "$src" ]]; then
        problem "$dest_rel" "source $rel missing in repository"
        return 0
    fi

    if [[ -L "$dest" ]]; then
        report replace "$dest_rel" "symlink replaced by a real copy"
        if [[ $DRY_RUN -eq 0 ]]; then
            unlink "$dest"
            cp "$src" "$dest"
        fi
        return 0
    fi

    if [[ -e "$dest" ]]; then
        report ok "$dest_rel" "real file kept"
        return 0
    fi

    report create "$dest_rel" "copy, not symlink"
    if [[ $DRY_RUN -eq 0 ]]; then
        cp "$src" "$dest"
    fi
}

function gitclone() {
    local url="$1"
    local rel="$2"
    local dest="$HOME/$rel"

    if [[ -d "$dest" ]]; then
        report ok "$rel"
        return 0
    fi

    report create "$rel" "git clone"
    if [[ $DRY_RUN -eq 0 ]]; then
        git clone "$url" "$dest"
    fi
}

function makedir() {
    local rel="$1"
    local mode="$2"
    local dir="$HOME/$rel"

    if [[ -d "$dir" ]]; then
        report ok "$rel/"
        return 0
    fi

    report create "$rel/" "mkdir $mode"
    if [[ $DRY_RUN -eq 0 ]]; then
        mkdir -p "$dir"
        chmod "$mode" "$dir"
    fi
}

function backup() {
    local rel="$1"
    local src="$HOME/$rel"
    local dest="$BACKUP_DIR/${2:-${rel##*/}}"

    if [[ -e "$BACKUP_MARKER" ]]; then
        return 0
    fi
    if [[ -L "$src" ]] || [[ ! -e "$src" ]]; then
        return 0
    fi
    if [[ -e "$dest" ]]; then
        return 0
    fi

    report backup "$rel" "moved to $dest"
    if [[ $DRY_RUN -eq 0 ]]; then
        mv "$src" "$dest"
    fi
}

chkcommand curl
chkcommand git

if [[ $DRY_RUN -eq 1 ]]; then
    echo "dry run on $OS: nothing will be changed"
else
    echo "installing on $OS"
fi
echo

if [[ $DRY_RUN -eq 0 ]]; then
    mkdir -p "$BACKUP_DIR"
fi
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

if [[ $DRY_RUN -eq 0 ]]; then
    touch "$BACKUP_MARKER"
fi

makedir .config 0700
makedir .agents 0700
makedir .claude 0700
makedir .codex 0700
makedir .gemini 0700

link .emacs.d
link .zshrc
link .dir_colors
link .tmux.conf
link .tmux.conf.macos
link .tmux.conf.linux
link .tigrc

link .config/nvim
link .config/fish
link .config/wezterm
link .config/alacritty
link .config/ghostty
link .config/zellij
link .config/starship
link .config/opencode
link .config/eza

link_macos .config/yabai
link_macos .config/skhd
link_macos .config/karabiner
link_macos .hammerspoon

link_linux .gtkrc-2.0
link_linux .config/gtk-3.0
link_linux .config/i3
link_linux .config/sway
link_linux .config/waybar
link_linux .config/polybar
link_linux .config/xremap
link_linux .config/regolith

makedir .config/herdr 0700
link .config/herdr/config.toml

makedir .config/gm 0700
link .config/gm/gm.toml

link .claude/CLAUDE.md
link .claude/settings.json
link .claude/scripts
link .claude/skills
link .claude/rules
link .claude/agents
link .claude/keybindings.json
link .claude/hooks

# Codex and Gemini discover personal skills at ~/.agents/skills; Claude Code
# reads ~/.claude/skills. One directory, two names.
link .claude/skills .agents/skills

link .codex/AGENTS.md
copy_if_missing .codex/config.toml.example .codex/config.toml
link .codex/hooks.json
link .codex/herdr-agent-state.sh
link .codex/rules

link .gemini/settings.json
link .gemini/scripts
link .gemini/skills
link .gemini/rules
link .gemini/agents
link .gemini/keybindings.json
link .gemini/hooks

gitclone "$URL_TPM" .tmux/plugins/tpm
gitclone "$URL_ZSHCOMP" .zsh-completions

echo
printf 'created %d, replaced %d, unchanged %d, skipped %d, backed up %d\n' \
    "$N_CREATE" "$N_REPLACE" "$N_OK" "$N_SKIP" "$N_BACKUP"

if [[ ${#PROBLEMS[@]} -gt 0 ]]; then
    echo
    echo "${#PROBLEMS[@]} problem(s) need a decision:"
    printf '  %s\n' "${PROBLEMS[@]}"
    exit 1
fi
