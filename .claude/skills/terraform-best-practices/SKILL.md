---
name: terraform-best-practices
description: Terraform best practices. Use when reading or editing any .tf, .tfvars, or .hcl file.
paths: ["**/*.tf", "**/*.tfvars", "**/*.hcl"]
disable-model-invocation: true
---

# Terraform best practices

Apply the **principle-boundary-discipline** and **principle-make-operations-idempotent** skills first. Modeled on the **typescript-best-practices** table.

| Rule | Summary |
|------|---------|
| Typed inputs | Every `variable` has a `type`, a `description`, and a `default` or `nullable = false`. Use `object({...})` over loose maps so a wrong key fails at plan time. |
| Validate at the boundary | `validation` blocks on inputs with a known valid set or shape. Inside the module, trust the input. No defensive `try()` or `coalesce()` that hides a bad value. |
| Assert invariants | `precondition` and `postcondition` in `lifecycle` for facts the module depends on, and `check` blocks for facts about the live system. The error message says what to change. |
| One source of truth | Derive values with `locals` or data sources. Never hand-sync the same list in two places. |
| Stable addresses | `for_each` over a map with stable keys. `count` only for a 0-or-1 toggle. An address change is a destroy and create. |
| Move, don't recreate | Renames and refactors use `moved` blocks, and removals that keep the real resource use `removed` blocks. Migrate every caller and drop the old address in the same change, per the **principle-migrate-callers-then-delete-legacy-apis** skill. |
| Converge on rerun | No `local-exec`, `null_resource`, or `terraform_data` that changes the world unless it is idempotent. A second `apply` with no changes must plan zero changes. |
| Narrow `lifecycle` | `prevent_destroy` on stateful resources. `ignore_changes` lists exact attributes, never `all`. |
| Pinned versions | `required_version`, `required_providers` with version constraints, versioned module sources, and a committed `.terraform.lock.hcl`. |
| Lint errors that teach | New project rules go into `tflint` or a CI policy check with a message that names the replacement, per the **principle-encode-lessons-in-structure** skill. |
| Real tests | `terraform test` with `.tftest.hcl` for module behavior. Use `command = plan` for logic and assertions on planned values, and `apply` runs only in a disposable account or workspace. |
| Verification | `terraform fmt -check`, `terraform validate`, and `tflint` are the floor, not the proof. The proof is a saved plan (`terraform plan -out` then `terraform show -json`) whose create, update, replace, and destroy set matches the intent, per the **principle-prove-it-works** skill. List every replace and destroy explicitly. |
