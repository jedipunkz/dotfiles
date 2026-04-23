---
description: git commit の粒度・コマンド形式・メッセージ記述に関するルール
globs:
---

# Git Commit Rules

## Commit の粒度

- **意味のある最小単位**で commit すること。1 commit = 1 つの論理的な変更。
- 複数の独立した変更を 1 commit にまとめない。
- 「とりあえず全部 add して commit」は禁止。変更内容を確認してから個別に stage する。

## Commit コマンド形式

- `git commit -m "<message>"` の **1 行形式**のみ使用すること。
- `cat <<'EOF'` を使った heredoc 形式は使用しない。
- body や footer が必要な場合も `-m` を複数回使う形式で記述する。

```bash
# OK
git commit -m "feat: add login endpoint"

# OK (body あり)
git commit -m "fix: handle null pointer in user lookup" -m "Closes #42"

# NG — heredoc は使わない
git commit -m "$(cat <<'EOF'
feat: add login endpoint
EOF
)"
```

## Commit メッセージ

- **英語**で記述すること。
- 先頭に以下の prefix を付け、コロン `":"`と半角スペースで区切ること。

| Prefix | 用途 |
|--------|------|
| `feat:` | 新機能の追加 |
| `fix:` | バグ修正 |
| `hotfix:` | 本番環境の緊急修正 |
| `docs:` | ドキュメントのみの変更 |
| `style:` | フォーマット・空白・セミコロンなど（仕様変更なし） |
| `refactor:` | リファクタリング（機能変更なし） |
| `perf:` | パフォーマンス改善 |
| `test:` | テストの追加・修正 |
| `chore:` | ビルド設定・依存関係・補助ツールの更新 |
| `revert:` | 過去 commit の取り消し |

- subject は動詞の原形から始める（例: `add`, `fix`, `remove`, `update`）。
- 末尾にピリオドを付けない。
- 50 文字以内を目安にする。
