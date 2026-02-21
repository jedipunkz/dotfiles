---
name: zellij-swarm
description: Zellij の pane 管理を使って複数の Claude Code エージェントを並列起動し、タスクを分散実行するオーケストレータースキル。「swarm で」「並列エージェントで」「zellij swarm」「エージェントを N 個起動」「複数エージェントに分けて」などのリクエストがあった場合に使用します。
---

# Zellij Swarm Skill

Zellij の pane 管理と git worktree を組み合わせ、複数の Claude Code エージェントが
独立したタスクを並列実行するワークフローです。

## 前提条件

- Zellij セッション内で Claude を起動していること (`$ZELLIJ` 環境変数が存在)
- git リポジトリ内で実行していること
- `zellij` コマンドが PATH に存在すること

## 実行プロトコル

### Step 1: タスク分解

ユーザーのタスクを独立したサブタスクに分割する:

- 各サブタスクが **互いに依存しない** ことを確認
- 同一ファイルを複数エージェントが編集しないよう担当範囲を明確に分離
- エージェント数を決定 (推奨: 2〜4、最大: 6)

分割できない場合 (同一ファイルへの書き込みが必要など) は swarm を使わず通常実行する。

### Step 2: セットアップ

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
BRANCH_BASE=$(git rev-parse --abbrev-ref HEAD)
AGENTS=(agent-1 agent-2 agent-3)  # 実際のエージェント数に合わせて調整

for agent in "${AGENTS[@]}"; do
  git worktree add "$REPO_ROOT/.gitworktree/$agent" -b "swarm/$agent"
done
```

### Step 3: タスクファイル書き込み

各 worktree に Write tool で以下の 2 ファイルを作成する。

**`.gitworktree/<agent>/CLAUDE.md`**:

```markdown
# Swarm Agent Context

あなたは並列開発チームの一員です。`.claude-task.md` にあるタスクを
**すぐに開始**してください。完了したら `.swarm-status` に結果を書き込んでください。

## ルール

- Conventional Commits に従ってコミット (`feat:` / `fix:` / `refactor:` など)
- このディレクトリ外のファイルは編集しない
- タスク完了後に以下を実行:
  ```bash
  git add -A
  git commit -m "<prefix>: <summary>"
  echo "done|$(date -u +%Y-%m-%dT%H:%M:%SZ)|<1行サマリー>" > .swarm-status
  ```
- `.swarm-status` の書き込みが完了通知になる
```

**`.gitworktree/<agent>/.claude-task.md`**:

```markdown
## タスク: <具体的なタスク内容>

### 担当範囲

<編集対象のファイルパスや機能>

### 完了条件

- [ ] <チェックリスト項目 1>
- [ ] <チェックリスト項目 2>
```

### Step 4: Zellij ペイン起動

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
AGENTS=(agent-1 agent-2 agent-3)

for agent in "${AGENTS[@]}"; do
  zellij action new-pane \
    --name "swarm:$agent" \
    --cwd "$REPO_ROOT/.gitworktree/$agent" \
    -- claude --dangerously-skip-permissions
done
```

各ペインの Claude は起動時に CLAUDE.md を自動読み込みし、タスクを開始する。

### Step 5: 監視

全エージェントが完了するまで定期的にステータスを確認する:

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
AGENTS=(agent-1 agent-2 agent-3)

all_done=true
for agent in "${AGENTS[@]}"; do
  status_file="$REPO_ROOT/.gitworktree/$agent/.swarm-status"
  if [ -f "$status_file" ]; then
    echo "$agent: $(cat "$status_file")"
  else
    echo "$agent: in progress"
    git -C "$REPO_ROOT/.gitworktree/$agent" log --oneline -3 2>/dev/null || true
    all_done=false
  fi
done

echo "All done: $all_done"
```

未完了のエージェントがある場合は数分待って再確認する。

### Step 6: マージ

全エージェント完了後、ベースブランチにマージする:

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
AGENTS=(agent-1 agent-2 agent-3)

for agent in "${AGENTS[@]}"; do
  git -C "$REPO_ROOT" merge --no-ff "swarm/$agent" \
    -m "chore: merge swarm/$agent results"
done
```

競合が発生した場合は手動で解決してからマージを続行する。

### Step 7: クリーンアップ

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
AGENTS=(agent-1 agent-2 agent-3)

for agent in "${AGENTS[@]}"; do
  git -C "$REPO_ROOT" worktree remove ".gitworktree/$agent"
  git -C "$REPO_ROOT" branch -d "swarm/$agent"
done

# ディレクトリが残っている場合
rmdir "$REPO_ROOT/.gitworktree" 2>/dev/null || true
```

## ステータスファイル形式

`.swarm-status` の内容:

```
done|<ISO 8601 timestamp>|<1行サマリー>
```

例:

```
done|2026-02-21T10:30:00Z|add user authentication module
```

## ブランチ命名規則

```
swarm/agent-1
swarm/agent-2
swarm/agent-N
```

## 緊急クリーンアップ

途中で中断した場合や worktree が残った場合:

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)

# worktree 一覧確認
git -C "$REPO_ROOT" worktree list

# 残った worktree を強制削除
for agent in agent-1 agent-2 agent-3 agent-4 agent-5 agent-6; do
  git -C "$REPO_ROOT" worktree remove --force ".gitworktree/$agent" 2>/dev/null || true
  git -C "$REPO_ROOT" branch -D "swarm/$agent" 2>/dev/null || true
done

rmdir "$REPO_ROOT/.gitworktree" 2>/dev/null || true
```

## 注意事項

1. **独立性の確認が最重要**: 同一ファイルを複数エージェントが編集すると競合が発生する
2. **Zellij 内での実行が必須**: `$ZELLIJ` 環境変数が存在しない場合は動作しない
3. **監視は polling ベース**: 完了確認は手動または定期コマンド実行で行う
4. **エージェント間通信なし**: タスク設計の段階で独立性を保証すること
5. **`--dangerously-skip-permissions` 使用**: 子エージェントは確認なしで操作を実行する
