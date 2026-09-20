@AGENTS.md

# Claude Code Specific Instructions

## Rules

Claude Code also loads detailed rules from `.claude/rules/`:

- `conventional-commits.md` - commit prefix and branch naming details.
- `git-commit.md` - commit granularity, command form, and message rules.
- `github-pr-template.md` - PR format; private repositories use Japanese, public repositories use English.
- `harness-references.md` - harness engineering references and local configuration notes.

## Harness Component Policy

One implementation per component. `setup.sh` creates a second name in `$HOME` only
where a tool insists on a different discovery path.

| Component | Lives in | Read by | Needs a `setup.sh` change to add one |
|---|---|---|---|
| Skill | `.claude/skills/<name>/SKILL.md` | Claude Code, Codex, Gemini | No |
| Hook | `.claude/hooks/<name>.sh` | Claude Code, Codex | No, but register it in both configs |
| Subagent | `.claude/agents/<name>.md` | Claude Code (other agents unverified) | No |
| Detailed rule | `.claude/rules/<name>.md` | Claude Code only | No |
| Shared rule | `.claude/CLAUDE.md` | Claude Code, Codex | No |

### Skills

- Claude Code reads `~/.claude/skills` directly. Codex and Gemini discover
  `~/.agents/skills`, which `setup.sh` points at the same directory.
- Claude Code does not read `~/.agents/skills`, so the reverse direction — treating
  `.agents/skills` as the source — cannot work. Verified with `gemini skills list`
  and the `Skill roots` block of `codex debug prompt-input`.
- All three agents read the same `SKILL.md`, so keep it agent-neutral. When a skill
  must name a CLI, branch on the agent that is running it (`zellij-swarm` is the example).

### Hooks

- The scripts are not symlinked. `.claude/settings.json` and `.codex/hooks.json` both
  invoke the same files by absolute path under `~/.claude/hooks`.
- One script handles both tool vocabularies: Claude Code sends `Read`/`Edit`/`Write`/`Grep`
  with `.tool_input.file_path`; Codex sends `apply_patch` with the patch body in
  `.tool_input.command`.
- The event sets differ too. Confirm payload fields against primary docs instead of
  guessing — Claude Code has no `is_error` on `Stop`, and reports errors through a
  separate `StopFailure` event carrying `error_type`.
- `herdr-agent-state.sh` is the exception: herdr ships one copy per integration with the
  agent name hardcoded, so the Codex copy stays in `.codex/`.

### After changing a skill or hook

1. Register a new hook in both `.claude/settings.json` and `.codex/hooks.json`.
2. `bash .claude/hooks/hooks_test.sh` — add a case when you add a branch.
3. `shellcheck -S warning .claude/hooks/*.sh`
4. `bash setup.sh --dry-run` — expect no creates or replaces.

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

## Available Skills

Defined once in `.claude/skills/`; Codex and Gemini see the same set via `~/.agents/skills`.

- `/codex-review` - Codex CLI code review.
- `/finance-mcp` - Market and financial data via alphavantage / twelvedata / edinetdb MCP servers.
- `/github-publish` - Branch push and PR creation workflow.
- `/systematic-debugging` - Evidence-first root-cause workflow.
- `/test-driven-development` - Red-green-refactor workflow.
- `/verification-before-completion` - Verification checklist before reporting work done.
- `/web-research` - Primary-source-first web research.
- `/zellij-swarm` - Parallel agent orchestration.
