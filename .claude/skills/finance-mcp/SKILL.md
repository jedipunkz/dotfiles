---
name: finance-mcp
description: 株価・為替・暗号資産・財務データを MCP サーバ (alphavantage / twelvedata / edinetdb) 経由で取得・分析します。「株価を調べて」「銘柄の推移を」「為替レート」「企業の財務を」「決算」「ASCII グラフにして」「米国株 / 日本株を調査」などのリクエストがあった場合に使用します。
---

# Finance MCP Skill

金融・市場データ系の 3 つの MCP サーバを使い分けて、株価・為替・暗号資産・経済指標・企業財務を取得・分析するスキル。

## 対象 MCP サーバと使い分け

| MCP | 主な守備範囲 | 認証 | ツール方式 |
|---|---|---|---|
| `alphavantage` | 米国・グローバル株式の OHLCV、テクニカル指標、オプション、為替、暗号資産、コモディティ、米経済指標、企業財務 | API キー (設定済み) | メタツール方式 |
| `twelvedata` | グローバル株式・為替・暗号資産・ETF のリアルタイム/時系列、テクニカル指標 | OAuth (`authenticate` → `complete_authentication`) | 認証後にツール提供 |
| `edinetdb` | 日本上場企業 (~3,800 社) の財務諸表・有報・セグメント・株主・役員報酬など EDINET ベースの詳細データ | Bearer API キー | 個別ツール |

### 選択指針

- **米国株・グローバル株の価格/チャート/テクニカル** → `alphavantage`(まず第一候補)。
- **alphavantage で取れない/レート制限に当たった場合の代替価格ソース** → `twelvedata`。
- **日本企業の財務・有報・株主構成など定性/定量の詳細** → `edinetdb`。価格時系列ではなく企業ファンダメンタルズ向け。

## alphavantage の使い方(メタツール方式)

直接エンドポイント名のツールは呼べない。必ず 3 段階で呼ぶ:

```
TOOL_LIST                       # 利用可能ツール名と説明の一覧(パラメータは含まない)
  ↓
TOOL_GET(tool_name)             # 当該ツールの inputSchema(必須引数・型)を取得
  ↓
TOOL_CALL(tool_name, arguments) # 実行。arguments は TOOL_GET のスキーマに一致させる
```

`TOOL_GET` を飛ばして `TOOL_CALL` すると必須引数が分からず失敗する。

### よく使うツール

- 価格時系列: `TIME_SERIES_DAILY` / `TIME_SERIES_INTRADAY` / `TIME_SERIES_WEEKLY` / `_MONTHLY`(`_ADJUSTED` 版あり)
- 最新気配: `GLOBAL_QUOTE` / `REALTIME_BULK_QUOTES`(最大 100 銘柄)
- 銘柄検索: `SYMBOL_SEARCH` / `SEARCH`(自然言語)
- 市場状態: `MARKET_STATUS`
- テクニカル: `SMA` / `EMA` / `RSI` / `MACD` / `BBANDS` / `ATR` / `VWAP` ほか多数
- 企業財務: `COMPANY_OVERVIEW` / `INCOME_STATEMENT` / `BALANCE_SHEET` / `CASH_FLOW` / `EARNINGS`
- 為替/暗号資産: `FX_DAILY` / `CURRENCY_EXCHANGE_RATE` / `CRYPTO_INTRADAY` / `DIGITAL_CURRENCY_DAILY`
- 指数: `INDEX_DATA`(`INDEX_CATALOG` で対応シンボル一覧)
- イベント: `IPO_CALENDAR` / `EARNINGS_CALENDAR` / `NEWS_SENTIMENT` / `TOP_GAINERS_LOSERS`

### 呼び出し例

```
TIME_SERIES_DAILY(symbol="IBM", outputsize="compact", datatype="csv", return_full_data=true)
```

- `outputsize="compact"` は直近 100 点。返り値が少ない場合、その銘柄の取引履歴自体が短い(新規上場など)可能性を疑う。
- `return_full_data=true` を推奨(プレビュー切り詰めを回避)。
- `datatype="csv"` はそのまま表/グラフ化しやすい。

### 無料枠の制約(重要)

- `outputsize="full"`(20 年超の全履歴)は **premium 限定**。無料枠では `compact`(最大 100 点)まで。
- レート制限あり(1 分/1 日あたりの呼び出し回数)。429 や `Information` メッセージが返ったら間隔を空ける、または `twelvedata` に切り替える。

## twelvedata の使い方

OAuth 認証が必要。未認証時はまず以下を実行:

```
authenticate            # 認証 URL / フローを開始
  ↓ (ユーザーがブラウザで承認)
complete_authentication # 認証を確定
```

認証完了後にデータ取得ツールが利用可能になる。具体的なツール名・引数は認証後に提供されるスキーマで確認する(未認証の段階では一覧は不明 = 要確認)。主用途は alphavantage の代替価格ソース。

## edinetdb の使い方

日本企業のファンダメンタルズ向け。Bearer API キー認証(設定済み)。サードパーティ (Cabocia Inc.) 提供で金融庁・EDINET 非公式。**情報提供目的であり投資助言ではない**。

典型的な起点と流れ:

1. `search_companies` / `search_corporate_master` — 社名・証券コードで企業を特定(以降の API に渡す ID を得る)。
2. 用途別に取得:
   - 財務: `get_financials` / `get_earnings` / `get_segments` / `get_detailed_expenses`
   - 企業概要: `get_company` / `get_corporate_profile` / `get_company_history`
   - 株主・ガバナンス: `get_major_shareholders` / `get_shareholder_categories` / `get_directors` / `get_director_compensation` / `get_cross_shareholdings`
   - 有報本文: `get_text_blocks` / `search_ir_sections` / `get_ir_documents`
   - スクリーニング: `screen_companies` / `get_ranking` / `get_industry_benchmark`
3. 継続監視: `add_to_watchlist` / `get_watchlist` / `get_earnings_calendar`

## ワークフロー例: 株価推移を ASCII グラフ化

1. `alphavantage` の `TIME_SERIES_DAILY`(`compact`, `csv`, `return_full_data=true`)で終値・出来高を取得。
2. 終値の min/max からスケールを決め、ASCII 折れ線/バーで推移を描く。日中レンジ(高値–安値)を併記すると変動の大きさが伝わる。
3. 急騰/急落・出来高の偏り・上場直後かどうかなど、要点を散文で添える。
4. データソース・期間・制約(無料枠で取れた範囲)を明記し、投資助言ではない旨を添える。

## 注意事項

1. 取得データは**情報提供目的**であり投資助言ではない。
2. 銘柄シンボルが曖昧なときは `SYMBOL_SEARCH`(alphavantage)/ `search_companies`(edinetdb)で先に確定する。
3. 返り値が想定より極端に短い/欠けている場合、新規上場・上場廃止・無料枠制約のいずれかを切り分ける。
4. レート制限・premium 制約に当たったら、別 MCP へのフォールバックを検討する。
5. 大きな返り値はファイルにオフロードされることがある。`return_full_data=true` で本体を確保する。
