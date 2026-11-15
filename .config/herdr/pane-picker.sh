#!/usr/bin/env bash
# herdr の popup で全 workspace のペインを fzf に出し、選んだペインへ移動する。
# CLI の `herdr pane focus` は隣接移動だけのため、socket API の pane.focus を直接呼ぶ。
set -euo pipefail

ws=$(herdr workspace list | jq -c '[.result.workspaces[] | {key: .workspace_id, value: "\(.number) \(.label)"}] | from_entries')
tabs=$(herdr tab list | jq -c '[.result.tabs[] | {key: .tab_id, value: .label}] | from_entries')

# 1 行 1 ペインの TSV。1 列目の pane_id は fzf で非表示にし、選択後の移動にだけ使う
rows() {
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' ID '' WORKSPACE TAB COMMAND STATUS DIR TITLE
  herdr pane list | jq -c '.result.panes[]' | while read -r pane; do
    id=$(jq -r .pane_id <<<"$pane")
    # agent が無いペインは前面プロセス名（fish なら shell が待機中）を出す
    proc=$(herdr pane process-info --pane "$id" | jq -r '.result.process_info.foreground_processes[0].name // ""')
    jq -r --argjson ws "$ws" --argjson tabs "$tabs" --arg active "${HERDR_ACTIVE_PANE_ID:-}" --arg proc "$proc" '
      [ .pane_id,
        (if .pane_id == $active then "*" else "" end),
        $ws[.workspace_id],
        $tabs[.tab_id],
        (.agent // $proc),
        (if .agent then .agent_status else "-" end),
        (.foreground_cwd // .cwd | sub("^" + env.HOME; "~")),
        # shell の title は cwd と重複するため agent のときだけ出す（claude は会話の題名になる）
        (if .agent then .terminal_title_stripped // "" else "" end) ]
      | @tsv' <<<"$pane"
  done
}

# 2 列目以降を列幅を揃えた 1 つの表示列にまとめ、列と状態ごとに Tokyo Night の色を付ける（truecolor）。
# 幅は色を付ける前に揃える（エスケープシーケンスを幅に数えないため）。
# TITLE は最後なので全角文字でずれても他の列に影響しない
align() {
  awk -F'\t' '
    BEGIN {
      blue = "122;162;247"; cyan = "125;207;255"; magenta = "187;154;247"; green = "158;206;106"
      yellow = "224;175;104"; red = "247;118;142"; orange = "255;158;100"; comment = "86;95;137"
    }
    function paint(rgb, v, bold) { return "\033[" (bold ? "1;" : "") "38;2;" rgb "m" v "\033[0m" }
    function color(r, i, v,   s) {
      if (r == 1) return v                            # 項目名: fzf の header 色に任せる
      if (i == 2) return paint(orange, v, 1)          # 元のペインの *
      if (i == 3) return paint(blue, v)               # WORKSPACE
      if (i == 5) return paint(cell[r, i] == "fish" ? comment : magenta, v) # COMMAND: shell 待機は暗く
      if (i == 6) {                                   # STATUS: 状態ごと
        s = cell[r, i]
        if (s == "working") return paint(yellow, v)
        if (s == "blocked") return paint(red, v, 1)
        if (s == "idle" || s == "done") return paint(green, v)
        return paint(comment, v)
      }
      if (i == 7) return paint(cyan, v)               # DIR
      return v
    }
    { n = NR; for (i = 1; i <= NF; i++) { cell[NR, i] = $i; if (length($i) > w[i]) w[i] = length($i) } nf[NR] = NF }
    END {
      for (r = 1; r <= n; r++) {
        line = ""
        for (i = 2; i <= nf[r]; i++) line = line color(r, i, sprintf(i < nf[r] ? "%-" w[i] "s" : "%s", cell[r, i])) (i < nf[r] ? "  " : "")
        print cell[r, 1] "\t" line
      }
    }'
}

# fzf 本体の配色（Tokyo Night）。背景は popup に合わせて端末既定のまま
tokyonight='fg:#c0caf5,bg:-1,hl:#2ac3de,fg+:#c0caf5,bg+:#283457,hl+:#2ac3de,gutter:-1,info:#545c7e,prompt:#2ac3de,pointer:#ff007c,marker:#ff007c,spinner:#ff007c,header:#ff9e64,border:#27a1b9,separator:#ff9e64,scrollbar:#27a1b9,query:#c0caf5:regular'

selected=$(
  rows | align |
    fzf --ansi --delimiter='\t' --with-nth=2 --header-lines=1 --prompt='pane> ' --color="$tokyonight" \
      --preview="herdr pane read --source visible --format ansi {1} | tr -d '\\r'" --preview-window=down,50% |
    cut -f1
) || exit 0 # Esc / ctrl-c で閉じたときは何もしない

python3 - "$selected" <<'PY'
import json, os, socket, sys

with socket.socket(socket.AF_UNIX) as s:
    s.connect(os.environ["HERDR_SOCKET_PATH"])
    req = {"id": "pane-picker", "method": "pane.focus", "params": {"pane_id": sys.argv[1]}}
    s.sendall((json.dumps(req) + "\n").encode())
    res = json.loads(s.makefile().readline())
if "error" in res:
    sys.exit(f"pane.focus failed: {res['error'].get('message')}")
PY
