@AGENTS.md

# Claude Code 固有の指示

## ルール

Claude Code は `.claude/rules/` から詳細ルールも読み込む:

- `conventional-commits.md` - commit prefix と branch 命名の詳細。
- `git-commit.md` - commit の粒度、コマンド形式、メッセージのルール。
- `github-pr-template.md` - PR の形式。private は日本語、public は英語。
- `harness-references.md` - ハーネスエンジニアリングの参照資料とローカル設定のメモ。

## ハーネス構成（Claude Code 固有）

配置と管理方針の本体は `AGENTS.md` の「ハーネス構成の管理方針」にある。ここには Claude Code だけが読む要素を書く。

- `.claude/agents/`: subagent 定義。Claude Code が読む（Codex / Gemini が読むかは未確認）。
- `.claude/rules/`: Claude Code のみが読む詳細ルール。Codex にも効かせたいルールは `.claude/CLAUDE.md` か `.claude/skills/` に置く。
- `.claude/settings.json`: permissions / env / hooks / MCP / モデル設定。hook を足したときは `.codex/hooks.json` 側の登録も必要。

## subagent のディスパッチ方針

Agent Teams を有効化している（`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`）。
自作 subagent は `.claude/agents/` にある。proactive に使う。

### 自動ディスパッチする条件

| 条件 | 動作 |
|---|---|
| 状態を共有しない独立したパートが 3 つ以上ある | subagent を並列起動する |
| 実装前に調査が必要 | まず `researcher` に委譲し、その後実装する |
| シェルスクリプトを作成・修正した | `shell-reviewer` にレビューを委譲する |
| Go ファイルを作成・修正した | `go-reviewer` にレビューを委譲する |
| TypeScript ファイルを新規作成する必要がある | `typescript-writer` に作成を委譲する |
| TypeScript ファイルを作成・修正した | `typescript-reviewer` にレビューを委譲する |
| Python ファイルを新規作成する必要がある | `python-writer` に作成を委譲する |
| Python ファイルを作成・修正した | `python-reviewer` にレビューを委譲する |
| Dart ファイルを作成・修正した | `dart-reviewer` にレビューを委譲する |
| Proto ファイルを作成・修正した | `proto-reviewer` にレビューを委譲する |
| SQL ファイルか migration を作成・修正した | `sql-reviewer` にレビューを委譲する |
| Terraform ファイルを新規作成する必要がある | `terraform-writer` に作成を委譲する |
| Terraform ファイルを作成・修正した | `terraform-reviewer` にレビューを委譲する |
| hook か permission ルールを追加した | `security-auditor` に監査を委譲する |
| 2 分未満で終わる小さな変更 1 件 | 委譲せず自分で実行する |

### 並列ディスパッチ（タスクが独立していれば同時に起動する）

```
investigate X  +  implement Y  +  review Z
     ↓                ↓               ↓
 researcher      main thread     shell-reviewer
```

### 直列ディスパッチ（A の出力が B の入力になる場合）

```
researcher → findings → implement → shell-reviewer → verdict → commit
```

### ディスパッチしない場合

- 調査不要な単一ファイルの変更
- 実行の途中でユーザーの確認が必要なタスク
- 30 秒未満で終わるタスク
