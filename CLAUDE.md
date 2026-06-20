@AGENTS.md

# Claude Code Specific Instructions

## Rules

Claude Code also loads detailed rules from `.claude/rules/`:

- `conventional-commits.md` - commit prefix and branch naming details.
- `git-commit.md` - commit granularity, command form, and message rules.
- `github-pr-template.md` - PR format; private repositories use Japanese, public repositories use English.
- `harness-references.md` - harness engineering references and local configuration notes.

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
| Terraform file needs to be written or scaffolded | Delegate authoring to `terraform-writer` |
| Terraform file written or modified | Delegate review to `terraform-reviewer` |
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

- `/codex-review` - Codex CLI code review.
- `/zellij-swarm` - Parallel agent orchestration.
- `/finance-mcp` - Market and financial data via alphavantage / twelvedata / edinetdb MCP servers.
