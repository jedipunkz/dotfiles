# dotfiles

## Install

```sh
git clone https://github.com/jedipunkz/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash setup.sh
```

Backs up existing configs to `~/dotfiles.backup` before linking.

## Contents

Editor
- [Neovim](https://neovim.io/) — [lazy.nvim](https://github.com/folke/lazy.nvim), [LSP](https://microsoft.github.io/language-server-protocol/), [Tree-sitter](https://tree-sitter.github.io/tree-sitter/), [snacks.nvim](https://github.com/folke/snacks.nvim)

Shell
- [Fish](https://fishshell.com/)
- [Zsh](https://www.zsh.org/)
- [Starship](https://starship.rs/) — prompt

Terminal
- [WezTerm](https://wezfurlong.org/wezterm/)
- [Ghostty](https://ghostty.org/)
- [Alacritty](https://alacritty.org/)
- [Zellij](https://zellij.dev/) — multiplexer
- [tmux](https://github.com/tmux/tmux)
- [herdr](https://herdr.dev/) — multiplexer

macOS
- [yabai](https://github.com/koekeishiya/yabai) + [skhd](https://github.com/koekeishiya/skhd) — window manager
- [Hammerspoon](https://www.hammerspoon.org/) — automation

Linux
- [i3](https://i3wm.org/) / [sway](https://swaywm.org/) — window manager
- [waybar](https://github.com/Alexays/Waybar) / [polybar](https://polybar.github.io/) — status bar
- [xremap](https://github.com/xremap/xremap) — key remapper

AI
- [Claude Code](https://claude.ai/claude-code) — settings, scripts, skills, rules
- [Codex](https://openai.com/codex/) — AGENTS.md, hooks, rules, shared skills
- [OpenCode](https://opencode.ai/)

Tools
- [aqua](https://aquaproj.github.io/) — CLI version manager (terraform, go, ...)
- [ghq](https://github.com/x-motemen/ghq) — repo manager
- [fzf](https://github.com/junegunn/fzf)
- [eza](https://github.com/eza-community/eza)

## Dependencies

[`git`](https://git-scm.com/), [`curl`](https://curl.se/) — required before running setup.sh.
[`rustup`](https://rustup.rs/) is installed automatically by setup.sh.

## License

MIT
