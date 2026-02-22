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
- [Neovim](https://neovim.io/) — lazy.nvim, LSP, Treesitter, snacks.nvim

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

macOS
- [yabai](https://github.com/koekeishiya/yabai) + [skhd](https://github.com/koekeishiya/skhd) — window manager
- [Hammerspoon](https://www.hammerspoon.org/) — automation

Linux
- i3 / sway — window manager
- waybar / polybar — status bar
- xremap — key remapper

AI
- [Claude Code](https://claude.ai/claude-code) — settings, scripts, skills, rules
- OpenCode

Tools
- [aqua](https://aquaproj.github.io/) — CLI version manager (terraform, go, ...)
- [ghq](https://github.com/x-motemen/ghq) — repo manager
- [fzf](https://github.com/junegunn/fzf)
- [eza](https://github.com/eza-community/eza)

## Dependencies

`git`, `curl` — required before running setup.sh.
`rustup` is installed automatically by setup.sh.

## License

MIT
