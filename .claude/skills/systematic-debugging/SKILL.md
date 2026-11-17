---
name: systematic-debugging
description: Reproduce and debug failures through an evidence-first root-cause workflow. Use when tests fail, a bug is reported, behavior is flaky, an error message needs investigation, or the user asks to debug, diagnose, investigate, or fix a failure.
---

# Systematic Debugging

In Claude Code, first read `../tachikoma/references/claude-code.md` and map Cursor names with it.

Read and follow these skills from this skill's parent folder, in order:

1. `../in-your-own-words/SKILL.md`: restate the bug and the goal before touching code.
2. `../tachikoma/playbooks/bug-fix.md`: reproduce on the real surface, binary-search the cause, fix, verify on the same surface, land the failing repro before the fix. Skip its **Opening a PR** step unless the user asked for a PR.
3. `../principle-fix-root-causes/SKILL.md`: fix the first place the system went wrong, not where it surfaced.
4. `../principle-attack-the-premise/SKILL.md`: when two fixes that share one premise fail, test the premise before the next fix.

For a read-only diagnosis with no fix, follow `../tachikoma/playbooks/runtime-forensics.md` or `../tachikoma/playbooks/trace-forensics.md` instead of step 2.
