@AGENTS.md

# Claude Code Specific Instructions

## Rules

Claude Code also loads detailed rules from `.claude/rules/`:

- `conventional-commits.md` - commit prefix and branch naming details.
- `git-commit.md` - commit granularity, command form, and message rules.
- `github-pr-template.md` - PR format; private repositories use Japanese, public repositories use English.
- `harness-references.md` - harness engineering references and local configuration notes.

## ハーネス構成（Claude Code 固有）

配置と管理方針の本体は `AGENTS.md` の「ハーネス構成の管理方針」にある。ここには Claude Code だけが読む要素を書く。

- `.claude/agents/`: subagent 定義。Claude Code が読む（Codex / Gemini が読むかは未確認）。
- `.claude/rules/`: Claude Code のみが読む詳細ルール。Codex にも効かせたいルールは `.claude/CLAUDE.md` か `.claude/skills/` に置く。
- `.claude/settings.json`: permissions / env / hooks / MCP / モデル設定。hook を足したときは `.codex/hooks.json` 側の登録も必要。

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
| TypeScript file needs to be written or scaffolded | Delegate authoring to `typescript-writer` |
| TypeScript file written or modified | Delegate review to `typescript-reviewer` |
| Python file needs to be written or scaffolded | Delegate authoring to `python-writer` |
| Python file written or modified | Delegate review to `python-reviewer` |
| Dart file written or modified | Delegate review to `dart-reviewer` |
| Proto file written or modified | Delegate review to `proto-reviewer` |
| SQL file or migration written or modified | Delegate review to `sql-reviewer` |
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
