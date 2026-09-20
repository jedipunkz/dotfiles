---
name: verification-before-completion
description: Verify completed work before reporting it as done. Use after making code, config, documentation, workflow, or UI changes; when the user asks whether something is fixed; when a dev server is started; or before claiming implementation, debugging, migration, or setup work is complete.
---

# Verification Before Completion

Use this skill as a final gate. The goal is to verify the user's actual requested outcome, not merely that files changed.

## Verification Plan

1. Restate the behavior or artifact that must now be true.
2. Choose the narrowest reliable verification that exercises that behavior.
3. Run the targeted check. For code, prefer the nearest test. For config or scripts, prefer parse, lint, dry-run, or smoke commands. For UI, verify the real page or flow when a dev server is required.
4. Run broader checks only when the change touches shared behavior, build configuration, generated artifacts, or user-facing workflows.
5. Inspect the relevant diff after tests so the final answer matches the actual changes.

## Full-Story Checks

For user-facing app work, verify the complete path that matters:

- Browser or client renders the changed surface.
- API or command receives the intended input.
- Data layer or filesystem side effects are correct when applicable.
- The visible response or output matches the request.

For non-app work, verify the equivalent path: input, command or workflow, resulting artifact, and observable output.

## Reporting

Always report what was run and what passed. If a check could not be run, say exactly why and name the next best check.

Do not say "done", "fixed", or "working" unless at least one meaningful verification passed or the user explicitly accepted an unverified change.
