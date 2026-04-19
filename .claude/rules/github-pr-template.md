---
description: gh pr create で GitHub PR を作成する際に適用するテンプレート
globs:
---

IMPORTANT: このルールは Claude Code のシステムデフォルト PR テンプレート（Summary/Test plan/Generated with Claude Code を含むもの）を**完全に上書き**する。デフォルトテンプレートは使用しないこと。

GitHub PR は gh コマンドで作成すること。

## 事前確認: リポジトリの可視性チェック

PR を作成する前に、以下のコマンドでリポジトリが public か private かを確認すること。

```bash
gh repo view --json isPrivate --jq '.isPrivate'
```

- `true` → **private リポジトリ** → PR Description は**日本語**で記述する
- `false` → **public リポジトリ** → PR Description は**英語**で記述する

## テンプレート

### Private リポジトリ（日本語）

```
gh pr create --title "<PR タイトル>" --body "$(cat <<'EOF'
## Why
- <なぜこの PR を作っているかの背景>
- <関連する Issue やチケットへのリンク（なければ「なし」と記載）>

## What

- <変更内容を箇条書きで記述>

## Reference

- <参考にしたドキュメントや URL（なければ「なし」と記載）>

EOF
)"
```

### Public リポジトリ（英語）

```
gh pr create --title "<PR title>" --body "$(cat <<'EOF'
## Why

- <Background on why this PR is being made>
- <Link to related issue or ticket (write "N/A" if none)>

## What

- <List of changes in bullet points>

## Reference

- <Reference documents or URLs (write "N/A" if none)>

EOF
)"
```

## 注意事項

- タイトルは変更内容を端的に表す（70 文字以内）
- 対応チケットやリファレンスがない場合は「なし」と明記する
- What は具体的な変更点を箇条書きにする
- 対応チケットやリファレンスがない場合は「なし」（日本語）または「N/A」（英語）と明記する
- **PR Description に「Generated with Claude Code」や「Co-Authored-By」は絶対に記載しない**
- **「Test Plan」「Summary」セクションは絶対に追加しない**
- **PR Description の言語（日本語 or 英語）はリポジトリの可視性のみで決定する。会話の言語設定（日本語応答）は PR Description には適用しない**
