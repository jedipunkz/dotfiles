---
description: git commit メッセージや branch 名を作成する際に適用する conventional commits ルール
globs:
---

# Conventional Commits & Branch Naming

一貫性のある git commit メッセージと branch 名の規約。

## Commit Message Prefix Rules

すべてのコミットメッセージは以下の prefix で始める:

| Prefix | 用途 | 例 |
|--------|------|-----|
| `feat:` | 新しい機能 | `feat: add user authentication` |
| `fix:` | バグの修正 | `fix: resolve login redirect issue` |
| `docs:` | ドキュメントのみの変更 | `docs: update API documentation` |
| `style:` | 空白、フォーマット、セミコロン追加など | `style: format code with prettier` |
| `refactor:` | 仕様に影響がないコード改善 | `refactor: simplify user validation logic` |
| `perf:` | パフォーマンス向上関連 | `perf: optimize database queries` |
| `test:` | テスト関連 | `test: add unit tests for auth module` |
| `chore:` | ビルド、補助ツール、ライブラリ関連 | `chore: update dependencies` |

## Branch Naming Convention

フォーマット: `<prefix>/<short-description>`

例:
```
feat/user-authentication
fix/login-redirect
docs/api-documentation
refactor/user-validation
chore/dependency-updates
```

## Commit Message フォーマット

```
<prefix>: <subject>

<optional body>

<optional footer>
```

## 判断基準

```
ユーザーに見える変更？
├─ Yes → 新機能？
│   ├─ Yes → feat:
│   └─ No → fix:
└─ No → コードの変更？
    ├─ Yes → 性能向上？
    │   ├─ Yes → perf:
    │   └─ No → ロジック改善？
    │       ├─ Yes → refactor:
    │       └─ No → test:
    └─ No → ドキュメント？
        ├─ Yes → docs:
        └─ No → chore:
```

## 実行時のルール

### Commit 作成時
1. 変更内容を分析
2. 上記の判断基準に従って適切な prefix を選択
3. 簡潔で明確な説明を英語で記述
4. 必要に応じて body を追加

### Branch 作成時
1. 作業内容から適切な prefix を選択
2. スラッシュ区切りで短い説明を追加
3. ケバブケース（lowercase + ハイフン）を使用

### 例外
- 初回コミット: `chore: initial commit`
- マージコミット: prefix 不要（自動生成されるため）
- Revert: `revert: <元のコミットメッセージ>`
