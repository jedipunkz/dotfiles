# Claude Code - Dotfiles Harness

## Project Context
Personal dotfiles for macOS. Managed via `setup.sh` symlinks into `~/`.
Language: Japanese for all responses.

## Architecture
```
dotfiles/
├── .config/       # User-specific configs (~/.config/ symlinked)
├── .claude/       # Claude Code harness (hooks, rules, skills, settings)
├── bin/           # Personal binaries
└── setup.sh       # Symlink installer
```

## Rules (auto-loaded from .claude/rules/)
- `conventional-commits.md` — commit prefix and branch naming
- `github-pr-template.md` — PR format (private=日本語, public=English)

## Non-obvious Conventions

**Symlinks**: `setup.sh` links `.claude/` → `~/.claude/`, `.config/*` → `~/.config/*`.
Always verify symlink targets exist before creating new ones.

**Shell scripts**: POSIX-compliant, `#!/usr/bin/env bash`. No zsh-specific syntax.

**Secrets**: Never write `.env` or credential values inline. Use env vars.

**Destructive ops**: `git reset --hard`, `rm -rf`, force push are blocked by hooks/deny rules. Do not attempt to bypass.

## Multi-Agent Dispatch Rules

Agent Teams is enabled (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`).
Custom subagents live in `.claude/agents/`. **Use them proactively.**

### Auto-dispatch to subagents

| Condition | Action |
|---|---|
| Task has 3+ independent parts with no shared state | Spawn parallel subagents |
| Research needed before implementation | Delegate to `researcher` first, then implement |
| Shell script written or modified | Delegate review to `shell-reviewer` |
| Go file written or modified | Delegate review to `go-reviewer` |
| New hook or permission rule added | Delegate audit to `security-auditor` |
| Single small change (<2 min) | No dispatch — do it directly |

### Parallel dispatch (spawn simultaneously when tasks are independent)

```
investigate X  +  implement Y  +  review Z
     ↓                ↓               ↓
 researcher      main thread     shell-reviewer
```

### Sequential dispatch (when output of A feeds B)

```
researcher → findings → implement → shell-reviewer → verdict → commit
```

### Do NOT dispatch when

- Single-file change with no research needed
- Task needs mid-execution user confirmation
- Task takes under 30 seconds

## Available Skills
- `/codex-review` — Codex CLI code review
- `/zellij-swarm` — Parallel agent orchestration
