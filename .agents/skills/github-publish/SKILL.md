---
name: github-publish
description: GitHub へ現在の変更を publish するため、branch 作成、commit、通常 push、gh pr create を安定して実行する Codex 用 workflow。ユーザーが「push」「PR 作成」「branch を GitHub に上げる」「publish」などを依頼した場合に使います。
---

# GitHub Publish Skill

ローカル変更を GitHub に push し、Pull Request を作成するための workflow です。
この skill は GitHub への通常 push と `gh pr create` を安定して実行することを目的にします。
GitHub Git Data API で commit や branch を直接作る workflow ではありません。

## 前提

- `gh` コマンドが PATH に存在すること。
- `gh auth status` が成功すること。
- GitHub remote が設定された git repository 内で実行していること。
- scope が混在している場合は、stage するファイルをユーザーに確認すること。

## 安全ルール

- force push は実行しない。`git push --force` と `git push -f` は禁止。
- commit と branch 作成は local `git` で行い、remote 反映は `git push` で行う。
- publish 目的で `gh api` を使って commit、tree、ref、PR を作らない。
- `git add -A` は、worktree 全体が対象だと確認できた場合だけ使う。
- 既存のユーザー変更を勝手に戻さない。
- PR 作成前に `gh repo view --json isPrivate --jq '.isPrivate'` で公開範囲を確認する。
- private repository の PR 本文は日本語、public repository の PR 本文は英語で書く。

## Workflow

1. GitHub CLI と認証状態を確認する。

```bash
gh --version
gh auth status
```

2. 作業内容と remote を確認する。

```bash
git status -sb
git diff
git remote -v
gh repo view --json isPrivate --jq '.isPrivate'
```

3. branch 方針を決める。

- `main`、`master`、remote default branch 上の場合は、`<prefix>/<short-description>` の新規 branch を作る。
- 既に作業 branch 上なら、原則その branch を使う。
- 新規 branch 作成は `git switch -c <branch>` を使う。

4. 意図したファイルだけを stage し、commit する。

```bash
git add <path> ...
git commit -m "<type>: <imperative subject>"
```

5. push する branch 名を別コマンドで取得する。

コマンド置換は permission prefix 判定を外しやすいため使わない。

```bash
git branch --show-current
```

6. 取得した branch 名を明示して通常 push する。

```bash
git push -u origin <branch>
```

7. PR を作成する。

PR 本文は repository の公開範囲に合わせ、project `AGENTS.md` の構造を使う。

```bash
gh pr create --title "<title>" --body "<body>"
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

## 詰まった時の扱い

- local `git add`、`git commit`、`git push` が sandbox、filesystem permission、認証、remote 設定の問題で失敗した場合は、`gh api` で代替実装せずに停止し、失敗したコマンドと原因を具体的に伝える。
- `git push -u origin <branch>` が権限や認証で失敗した場合は、`gh auth status` と remote URL を確認し、認証問題としてユーザーに具体的に伝える。
- PR が既に存在する可能性がある場合は、`gh pr list --head <branch>` で確認してから新規作成する。
- fork や cross-repository PR で `gh pr create` が base/head を推測できない場合は、`--base <branch>` と `--head <owner>:<branch>` を明示する。
