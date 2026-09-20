---
name: systematic-debugging
description: Reproduce and debug failures through an evidence-first root-cause workflow. Use when tests fail, a bug is reported, behavior is flaky, an error message needs investigation, or the user asks to debug, diagnose, investigate, or fix a failure.
---

# Systematic Debugging

Use this skill to avoid speculative fixes. The goal is to prove the failure mode, isolate the root cause, make the smallest coherent change, and verify that the specific failure is gone.

## Workflow

1. Capture the symptom exactly: command, input, expected behavior, actual behavior, error text, affected file, environment, and relevant dates or versions.
2. Reproduce the failure before editing whenever feasible. Prefer the smallest command or interaction that shows the problem.
3. Inspect the code path and data path that produce the symptom. Follow actual callers, configuration, state, and boundary conditions.
4. Form one concrete hypothesis at a time. State what evidence would confirm or reject it, then gather that evidence.
5. Make the smallest fix that addresses the confirmed root cause. Avoid broad refactors, unrelated cleanup, and changing behavior that has not been implicated.
6. Add or update a regression check when the codebase has a practical test surface.
7. Re-run the reproducer and the relevant broader checks. If the original failure was flaky, run enough repetitions to make the result meaningful.

## Evidence Rules

- Do not claim root cause from a plausible explanation alone.
- Do not edit first and debug afterward unless reproducing would be destructive, impossible, or unreasonably expensive.
- If the failure cannot be reproduced, document what was tried and reduce uncertainty with logs, static inspection, or targeted instrumentation.
- If a change fixes the symptom but the cause is still unclear, say so and keep investigating unless the user explicitly wants a tactical workaround.

## Final Report

Report:

- Root cause, with the file or behavior that proved it.
- Change made.
- Verification commands and results.
- Any residual risk, skipped checks, or assumptions.
