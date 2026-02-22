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

## ファイル構成

```
.claude/skills/zellij-swarm/
├── SKILL.md                    # このファイル
├── templates/
│   ├── CLAUDE.md.template      # エージェント用 CLAUDE.md テンプレート
│   └── claude-task.md.template # タスク定義テンプレート
└── scripts/
    ├── setup-worktrees.sh      # Step 2: worktree 作成
    ├── launch-panes.sh         # Step 4: Zellij ペイン起動
    ├── monitor.sh              # Step 5: ステータス監視
    ├── merge.sh                # Step 6: ブランチマージ
    ├── cleanup.sh              # Step 7 + 緊急クリーンアップ
    └── run-phase.sh            # フェーズ制御: monitor + merge + cleanup の一括実行
```

## 実行プロトコル

### Step 1: タスク分解

ユーザーのタスクを独立したサブタスクに分割する:

- 各サブタスクが **互いに依存しない** ことを確認
- 同一ファイルを複数エージェントが編集しないよう担当範囲を明確に分離
- エージェント数を決定 (推奨: 2〜4、最大: 6)

タスク間に依存関係がある場合は **フェーズ** に分割する:

- **同一フェーズ内**: 並列実行 (互いに独立)
- **フェーズ間**: 直列実行 (前フェーズ完了 → 次フェーズ開始)
- フェーズ図の例: `[a, b] → [c]` → Phase 1 で a,b を並列、Phase 2 で c を実行

分割できない場合 (同一ファイルへの書き込みが必要など) は swarm を使わず通常実行する。

### Step 2: セットアップ

`scripts/setup-worktrees.sh` を実行して worktree を作成する:

```bash
.claude/skills/zellij-swarm/scripts/setup-worktrees.sh agent-1 agent-2 agent-3
```

スクリプトは以下を行う:
- `REPO_ROOT` を自動取得
- 各エージェント用の worktree を `.gitworktree/<agent>` に作成
- `swarm/<agent>` ブランチを作成
- 既存 worktree がある場合はスキップ (冪等)

### Step 3: タスクファイル書き込み

各 worktree に Write tool で以下の **3 ファイル** を作成する。

**`.gitworktree/<agent>/CLAUDE.md`**:
`templates/CLAUDE.md.template` の内容を Read tool で読み取り、Write tool で書き込む。

**`.gitworktree/<agent>/.claude-task.md`**:
`templates/claude-task.md.template` を参考に、具体的なタスク内容を記述して Write tool で書き込む。

**`.gitworktree/<agent>/.swarm-start.sh`**:

```bash
#!/bin/bash
TASK=$(cat .claude-task.md)
claude --dangerously-skip-permissions "$TASK"
```

作成後、Bash で `chmod +x .gitworktree/<agent>/.swarm-start.sh` を実行。

### Step 4: Zellij ペイン起動

`scripts/launch-panes.sh` を実行してペインを起動する:

```bash
.claude/skills/zellij-swarm/scripts/launch-panes.sh agent-1 agent-2 agent-3
```

各ペインは `.swarm-start.sh` を経由して `.claude-task.md` の内容を初期プロンプトとして Claude に渡す。

### Step 5: 監視

`scripts/monitor.sh` を実行して全エージェントのステータスを監視する:

```bash
.claude/skills/zellij-swarm/scripts/monitor.sh agent-1 agent-2 agent-3
```

30 秒ごとにポーリングし、全エージェント完了時に自動終了する。

### Step 6: マージ

全エージェント完了後、`scripts/merge.sh` を実行してベースブランチにマージする:

```bash
.claude/skills/zellij-swarm/scripts/merge.sh agent-1 agent-2 agent-3
```

競合が発生した場合はエラーで停止するので、手動で解決してから再実行する。

### Step 7: クリーンアップ

`scripts/cleanup.sh` を実行して worktree とブランチを削除する:

```bash
.claude/skills/zellij-swarm/scripts/cleanup.sh agent-1 agent-2 agent-3
```

途中で中断した場合や worktree が壊れた場合は `--force` オプションを使用:

```bash
.claude/skills/zellij-swarm/scripts/cleanup.sh --force agent-1 agent-2 agent-3
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

## フェーズ制御 (並列 + 直列)

タスクに依存関係がある場合、`run-phase.sh` を使ってフェーズを直列に繋ぐ。

### run-phase.sh の役割

```
setup-worktrees.sh + (Write task files) + launch-panes.sh
  └─ run-phase.sh  ←  monitor.sh → merge.sh → cleanup.sh をまとめて実行
```

`run-phase.sh` はフェーズ内の全エージェント完了まで **ブロック** し、
完了後に merge → cleanup を自動実行する。

### フェーズ制御プロトコル

**Phase 1: agent-a, agent-b を並列実行**

```bash
# 1. Phase 1 の worktree セットアップ
.claude/skills/zellij-swarm/scripts/setup-worktrees.sh agent-a agent-b

# 2. タスクファイルを Write tool で書き込む (agent-a, agent-b それぞれ)

# 3. Phase 1 のペイン起動
.claude/skills/zellij-swarm/scripts/launch-panes.sh agent-a agent-b

# 4. Phase 1 完了まで待機 → 自動で merge + cleanup
.claude/skills/zellij-swarm/scripts/run-phase.sh agent-a agent-b
```

**Phase 2: agent-c を実行 (agent-a, agent-b のマージ済み状態をベースに)**

```bash
# 5. Phase 2 の worktree セットアップ (現在の HEAD = Phase 1 マージ済みが起点)
.claude/skills/zellij-swarm/scripts/setup-worktrees.sh agent-c

# 6. タスクファイルを Write tool で書き込む (agent-c)

# 7. Phase 2 のペイン起動
.claude/skills/zellij-swarm/scripts/launch-panes.sh agent-c

# 8. Phase 2 完了まで待機 → 自動で merge + cleanup
.claude/skills/zellij-swarm/scripts/run-phase.sh agent-c
```

### フェーズ間のブランチ関係

```
main ──┬── swarm/agent-a ──┐
       └── swarm/agent-b ──┴─ merge → main' ──── swarm/agent-c ─── merge → main''
```

`setup-worktrees.sh` は実行時の `HEAD` をベースに worktree を作成するため、
Phase 1 のマージ後に Phase 2 をセットアップすれば自動的に Phase 1 の結果が引き継がれる。

### エージェント名の命名例

フェーズが複数ある場合はエージェント名にフェーズを含めると管理しやすい:

```
phase1-frontend, phase1-backend  →  phase2-integration
```

## 注意事項

1. **独立性の確認が最重要**: 同一ファイルを複数エージェントが編集すると競合が発生する
2. **Zellij 内での実行が必須**: `$ZELLIJ` 環境変数が存在しない場合は動作しない
3. **監視は polling ベース**: 完了確認は手動または定期コマンド実行で行う
4. **エージェント間通信なし**: タスク設計の段階で独立性を保証すること
5. **`--dangerously-skip-permissions` 使用**: 子エージェントは確認なしで操作を実行する
6. **フェーズ間は必ず cleanup を完了させる**: `run-phase.sh` が cleanup まで行うため、次フェーズ開始前に worktree が残らない
