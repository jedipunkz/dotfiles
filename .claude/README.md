# MCP 登録コマンド

## EDINET DB（日本上場企業の財務・有報データ）

API キー取得: <https://edinetdb.jp/developers>

```bash
# local スコープ（このプロジェクトのみ）
claude mcp add -t http edinetdb https://edinetdb.jp/mcp --header "Authorization: Bearer YOUR_API_KEY"

# user スコープ（全プロジェクト共通。推奨）
claude mcp add -s user -t http edinetdb https://edinetdb.jp/mcp --header "Authorization: Bearer YOUR_API_KEY"
```

## Alpha Vantage（米国・グローバル株の価格 / テクニカル / 財務）

API キー取得: <https://www.alphavantage.co/support/#api-key>

```bash
# local スコープ（このプロジェクトのみ）
claude mcp add -t http alphavantage "https://mcp.alphavantage.co/mcp?apikey=YOUR_API_KEY"

# user スコープ（全プロジェクト共通。推奨）
claude mcp add -s user -t http alphavantage "https://mcp.alphavantage.co/mcp?apikey=YOUR_API_KEY"
```
