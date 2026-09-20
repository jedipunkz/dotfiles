---
name: test-driven-development
description: Apply a focused red-green-refactor workflow for behavior changes and bug fixes. Use when the user asks for TDD, regression tests, test-first implementation, bug fixes with tests, or when a change has clear observable behavior that should be protected by tests.
---

# Test Driven Development

Use this skill when the safest path is to lock behavior down before implementation.

## Red-Green-Refactor

1. Identify the observable behavior to protect. Keep the test scope narrow enough to fail for the intended reason.
2. Find the repository's existing test style, framework, fixtures, and naming conventions before adding a test.
3. Write or update a focused failing test first. For a bug fix, the test should reproduce the bug. For a feature, it should encode the requested behavior.
4. Run the targeted test and confirm it fails for the expected reason. If it passes, improve the test before editing production code.
5. Implement the smallest production change that can make the test pass.
6. Run the targeted test again. Then run the nearest relevant broader test or lint command when the blast radius justifies it.
7. Refactor only after the behavior is green, keeping tests green after each meaningful cleanup.

## When Test-First Is Not Practical

If a test-first loop is not practical, state why before implementation. Good reasons include missing test infrastructure, changes limited to prompt text or documentation, a purely mechanical configuration change, or a test that would require unsafe external services.

When skipping a test, still choose the best available verification: static check, existing suite, manual reproducer, CLI smoke test, or diff review.

## Guardrails

- Do not add brittle tests that assert incidental implementation details.
- Prefer one focused regression over a broad snapshot unless the project already uses snapshots for this surface.
- Keep fixtures minimal and local to the test unless the repository has shared fixture patterns.
- Do not rewrite existing tests just to fit a new style.
