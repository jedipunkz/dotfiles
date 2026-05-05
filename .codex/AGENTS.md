# Codex - Dotfiles Harness

## Project Context

Personal dotfiles for macOS. Managed via `setup.sh` symlinks into `~/`.
Respond in Japanese unless the user explicitly requests another language.

## Architecture

```
dotfiles/
├── .agents/       # Codex agent skills
├── .codex/        # Codex config, hooks, and exec rules
├── .config/       # User-specific configs (~/.config/ symlinked)
├── .claude/       # Claude Code harness
└── setup.sh       # Symlink installer
```

## Conventions

- Symlinks: `setup.sh` links managed files into `$HOME`. Verify targets exist before adding new links.
- Shell scripts: prefer portable bash with `#!/bin/bash` or `#!/usr/bin/env bash`; avoid zsh-only syntax unless the file is zsh-specific.
- Secrets: never read, write, or inline `.env`, credentials, private keys, or token files. Use environment variables or a secrets manager.
- Destructive operations: do not run `git reset --hard`, `git clean -f`, `rm -rf`, force push, or broad permission changes unless the user explicitly requests them.
- Search: prefer `rg` and `rg --files` over slower alternatives.

## Git Commit Rules

- Commit in meaningful minimal units. Do not stage unrelated changes.
- Before committing, inspect `git status` and relevant diffs.
- Use one-line `git commit -m "<message>"` form by default. Do not use heredoc command substitution for commit messages.
- Commit messages must be in English.
- Use a conventional prefix:
  - `feat:` new feature
  - `fix:` bug fix
  - `docs:` documentation only
  - `style:` formatting only
  - `refactor:` behavior-preserving code change
  - `perf:` performance improvement
  - `test:` tests
  - `chore:` tooling, build, or maintenance
  - `revert:` revert
- Start the subject with an imperative verb, keep it concise, and do not end with a period.

## Branch Naming

Use `<prefix>/<short-description>` in lowercase kebab-case, for example:

```
feat/user-authentication
fix/login-redirect
docs/api-documentation
refactor/user-validation
chore/dependency-updates
```

## GitHub PR Rules

Use `gh pr create`. Before creating a PR, check repository visibility:

```bash
gh repo view --json isPrivate --jq '.isPrivate'
```

For private repositories, write the PR description in Japanese. For public repositories, write it in English.

Use this body structure:

```markdown
## Why

- <background>
- <related issue or N/A>

## What

- <change>

## Reference

- <reference or N/A>
```

Do not include `Generated with Claude Code`, `Co-Authored-By`, `Summary`, or `Test Plan` sections unless the user explicitly asks for them.

## Available Skills

- `$zellij-swarm` - Parallel Codex orchestration through Zellij panes and git worktrees.
- `$codex-review` - Nested Codex CLI review workflow; prefer Codex built-in review unless explicitly requested.
