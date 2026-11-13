#!/usr/bin/env bash
# herdr の popup で holo を開き、選んだセッションは popup を開いた元のペインで再開する。
# holo は選択時に `claude --resume <id>` を exec するため、PATH の先頭に偽の claude を置いて横取りする。
set -euo pipefail

shim_dir=$(mktemp -d)
trap 'rm -rf "$shim_dir"' EXIT

cat >"$shim_dir/claude" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
# popup には HERDR_PANE_ID がなく、開いた元のペインは HERDR_ACTIVE_PANE_ID で渡される。
# 元のペインの shell に cd と claude を打ち込む。holo がセッションの cwd へ chdir 済みのため $PWD を使う
herdr pane run "$HERDR_ACTIVE_PANE_ID" "$(printf 'cd %q && ' "$PWD")$(printf '%q ' claude "$@")"
EOF
chmod +x "$shim_dir/claude"

PATH="$shim_dir:$PATH" holo
