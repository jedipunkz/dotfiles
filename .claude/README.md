# `.claude/` — Claude Code Harness

Claude Code の設定一式。`setup.sh` が `$HOME/.claude` へシンボリックリンクする。

| パス | 役割 |
|---|---|
| `settings.json` | 権限・env・hooks・MCP・モデル設定 |
| `settings.local.json` | このマシン固有の上書き(VCS 管理外) |
| `rules/` | commit / PR / branch などの詳細ルール |
| `hooks/` | ツール実行前後・完了時に走るスクリプト |
| `agents/` | サブエージェント定義 |
| `skills/` | `/name` で起動するワークフロー |

---

## MCP サーバ

### 確認

```bash
claude mcp list        # 登録済みサーバと接続状態
claude mcp get <name>  # 個別の詳細
```

### 現在登録済みのサーバ(再登録コマンド)

すべて user スコープ。`alphavantage` の apikey と `edinetdb` の Bearer トークンは実値に置き換える。API キー取得先: [Alpha Vantage](https://www.alphavantage.co/support/#api-key) / [EDINET DB](https://edinetdb.jp/developers)。

```bash
# 株価・財務 (apikey は URL クエリ)
claude mcp add --transport http alphavantage "https://mcp.alphavantage.co/mcp?apikey=YOUR_KEY" --scope user

# 株価 (OAuth: 追加後に /mcp で認証)
claude mcp add --transport http twelvedata https://mcp.twelvedata.com/mcp --scope user

# 日本企業の財務 (Bearer 認証)
claude mcp add --transport http edinetdb https://edinetdb.jp/mcp --header "Authorization: Bearer YOUR_TOKEN" --scope user

# コードレビュー (stdio, このリポジトリの settings.json に checked-in 済み)
claude mcp add --transport stdio codex -- codex mcp-server
```

`claude.ai Gmail / Calendar / Drive` と `plugin:vercel` は connector / plugin 由来のため `claude mcp add` の対象外。

### 補足

- ツールを事前承認するには `settings.json` の `permissions.allow` に `mcp__<name>__*` を追加。
- `alphavantage` はメタツール方式(`TOOL_LIST → TOOL_GET → TOOL_CALL`)。詳細は `skills/finance-mcp/SKILL.md`。

公式: https://code.claude.com/docs/en/mcp
