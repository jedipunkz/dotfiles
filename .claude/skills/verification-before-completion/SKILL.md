---
name: verification-before-completion
description: Verify completed work before reporting it as done. Use after making code, config, documentation, workflow, or UI changes; when the user asks whether something is fixed; when a dev server is started; or before claiming implementation, debugging, migration, or setup work is complete.
---

# Verification Before Completion

In Claude Code, first read `../tachikoma/references/claude-code.md` and map Cursor names with it.

Read and follow these skills from this skill's parent folder:

1. `../principle-prove-it-works/SKILL.md`: verify against the real artifact, not a proxy.
2. When the project has a `verify-<app>` skill, run it. When it has none and the change touches a running app, CLI, API, or infrastructure, run `../create-verification-skill/SKILL.md` first.
3. `../principle-explain-the-number/SKILL.md`: before you report a number you measured.

Do not say done, fixed, or working unless a check against the real artifact passed or the user accepted an unverified change. Report what ran and what it printed.
