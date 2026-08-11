# Neovim Keybindings

このドキュメントは dotfiles の nvim 設定（`lua/keymaps.lua` および各 plugin 設定）で定義されている
キーバインドの一覧。

- `<leader>` = `<Space>`（`init.lua:2`）
- `<localleader>` = `\`（`init.lua:3`）

## 基本操作（Normal モード）

定義: `lua/keymaps.lua`

| キー | 動作 |
|------|------|
| `;` | `:` と入れ替え（コマンド入力） |
| `te` | `:tabedit`（新しいタブを開く・コマンド未確定） |
| `gn` | 新しいタブを一番右に作成 |
| `gh` | 前のタブへ移動（`gT`） |
| `gl` | 次のタブへ移動（`gt`） |
| `ss` | 水平分割して新ウィンドウへ移動 |
| `sv` | 垂直分割して新ウィンドウへ移動 |
| `<C-a>` | 全選択（`gg V G`） |
| `x` | 削除（レジスタを汚さない） |
| `c` / `C` | 変更（レジスタを汚さない） |
| `s` / `S` | 置換（レジスタを汚さない） |
| `dw` | カーソル前方の単語を削除（レジスタを汚さない） |
| `<Space>h` | 行頭へ移動（`^`） |
| `<Space>l` | 行末へ移動（`$`） |
| `Y` | 行末までヤンク（`y$`） |
| `<Space>q` | 強制終了（`:q!`）※ LSP 読込後は `setloclist` に上書きされる（下記 LSP 表参照） |
| `<Esc><Esc>` | 検索ハイライトを消す |
| `ct` | `:checktime`（外部変更されたファイルの再読込） |
| `<C-y>` | ジャンプ履歴を戻る（`<C-o>` 相当） |
| `<C-i>` | ジャンプ履歴を進む |
| `<leader>j` | ジャンプ履歴一覧を表示（`:jumps`） |

## Insert モード

定義: `lua/keymaps.lua`

| キー | 動作 |
|------|------|
| `jk` | Insert モードを抜ける（`<Esc>`） |
| `<C-k>` | カーソル位置から行末まで削除 |

## Visual モード

定義: `lua/keymaps.lua`

| キー | 動作 |
|------|------|
| `<` / `>` | インデント調整（選択を維持したまま） |
| `v` | 行末まで選択を拡張（`$h`） |
| `c` / `s` / `S` | 変更・置換（レジスタを汚さない） |
| `<leader>p` | 0 番レジスタからペースト |

## Terminal モード

定義: `lua/keymaps.lua`

| キー | 動作 |
|------|------|
| `<C-\>` | Terminal モードを抜ける |
| `<C-w>h/j/k/l` | Terminal からウィンドウ移動 |

## LSP（nvim-lspconfig）

定義: `lua/keymaps.lua`, `lua/plugins/lsp.lua`

| キー | 動作 |
|------|------|
| `gd` | 定義へジャンプ |
| `gD` | 宣言へジャンプ |
| `gi` | 実装へジャンプ |
| `gr` | 参照一覧を表示 |
| `K` | ホバードキュメント表示 |
| `<C-k>` | シグネチャヘルプ表示 |
| `<Space>e` | 診断を float で表示 |
| `[d` / `]d` | 前 / 次の診断へ移動 |
| `<Space>q` | 診断を loclist に表示 |
| `<Space>D` | 型定義へジャンプ |
| `<Space>rn` | リネーム |
| `<Space>ca` | コードアクション |
| `<Space>f` | フォーマット（async） |
| `<Space>wa` | ワークスペースフォルダ追加 |
| `<Space>wr` | ワークスペースフォルダ削除 |
| `<Space>wl` | ワークスペースフォルダ一覧を表示 |

## snacks.nvim（picker / explorer / lazygit / gitbrowse）

定義: `lua/plugins/snacks.lua`

| キー | モード | 動作 |
|------|--------|------|
| `<leader>sf` | n | Smart file search（picker） |
| `<leader>sg` | n | Grep 検索（picker） |
| `<leader>sb` | n | Git browse（リポジトリをブラウザで開く） |
| `<leader>sl` | n | Lazygit を開く |
| `<C-e>` | n | File explorer をトグル |
| `s` | explorer 内 | 水平分割で開く |
| `v` | explorer 内 | 垂直分割で開く |

## sidekick.nvim（AI CLI 連携）

定義: `lua/plugins/sidekick.lua`

| キー | モード | 動作 |
|------|--------|------|
| `<Tab>` | n | Next Edit Suggestion へジャンプ / 適用（なければ通常の Tab） |
| `<C-.>` | n, t, i, x | Sidekick CLI をトグル |
| `<leader>aa` | n | Sidekick CLI をトグル |
| `<leader>ar` | n | Claude Resume（`claude --resume`）をトグル |
| `<leader>as` | n | CLI ツールを選択 |
| `<leader>ad` | n | CLI セッションをデタッチ |
| `<leader>at` | n, x | カーソル位置のコンテキスト（`{this}`）を送信 |
| `<leader>af` | n | 現在のファイル（`{file}`）を送信 |
| `<leader>av` | x | Visual 選択範囲（`{selection}`）を送信 |
| `<leader>ap` | n, x | プロンプトを選択して送信 |
| `<leader>ff` | n | Claude をトグル（focus） |
| `<leader>fr` | n | Claude Resume をトグル（focus） |
| `<leader>ft` | n | `{this}` を Claude に送信 |
| `<leader>fb` | n | 現在のバッファを Claude に送信 |
| `<leader>fs` | v | 選択範囲を Claude に送信 |
| `<leader>rr` | n | OpenCode を表示（focus） |
| `<leader>rb` | n | 現在のバッファを OpenCode に送信 |
| `<leader>rs` | v | 選択範囲を OpenCode に送信 |
| `<C-w>p` | n, t | Sidekick とエディタ間でフォーカス切替 |

注: Sidekick ウィンドウ内の `C-h/j/k/l`（ナビゲーション）、`C-f`（files picker）、
`C-b`（buffers picker）は無効化している。

## Copilot（copilot-lsp NES / copilot.lua suggestion）

定義: `lua/plugins/copilot.lua`, `lua/plugins/completion.lua`

| キー | モード | 動作 |
|------|--------|------|
| `<Tab>` | n | NES サジェストの開始位置へジャンプ → 適用（なければ `<C-i>` として動作） |
| `<Tab>` | i | NES サジェストを適用（なければ通常の Tab 入力） |
| `<Esc>` | n | NES サジェストをクリア（なければ検索ハイライトを消す） |
| `<Tab>` | i (suggestion) | copilot.lua のインラインサジェストを accept |
| `<M-]>` / `<M-[>` | i (suggestion) | 次 / 前のサジェスト |
| `<C-e>` | i (suggestion) | サジェストを却下 |

## blink.cmp（補完）

定義: `lua/plugins/completion.lua`

| キー | モード | 動作 |
|------|--------|------|
| `<C-Space>` | i | 補完メニュー表示 / ドキュメント表示切替 |
| `<CR>` | i | 補完を確定 |
| `<C-e>` | i | 補完をキャンセル |
| `<C-n>` / `<C-p>` | i | 次 / 前の候補を選択 |
| `<Tab>` / `<S-Tab>` | i | 次 / 前の候補選択（snippet の前進 / 後退を含む） |
| `<C-b>` / `<C-f>` | i | ドキュメントを上 / 下スクロール |

## TreeSJ（split / join）

定義: `lua/keymaps.lua`

| キー | 動作 |
|------|------|
| `mm` | split / join をトグル |
| `mj` | join（1 行にまとめる） |
| `ms` | split（複数行に展開） |

## Git（git-blame.nvim / fuzz.nvim / gitsigns）

定義: `lua/keymaps.lua`, `lua/plugins/git.lua`

| キー | 動作 |
|------|------|
| `gb` | Git blame 表示をトグル |
| `gB` | カーソル行の commit URL をコピー |
| `<C-g>` | fuzz.nvim を起動 / fetch |
| `<C-r>` | fuzz.nvim: pull（fuzz UI 内） |
| `<C-y>` | fuzz.nvim: push（fuzz UI 内） |

注: gitsigns.nvim はサイン表示のみでキーバインドは定義していない。

## Namu.nvim（シンボルナビゲーション）

定義: `lua/keymaps.lua`

| キー | 動作 |
|------|------|
| `nm` | バッファ内の LSP シンボルへジャンプ |
| `nw` | ワークスペースの LSP シンボルを検索 |

## grug-far.nvim（検索・置換）

定義: `lua/replace.lua`

グローバル:

| キー | モード | 動作 |
|------|--------|------|
| `<leader>sr` | n | grug-far を開く |
| `<leader>sw` | n | カーソル下の単語で検索・置換を開く |
| `<leader>sr` | v | 選択範囲で検索・置換を開く |

grug-far バッファ内（`<localleader>` = `\`）:

| キー | 動作 |
|------|------|
| `<localleader>r` | 置換を実行 |
| `<localleader>q` | quickfix リストへ送る |
| `<localleader>s` | 変更をファイルへ同期 |
| `<localleader>l` | カーソル行のみ同期 |
| `<localleader>c` | 閉じる |
| `<localleader>t` | 履歴を開く |
| `<localleader>a` | 履歴に追加 |
| `<localleader>f` | 再検索（refresh） |
| `<localleader>o` | 該当箇所を開く |
| `<localleader>b` | 実行を中断 |
| `<localleader>p` | 実行コマンドの表示切替 |
| `<Enter>` | 該当箇所 / 履歴エントリへジャンプ |
| `g?` | ヘルプ表示 |

## キーバインドを持たない主な plugin

| Plugin | 用途 | 操作方法 |
|--------|------|----------|
| trouble.nvim | 診断一覧 | `:Trouble` コマンド |
| vim-test | テスト実行 | `:TestNearest` `:TestFile` `:TestSuite` `:TestLast` `:TestVisit` |
| vim-delve | Go デバッガ | `:Dlv*` コマンド |
| mason.nvim | LSP サーバ管理 | `:Mason` コマンド |
| tComment | コメントトグル | デフォルトの `gc` / `gcc` |
| vim-terraform | Terraform 支援 | 保存時に自動 `terraform fmt` |
| vim-goimports | Go import 整理 | 保存時に自動実行 |
