---
name: github-publish
description: GitHub へローカル変更を公開する workflow。ユーザーが commit、branch push、PR 作成、publish を依頼した場合に、通常の git と gh pr create で安全に実行します。
---

# GitHub Publish Skill

ローカル変更を commit し、branch を GitHub に push して、Pull Request を作成するための workflow です。
目的は publish 操作を通常の Git/GitHub CLI 手順に揃え、Codex の permission 判定や shell の癖で失敗しにくくすることです。

## 使う場面

- ユーザーが「commit して」「push して」「PR 作成して」「publish して」と依頼した場合。
- 既に作成済みの PR branch に追加修正を反映する場合。
- 作業 branch を GitHub に上げ、PR URL まで返す必要がある場合。

## 原則

- commit と branch 作成は local `git` で行う。
- remote 反映は通常の `git push` で行う。
- PR 作成は `gh pr create` で行う。
- publish 目的で `gh api` を使って commit、tree、ref、PR を作らない。
- force push は実行しない。`git push --force` と `git push -f` は禁止。
- 既存のユーザー変更を勝手に stage、revert、削除しない。
- worktree に対象外の変更が混在している場合は、stage するファイルを明示的に限定する。

## 事前確認

1. GitHub CLI と認証状態を確認する。

```bash
gh --version
gh auth status
```

2. repository と作業状態を確認する。

```bash
git status -sb
git diff
git remote -v
gh repo view --json isPrivate,defaultBranchRef,nameWithOwner
```

3. current branch を確認し、既存 PR の有無を確認する。

```bash
git branch --show-current
gh pr list --head <branch> --state open
```

## Branch

- default branch 上で作業している場合は、`<prefix>/<short-description>` 形式の新規 branch を作る。
- 既に作業 branch 上なら、原則その branch を使う。
- 既存 PR に反映する場合は、その PR の head branch を使う。

```bash
git branch --show-current
git switch -c <branch>
```

## Commit

- `git add -A` は、worktree 全体が今回の scope だと確認できた場合だけ使う。
- 混在 worktree では対象ファイルを明示して stage する。
- commit message は project `AGENTS.md` の規則に従う。

```bash
git add <path> ...
git commit -m "<type>: <imperative subject>"
```

## Push

- push する branch 名は `git branch --show-current` で確認し、次のコマンドに明示的に書く。
- shell command substitution を使った `git push -u origin $(git branch --show-current)` は避ける。

```bash
git branch --show-current
git push -u origin <branch>
```

既存 remote branch へ追加 commit を反映する場合:

```bash
git push origin <branch>
```

## PR

- PR 作成前に repository の公開範囲を確認する。
- private repository の PR 本文は日本語、public repository の PR 本文は英語で書く。
- PR body は project `AGENTS.md` の構造に従う。

```bash
gh repo view --json isPrivate --jq '.isPrivate'
gh pr create --base <base> --head <branch> --title "<title>" --body "<body>"
```

本文構造:

```markdown
## Why

- <background>
- <related issue or N/A>

## What

- <change>

## Reference

- <reference or N/A>
```

## 失敗時

- `git add`、`git commit`、`git push` が sandbox、filesystem permission、認証、remote 設定の問題で失敗した場合は、`gh api` で代替せず、失敗したコマンドと原因を具体的に報告する。
- 現在の checkout の `.git` に書けないがユーザーが PR 反映の継続を求めている場合は、書き込み可能な一時 clone または worktree を作り、そこで通常の `git commit` と `git push` を実行する。
- HTTPS remote で認証に失敗し、`gh auth status` が Git operations protocol を `ssh` と示す場合は、remote URL を SSH に変更して通常の `git push` を再試行する。
- fork や cross-repository PR で `gh pr create` が base/head を推測できない場合は、`--base <branch>` と `--head <owner>:<branch>` を明示する。
