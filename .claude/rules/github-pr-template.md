---
description: gh pr create で GitHub PR を作成する際に適用するテンプレート
globs:
---

GitHub PR は gh コマンドで作成すること。

`gh pr create` で PR を作成する際は、以下のテンプレートに従って body を構成すること。

```
gh pr create --title "<PR タイトル>" --body "$(cat <<'EOF'
## Why

<この PR の目的・背景を簡潔に記述>
<対応チケットがあればその URL も記す>


## What

- <変更内容を箇条書きで記述>

## Reference

- <参考にしたドキュメントや URL（なければ「なし」と記載）>

EOF
)"
```

注意事項:
- タイトルは変更内容を端的に表す（70 文字以内）
- 対応チケットやリファレンスがない場合は「なし」と明記する
