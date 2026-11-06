---
name: worktree-add
description: 現在いる git リポジトリの worktree を作成し、以後の作業をその worktree 内で行う。「worktree を作って」「worktree-add」「別の作業ツリーで作業したい」のような依頼で使う。引数で branch 名を指定でき、省略時は自動命名する。
---

# Worktree Add Skill

現在のリポジトリに git worktree を追加し、作業場所をそこへ移す。

## 引数

- `/worktree-add` — 名前を自動生成する（`wt-<YYYYMMDD-HHMMSS>`）。
- `/worktree-add <name>` — `<name>` を branch 名・ディレクトリ名に使う。

## 手順

1. リポジトリを確認する。git リポジトリでなければ中断して報告する。

```bash
git rev-parse --show-toplevel
```

2. 名前を決める。

- 引数があればそれを `<name>` とする。
- なければ `<name>` を `wt-$(date +%Y%m%d-%H%M%S)` とする。

3. worktree の配置先を決める。リポジトリの外側（親ディレクトリ）に置く。

```bash
repo_root=$(git rev-parse --show-toplevel)
repo_name=$(basename "$repo_root")
wt_path="$(dirname "$repo_root")/${repo_name}-worktrees/<name>"
```

4. worktree を作成する。現在の HEAD から新しい branch `<name>` を切る。

```bash
mkdir -p "$(dirname "$wt_path")"
git worktree add -b <name> "$wt_path"
```

branch `<name>` が既に存在する場合は `-b` を外して既存 branch を checkout する。
それでも失敗した場合（他の worktree が使用中など）はエラーをそのまま報告し、名前の変更を提案する。

5. 作業場所を worktree に移す。以後このセッションのコマンドはすべて `$wt_path` を作業ディレクトリとして実行する。

6. 完了報告には worktree の絶対パスと branch 名を含める。ユーザーが自分の shell で移動できるよう `cd <絶対パス>` を 1 行目に示す。

## 制約

- エージェントはユーザーの shell の cwd を変更できない。「移動」はエージェント自身の作業ディレクトリの切り替えを意味する。
- 既存の worktree・branch を削除しない。worktree の削除は `git worktree remove` を明示的に依頼されたときだけ行う。
- `<name>` は lowercase kebab-case に正規化する（スペースは `-` に置換）。
