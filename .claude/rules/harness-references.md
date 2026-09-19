---
paths:
  - "**/.claude/**"
  - "**/.codex/**"
  - "**/.gemini/**"
  - "**/.agents/**"
  - "**/CLAUDE.md"
  - "**/AGENTS.md"
---

# Harness Engineering — Reference

このファイルはハーネスエンジニアリングの概念定義・現在の設定構成・参照記事をまとめた資料。
Claude Code がセッション開始時に自動ロードし、設定改善・拡張作業の参照として使用する。

## ハーネスエンジニアリングとは

モデル（LLM）自体ではなく、**モデルの外側で品質・安全性・自律性を実現する設定・制約・反応ループの総称**。

```
┌─────────────────────────────────────────┐
│  UI 層          CLI / IDE / Web          │
├─────────────────────────────────────────┤
│  Harness 層     Hooks / Rules / Agents  │
│                 Skills / Permissions    │
│                 CLAUDE.md / MCP         │
├─────────────────────────────────────────┤
│  Model 層       Claude (LLM)            │
└─────────────────────────────────────────┘
```

モデルの能力はハーネスで引き出す。パフォーマンス問題の多くはモデルではなく設定不足が原因。

---

## このdotfilesの現在のハーネス構成

### Hooks（`.claude/hooks/`）

hooks は `settings.json` の `hooks` キーにのみ定義する。専用の `hooks.json` は plugin 用であり、
user / project スコープには存在しない（[Hooks reference](https://code.claude.com/docs/en/hooks)、2026-09 確認）。

| ファイル | Event | Matcher | 役割 |
|---|---|---|---|
| `block-force-push.sh` | PreToolUse | Bash | `git push --force/-f` をブロック |
| `block-sensitive-access.sh` | PreToolUse | Read/Edit/Write/Bash/Grep | `.env`、秘密鍵、`.aws/.ssh` へのアクセスをブロック |
| `check-secrets.sh` | PreToolUse | Write/Edit | ハードコードされた認証情報パターンを検出 |
| `clean-git-lock.sh` | PreToolUse | Bash | stale な `.git/index.lock` を自動削除 |
| `guard-rm.sh` | PreToolUse | Bash | `rm -rf/-f/--recursive/--force` をブロック |
| `lint-check.sh` | PostToolUse | Write/Edit | `.sh/.bash` 修正後に `shellcheck` を自動実行 |
| `herdr-agent-state.sh` | SessionStart / SessionEnd / UserPromptSubmit / PreToolUse / PermissionRequest / Stop | `*` | herdr にエージェント状態（idle/working/blocked/release）を通知 |
| `log-event.sh` | CwdChanged / SubagentStart / WorktreeCreate / WorktreeRemove | `*` | イベントログ記録 |
| `notify-done.sh` | Stop | — | タスク完了時に macOS 通知（成功: Glass / エラー: Basso） |
| `notify-ask.sh` | 未登録 | — | 承認要求時の macOS 通知。`settings.json` にも `.codex/hooks.json` にも登録されていない死んだファイル。使うなら `PermissionRequest` に登録する |

2026-09 時点で利用可能なイベントは 33 種。未使用で有用な候補: `PermissionDenied`（classifier の
denial を `tool_input` 付きで捕捉）、`PostToolUseFailure`、`StopFailure`、`PreCompact` / `PostCompact`、
`SubagentStop`、`TeammateIdle`。

### Agents（`.claude/agents/`）

| エージェント | 役割 | 自動ディスパッチ条件 |
|---|---|---|
| `architect` | 設計・リポジトリ構造・大きめの計画判断（読み取り専用） | 複数ファイル/モジュールに跨る変更の設計時 |
| `debugger` | エラー・失敗コマンド・hook 不調の原因調査と修正 | テスト/ビルド/スクリプトの失敗時 |
| `docs-writer` | 既存コード・設定からのドキュメント作成・更新 | README / 運用ドキュメントの更新が必要なとき |
| `researcher` | 調査・Web検索・コード探索（読み取り専用） | 実装前に調査が必要なとき |
| `security-auditor` | hooks・settings のセキュリティ監査 | 新しい hook / permission rule 追加時 |
| `shell-reviewer` | シェルスクリプトのレビュー（golangci-lint相当） | `.sh/.bash` ファイル修正時 |
| `go-writer` | Go コードの作成・修正 | `.go` ファイルの新規作成・機能追加時 |
| `go-reviewer` | Go コードのレビュー（golangci-lint 実行含む） | `.go` ファイル修正時 |
| `typescript-writer` | TypeScript/React コードの作成・修正 | `.ts/.tsx` ファイルの新規作成・機能追加時 |
| `typescript-reviewer` | TypeScript/React コードのレビュー（tsc/ESLint 実行含む） | `.ts/.tsx` ファイル修正時 |
| `python-writer` | Python コードの作成・修正 | `.py` ファイルの新規作成・機能追加時 |
| `python-reviewer` | Python コードのレビュー（ruff/mypy 実行含む） | `.py` ファイル修正時 |
| `dart-reviewer` | Dart/Flutter コードのレビュー（dart analyze 実行含む） | `.dart` ファイル修正時 |
| `proto-reviewer` | Protobuf 定義のレビュー（buf lint/breaking 実行含む） | `.proto` ファイル修正時 |
| `sql-reviewer` | SQL・migration のレビュー（安全性・性能重点） | `.sql` ファイル修正時 |
| `terraform-writer` | Terraform コードの作成・修正 | `.tf/.tfvars/.hcl` の新規作成・リソース追加時 |
| `terraform-reviewer` | Terraform コードのレビュー（IAM・network・secrets 重点） | `.tf/.tfvars/.hcl` ファイル修正時 |
| `test-runner` | 変更に対する最小限のテスト実行・検証 | コード/スクリプト変更後の検証が必要なとき |

### Skills（`.claude/skills/`）

| スキル | 役割 |
|---|---|
| `codex-review` | OpenAI Codex CLI によるコード・設定ファイルレビュー |
| `finance-mcp` | 株価・為替・暗号資産・財務データを MCP 経由で取得・分析 |
| `zellij-swarm` | Zellij pane + git worktree で複数 Claude を並列オーケストレート |

Codex 側の skill は `.agents/skills/`（`~/.agents/skills` へリンク）に置き、`$<name>` で呼び出す。
`codex-review` / `finance-mcp` / `zellij-swarm` は両方に存在し、`github-publish` /
`systematic-debugging` / `test-driven-development` / `verification-before-completion` /
`web-research` は Codex 側のみ。

### Rules（`.claude/rules/`）

共通ルール本体は `.claude/CLAUDE.md` に単一ソースで置く。`.codex/AGENTS.md` はそのファイルへの
symlink で、Claude Code と Codex が同じ実体を読む。`.claude/rules/` は Claude Code のみが読むため、
Codex にも必要なルールは `.claude/CLAUDE.md` 側か `.agents/skills/` に置く。

| ルール | 内容 |
|---|---|
| `conventional-commits.md` | commit prefix と branch 命名規約 |
| `git-commit.md` | commit 粒度・コマンド形式（heredoc禁止等） |
| `github-pr-template.md` | PR テンプレート（private=日本語 / public=英語） |
| `harness-references.md` | このファイル。ハーネス設定の参照資料 |

### Settings（`.claude/settings.json`）

`~/.claude/settings.json` はこのファイルへの symlink。auto mode classifier は `autoMode` を
user settings と managed settings からのみ読み、project settings からは読まない。

- `permissions.defaultMode: "auto"` — auto mode。2026-08-14 以降 Pro/Max/Team の既定値
- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` — Agent Teams 有効化
- `permissions.allow` — 事前承認。auto mode では narrow な Bash allow rule は classifier を
  スキップするため、書き込み可能なコマンド（`gh api` 等）を入れると classifier の検査を素通りする
- `permissions.deny` — classifier より前に評価される、上書き不可の最終防壁
- `permissions.ask` — classifier より前に評価され必ずプロンプトを出す。push / PR 作成の
  human checkpoint はここで作る
- `autoMode.soft_deny` / `hard_deny` / `allow` / `environment` — classifier の追加ルール
- `spinnerVerbs` — 攻殻機動隊ネタの日本語 spinner
- `language: "japanese"` — 応答言語
- LSP plugins: gopls / TypeScript / Rust Analyzer / Swift

`autoMode` の落とし穴: `soft_deny` / `hard_deny` / `allow` / `environment` のいずれかを
`"$defaults"` を含めずに設定すると、そのセクションの組み込みルールが全て消える。組み込みは
soft_deny 69 件・hard_deny 1 件（データ持ち出し禁止）。自前ルールを足すときは必ず配列の先頭に
`"$defaults"` を置く。

検証コマンド:

```bash
claude auto-mode defaults   # 組み込みルール
claude auto-mode config     # 実効ルール（設定適用後）
claude auto-mode critique   # 自前ルールへの AI レビュー
```

---

## 参照記事（2025〜2026、実在確認済み）

### 公式ドキュメント（2026-09-19 に一次情報で再確認）

- **Hooks reference** — イベント 33 種。hooks の定義場所は settings.json のみで、`hooks/hooks.json` は plugin 専用。
  https://code.claude.com/docs/en/hooks
- **Configure auto mode** — `autoMode` の `environment` / `allow` / `soft_deny` / `hard_deny`、`"$defaults"` の挙動、`claude auto-mode` サブコマンド。
  https://code.claude.com/docs/en/auto-mode-config
- **Choose a permission mode** — classifier の評価順、`permissions.ask` による human checkpoint。
  https://code.claude.com/docs/en/permission-modes
- **Create custom subagents** — frontmatter 全キー（`model` / `memory` / `disallowedTools` / `isolation` / `effort` / `maxTurns` / `skills` / `omitClaudeMd` ほか）。`omitClaudeMd` は v2.1.271 以降、`experimental.cacheTtl` は v2.1.248 以降。並行 20・深度 3、セッション総数の上限なし。
  https://code.claude.com/docs/en/sub-agents
- **All settings** — 廃止キー: `disableArtifact` / `includeCoAuthoredBy` / `keybindingFlavor` / `permissionExplainerEnabled`（v2.1.257 で削除）。
  https://code.claude.com/docs/en/settings-reference

### 概念・設計理論

- **Skill Issue: Harness Engineering for Coding Agents** (2026-03-12)
  HumanLayer. AIコーディングエージェントのパフォーマンス問題は設定不足が原因。CLAUDE.md・MCP・Hooks・Subagents による改善手法。
  https://www.humanlayer.dev/blog/skill-issue-harness-engineering-for-coding-agents

- **12 Agentic Harness Patterns from Claude Code** (2026-04-05)
  Generative Programmer. Memory / Workflow / Tools / Automation の4カテゴリ12パターン。Progressive Tool Expansion など実装パターン集。
  https://generativeprogrammer.com/p/12-agentic-harness-patterns-from

- **How coding agents work** (2026-03-16)
  Simon Willison. チャットテンプレート・Tool Calling・System Prompts・Reasoning など基本メカニズムの解説。
  https://simonwillison.net/guides/agentic-engineering-patterns/how-coding-agents-work/

- **Harness design for long-running application development** (2026-03-24)
  Anthropic Engineering. 生成エージェントと評価エージェントの2層構造でビデオゲーム開発の品質を大幅向上。
  https://www.anthropic.com/engineering/harness-design-long-running-apps

### Hooks 実装

- **Claude Code Hooks: A Practical Guide to Workflow Automation** (2026-01-19)
  DataCamp. 10種類のイベントタイプ、PreToolUse/PostToolUse の実践的な設定方法。
  https://www.datacamp.com/tutorial/claude-code-hooks

- **Claude Code Hooks: All 12 Events with Examples** (2026-02-14)
  PixelMojo. 12イベント全解説、Command/Prompt/Agent の3ハンドラ型、ドキュメント標準化を Hooks で強制するパターン。
  https://www.pixelmojo.io/blogs/claude-code-hooks-production-quality-ci-cd-patterns

### Agents / Subagents

- **Claude Code Agent Harness: Architecture Breakdown** (2026-04-06)
  WaveSpeed AI. Sonnet 4.6 分類器による背景許可システム、セッション状態追跡、MCP 統合の実装パターン。
  https://wavespeed.ai/blog/posts/claude-code-agent-harness-architecture/

- **Collaborating with agents teams in Claude Code** (2026-03-12)
  Medium. Claude Code Agent Teams による並列開発ワークフロー、tmux・GitHub CLI・git worktrees との統合例。
  https://heeki.medium.com/collaborating-with-agents-teams-in-claude-code-f64a465f3c11

### CLAUDE.md ベストプラクティス

- **Writing a good CLAUDE.md** (2025-11-25)
  HumanLayer. CLAUDE.md は150-200行の簡潔性重視、Universal 情報のみ記載、Progressive Disclosure で構造化。
  https://www.humanlayer.dev/blog/writing-a-good-claude-md

- **Decoding the Configuration of AI Coding Agents** (2025-11-12)
  arXiv. GitHub から収集した328個の CLAUDE.md ファイル分析。アーキテクチャ仕様が72.6%で最重要項目。
  https://arxiv.org/html/2511.09268v1

### アーキテクチャ分析

- **The Claude Code Leak: 10 Agentic AI Harness Patterns** (2026-04-01)
  Ken Huang. Claude Code アーキテクチャから発見した10パターン、モデル層・ハーネス層・UI層の3層分離設計。
  https://kenhuangus.substack.com/p/the-claude-code-leak-10-agentic-ai

- **Inside the Agent Harness: How Codex and Claude Code Actually Work** (2026-04-22)
  Medium. エージェントループ実装詳細、レイヤード実行命令・会話履歴・動的ツール定義・トークン管理。
  https://medium.com/jonathans-musings/inside-the-agent-harness-how-codex-and-claude-code-actually-work-63593e26c176

- **Building a C compiler with a team of parallel Claudes** (2026-02-05)
  Anthropic Engineering. 16並列 Claude で100万行の Rust C コンパイラ開発、Linux 6.9 カーネルビルド成功。
  https://www.anthropic.com/engineering/building-c-compiler

### 公式ドキュメント

- **Best Practices for Claude Code**
  Anthropic 公式。コンテキスト管理・検証駆動・Explore-Plan-Code フロー、環境設定（CLAUDE.md/MCP/Hooks/Skills）。
  https://code.claude.com/docs/en/best-practices

- **Automate workflows with hooks**
  Anthropic 公式。Hooks 設定・イベント型・Command/Prompt/Agent ハンドラ、PreToolUse/PostToolUse 実践例。
  https://code.claude.com/docs/en/hooks-guide
