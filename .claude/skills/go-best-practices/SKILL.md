---
name: go-best-practices
description: Go best practices. Use when reading or editing any .go file.
paths: ["**/*.go"]
disable-model-invocation: true
---

# Go best practices

Apply the **principle-type-system-discipline** and **principle-boundary-discipline** skills first. Modeled on the **typescript-best-practices** table.

| Rule | Summary |
|------|---------|
| Named types for semantic primitives | `type UserID string` and `type OrgID string` so the compiler rejects a swapped argument. Create them only through a constructor that validates, such as `ParseUserID(s string) (UserID, error)`. |
| Parse at the boundary | JSON, flags, env vars, config, and DB rows decode into a raw struct, then one parse function returns the domain type or an error. Inside, trust the type. No re-validation and no redundant nil checks. |
| Closed variants | Model a fixed set as `type State int` with `const` values, or a sealed interface with an unexported method. Every `switch` over it lists each value, enforced by the `exhaustive` linter, not a `default` that hides a new variant. |
| Make the zero value useful or impossible | A struct either works at its zero value, or its fields are unexported and a `New` constructor is the only way to build it. |
| No `any` in signatures | `any` and `interface{}` are external data that has not been parsed. Use generics or a concrete type. |
| Checked type assertions only | `v, ok := x.(T)`. A bare `x.(T)` panics. `errors.As` for error types. |
| Errors callers branch on | Sentinel `var ErrNotFound = errors.New(...)` or a typed error, wrapped with `%w`. Callers use `errors.Is` or `errors.As`, never the message string. Tests assert the same way. |
| Accept interfaces at the consumer | Define the interface where it is used, with the methods that caller needs. No interface with one implementation and no consumer. |
| `internal/` for boundaries | Code that must not be imported across a boundary lives under `internal/`, so a wrong import fails to compile instead of failing review. |
| `context.Context` first | Every function that does I/O or blocks takes `ctx` as the first parameter. Never store it in a struct. |
| Goroutines have an owner | Every goroutine has an exit path tied to a `ctx` or a closed channel, and its owner waits for it (`errgroup`, `sync.WaitGroup`). |
| Real tests | Table tests over the public API with `t.Run`. `httptest.Server` and a real temp dir (`t.TempDir()`) over mocks. `go test -race` for concurrent code. |
| Lint errors that teach | New project rules go into `golangci-lint` (`forbidigo`, `depguard`, `exhaustive`) with a message that names the replacement, per the **principle-encode-lessons-in-structure** skill. |
| Verification | `go build ./...`, `go vet ./...`, `golangci-lint run`, and `go test -race ./...` are the floor, not the proof. Prove behavior by running the binary or server the way a user would, per the **principle-prove-it-works** skill. |
