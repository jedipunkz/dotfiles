# Claude Code の skill / playbook / agent

## 自作 skills

| skill | 内容 |
|---|---|
| `codex-review` | Codex CLI によるコード・設定レビュー |
| `finance-mcp` | 株価・為替・財務データを MCP 経由で取得 |
| `github-publish` | branch push と PR 作成の workflow |
| `monitor-triage` | Slack 通知からのモニタリングトリアージ |
| `renovate-auto-merge` | 当日の Renovate PR を approve し、CI 完了を待って squash merge する |
| `systematic-debugging` | pstack の bug-fix playbook と root-cause 系 principle へ誘導 |
| `test-driven-development` | pstack の `tdd` とテスト系 principle へ誘導 |
| `verification-before-completion` | pstack の `principle-prove-it-works` と verify スキルへ誘導 |
| `web-research` | 一次情報を優先した web 調査手順 |
| `weekly-report` / `weekly-thanks` | Slack 向け週次レポート / 感謝メッセージ |
| `worktree-add` | git worktree を作成しそこで作業を続ける |
| `go-best-practices` / `terraform-best-practices` | 言語別の型・境界・検証ルール |

## pstack 由来 skill（50 件）

内訳は個別で使える skill 26 件と `principle-*` 24 件。出典・ライセンスは `.claude/skills/PSTACK_NOTICE.md`。
`principle-*` は設計・実装の原則集で、主に `tachikoma` が適用する（`fix-root-causes`、`prove-it-works`、`subtract-before-you-add` など）。

### 個別で使える skill（26 件）

`/<name>` で直接呼ぶ。

| skill | 内容 |
|---|---|
| `tachikoma` | ルーター。タスクに合う playbook を選び、principle を適用し、subagent へ委譲し、検証まで進める |
| `architect` | コードを書く前に型・シグネチャ・モジュール構造を設計する |
| `arena` | 同じタスクに N 個の候補を並列生成し、ベースを選んで敗者の強い部分を移植する |
| `swarm` | N 個の worker を並列展開し、回収して 1 本のレポートにまとめる |
| `interrogate` | 敵対的レビュー。実行で証明できた指摘だけを残す |
| `figure-it-out` | 合う playbook がない大きな作業向けに、監査可能な playbook を自分で設計する |
| `blast-radius` | diff の外側で壊れうる箇所を探し、安全である根拠を実コードの実行で証明する |
| `benchmark-checklist` | 性能計測の妥当性（律速・チューニング・再現性など）を報告前に検査する |
| `tdd` | 明示的に TDD / regression test を求められたときの red-green-refactor |
| `correct` | リポジトリで繰り返される間違いを、構造・型・lint・テストで再発不能にする |
| `create-verification-skill` | アプリをユーザー操作で検証する project-local skill を生成する |
| `maintain-verification-skill` | 生成した検証 skill と feature map を定期的に点検・修正する |
| `no-comments` | comment-sicko agent を起動し、不要コメントを削除する |
| `unslop` | 文章から AI 特有のパターンを除去する |
| `technical-writing` | Diátaxis / Google style 等に基づく技術文書の執筆・レビュー基準 |
| `teach` | `how` と `why` を実行し、成果を 1 本の平易な説明に編む |
| `how` | 「X はどう動くか」。サブシステムの構造と実行フローを説明する |
| `why` | 「なぜこの設計か」。決定と tradeoff を根拠付きで説明する |
| `bro` | 直前のメッセージを専門用語なしで言い直す |
| `in-your-own-words` | ユーザーの目的と課題を自分の言葉で言い直して確認する |
| `ketchup` | 前回の発言以降にチャットで起きたことと、ユーザー待ちの判断を平易にまとめる |
| `recall` | 自分のチャット履歴と現在の状態から直近の作業コンテキストを再構築する |
| `reflect` | 現在のトランスクリプトから学びを抽出し、既存 skill への編集に落とす |
| `sharpen` | タスクを広げずに深くし、プロンプトを書き直す |
| `show-me-your-work` | 長時間・無人作業向けに、1 決定 1 行の TSV で判断の証跡を残す |
| `typescript-best-practices` | TypeScript の型・境界・検証ルール |

### Playbook

playbook は独立した仕組みではなく、`tachikoma` skill の手順書。
`.claude/skills/tachikoma/playbooks/<title>.md` に 15 件ある。
`/tachikoma <task>` がタスクに合う 1 件を選び、steps を todolist に写してから実行する。
どれにも合わない大きな作業は `figure-it-out` skill へ回る。

| playbook | 用途 |
|---|---|
| `investigation` | 調査。答えに責任を持ち、計画・ルーティング・記述を行う |
| `bug-fix` | バグ修正。調査と修正を subagent に委譲し、検証まで主導する |
| `perf-issue` | 性能問題。全ての修正を計測に紐づける |
| `hillclimb` | 計測可能な指標を目標値まで反復改善するループ |
| `runtime-forensics` | 稼働中プロセスを計装して診断する。成果物は根拠付き診断 |
| `trace-forensics` | トレース等の成果物から診断する |
| `feature` | 機能追加。設計を握り、実装を委譲する |
| `refactoring` | 挙動を変えない構造変更 |
| `prototype` | 設計判断のための使い捨て試作。本実装は `feature` へ |
| `authoring-a-skill` | skill の作成・修正 |
| `autonomous-run` | 完了条件を定義して止まらず走る自律実行 |
| `session-pickup` | 前セッションの軌跡を読んで再開する |
| `pause-safely` | 再開可能なチェックポイントを残して明示的に停止する |
| `multi-phase-plan` | 複数フェーズ / 複数 PR の計画作成。実装はしない |
| `opening-a-pr` | PR 作成。他の全 playbook の最終ステップから呼ばれる |

### Agent（subagent）


| agent | 役割 |
|---|---|
| `architect` | 設計・リポジトリ構造・大きめの計画判断（読み取り専用） |
| `researcher` | 調査・web 検索・コード探索（読み取り専用） |
| `debugger` | エラー・失敗コマンドの原因調査と修正 |
| `docs-writer` | 既存コード・設定からのドキュメント作成・更新 |
| `security-auditor` | hooks・settings のセキュリティ監査（報告のみ） |
| `test-runner` | 変更に対する最小限のテスト実行・検証 |
| `go-writer` / `go-reviewer` | Go の作成 / レビュー |
| `typescript-writer` / `typescript-reviewer` | TypeScript/React の作成 / レビュー |
| `python-writer` / `python-reviewer` | Python の作成 / レビュー |
| `terraform-writer` / `terraform-reviewer` | Terraform の作成 / レビュー |
| `shell-reviewer` | シェルスクリプトのレビュー |
| `dart-reviewer` | Dart/Flutter のレビュー |
| `proto-reviewer` | Protobuf 定義のレビュー |
| `sql-reviewer` | SQL・migration のレビュー |
| `tachikoma-agent` | `/tachikoma` 実行中の委譲先（pstack 由来） |
| `comment-sicko` | コメント削除の判定（pstack 由来） |

