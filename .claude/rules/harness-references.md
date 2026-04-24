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

| ファイル | Event | Matcher | 役割 |
|---|---|---|---|
| `block-force-push.sh` | PreToolUse | Bash | `git push --force/-f` をブロック |
| `block-sensitive-access.sh` | PreToolUse | Read/Edit/Write/Bash/Grep | `.env`、秘密鍵、`.aws/.ssh` へのアクセスをブロック |
| `check-secrets.sh` | PreToolUse | Write/Edit | ハードコードされた認証情報パターンを検出 |
| `clean-git-lock.sh` | PreToolUse | Bash | stale な `.git/index.lock` を自動削除 |
| `guard-rm.sh` | PreToolUse | Bash | `rm -rf/-f/--recursive/--force` をブロック |
| `lint-check.sh` | PostToolUse | Write/Edit | `.sh/.bash` 修正後に `shellcheck` を自動実行 |
| `notify-ask.sh` | PreToolUse | AskUserQuestion/Bash | 承認が必要な操作で macOS 通知 + 音声アラート |
| `notify-done.sh` | Stop | — | タスク完了時に macOS 通知（成功: Glass / エラー: Basso） |

### Agents（`.claude/agents/`）

| エージェント | 役割 | 自動ディスパッチ条件 |
|---|---|---|
| `researcher` | 調査・Web検索・コード探索（読み取り専用） | 実装前に調査が必要なとき |
| `security-auditor` | hooks・settings のセキュリティ監査 | 新しい hook / permission rule 追加時 |
| `shell-reviewer` | シェルスクリプトのレビュー（golangci-lint相当） | `.sh/.bash` ファイル修正時 |
| `go-reviewer` | Go コードのレビュー（golangci-lint 実行含む） | `.go` ファイル修正時 |

### Skills（`.claude/skills/`）

| スキル | 役割 |
|---|---|
| `codex-review` | OpenAI Codex CLI によるコード・設定ファイルレビュー |
| `zellij-swarm` | Zellij pane + git worktree で複数 Claude を並列オーケストレート |

### Rules（`.claude/rules/`）

| ルール | 内容 |
|---|---|
| `conventional-commits.md` | commit prefix と branch 命名規約 |
| `git-commit.md` | commit 粒度・コマンド形式（heredoc禁止等） |
| `github-pr-template.md` | PR テンプレート（private=日本語 / public=英語） |
| `harness-references.md` | このファイル。ハーネス設定の参照資料 |

### Settings（`.claude/settings.json`）

- `permissions.defaultMode: "auto"` — デフォルト auto mode
- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` — Agent Teams 有効化
- `permissions.allow` — 安全な読み取り系 Bash コマンドを事前承認
- `permissions.deny` — 危険な操作（rm -rf, git push --force 等）を明示拒否
- `spinnerVerbs` — 攻殻機動隊ネタの日本語 spinner
- `language: "japanese"` — 応答言語
- LSP plugins: gopls / TypeScript / Rust Analyzer

---

## 参照記事（2025〜2026、実在確認済み）

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
