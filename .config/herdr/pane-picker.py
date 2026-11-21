#!/usr/bin/env python3
# CLI の `herdr pane focus` は隣接移動だけのため、socket API の pane.focus を直接呼ぶ。
import json
import os
import socket
import subprocess
import sys

IDLE_SHELL = "fish"

BLUE, CYAN, MAGENTA, GREEN = "122;162;247", "125;207;255", "187;154;247", "158;206;106"
YELLOW, RED, ORANGE, COMMENT = "224;175;104", "247;118;142", "255;158;100", "86;95;137"
STATUS_COLORS = {"working": (YELLOW, False), "blocked": (RED, True), "idle": (GREEN, False), "done": (GREEN, False)}

FZF_COLORS = (
    "fg:#c0caf5,bg:-1,hl:#2ac3de,fg+:#c0caf5,bg+:#283457,hl+:#2ac3de,gutter:-1,info:#545c7e,"
    "prompt:#2ac3de,pointer:#ff007c,marker:#ff007c,spinner:#ff007c,header:#ff9e64,border:#27a1b9,"
    "separator:#ff9e64,scrollbar:#27a1b9,query:#c0caf5:regular"
)


def rpc(method, params=None):
    # herdr の socket は 1 接続 1 リクエストで切断するため都度接続する
    with socket.socket(socket.AF_UNIX) as s:
        s.connect(os.environ["HERDR_SOCKET_PATH"])
        req = {"id": "pane-picker", "method": method, "params": params or {}}
        s.sendall((json.dumps(req) + "\n").encode())
        res = json.loads(s.makefile().readline())
    if "error" in res:
        sys.exit(f"{method} failed: {res['error'].get('message')}")
    return res["result"]


def pane_rows():
    home = os.environ["HOME"]
    active = os.environ.get("HERDR_ACTIVE_PANE_ID", "")
    ws = {w["workspace_id"]: f'{w["number"]} {w["label"]}' for w in rpc("workspace.list")["workspaces"]}
    tabs = {t["tab_id"]: t["label"] for t in rpc("tab.list")["tabs"]}
    for p in rpc("pane.list")["panes"]:
        agent = p.get("agent")
        if agent:
            cmd = agent
        else:
            info = rpc("pane.process_info", {"pane_id": p["pane_id"]})["process_info"]
            cmd = (info.get("foreground_processes") or [{}])[0].get("name") or ""
        cwd = p.get("foreground_cwd") or p.get("cwd") or ""
        if cwd == home or cwd.startswith(home + "/"):
            cwd = "~" + cwd[len(home):]
        agent_title = (p.get("terminal_title_stripped") or "") if agent else ""
        yield [
            p["pane_id"],
            "*" if p["pane_id"] == active else "",
            ws.get(p["workspace_id"], ""),
            tabs.get(p["tab_id"], ""),
            cmd,
            (p.get("agent_status") or "") if agent else "-",
            cwd,
            agent_title,
        ]


def paint(rgb, text, bold=False):
    return f"\033[{'1;' if bold else ''}38;2;{rgb}m{text}\033[0m"


COLUMNS = [
    ("ID", None),
    ("", lambda v: (ORANGE, True)),
    ("WORKSPACE", lambda v: (BLUE, False)),
    ("TAB", None),
    ("COMMAND", lambda v: (COMMENT if v == IDLE_SHELL else MAGENTA, False)),
    ("STATUS", lambda v: STATUS_COLORS.get(v, (COMMENT, False))),
    ("DIR", lambda v: (CYAN, False)),
    ("TITLE", None),
]


def fzf_lines(rows):
    header = [name for name, _ in COLUMNS]
    widths = [max(len(r[i]) for r in [header] + rows) for i in range(len(COLUMNS))]
    last = len(COLUMNS) - 1

    def line(row, colored):
        cells = []
        for i, (_, color) in enumerate(COLUMNS[1:], start=1):
            text = row[i] if i == last else row[i].ljust(widths[i])
            if colored and color:
                rgb, bold = color(row[i])
                text = paint(rgb, text, bold)
            cells.append(text)
        return row[0] + "\t" + "  ".join(cells)

    yield line(header, colored=False)
    for row in rows:
        yield line(row, colored=True)


def main():
    rows = [[f.replace("\t", " ") for f in r] for r in pane_rows()]
    fzf = subprocess.run(
        [
            "fzf", "--ansi", "--delimiter=\\t", "--with-nth=2", "--header-lines=1", "--prompt=pane> ",
            f"--color={FZF_COLORS}",
            "--preview=herdr pane read --source visible --format ansi {1} | tr -d '\\r'",
            "--preview-window=down,50%",
        ],
        input="".join(line + "\n" for line in fzf_lines(rows)),
        stdout=subprocess.PIPE,
        text=True,
    )
    if fzf.returncode != 0:
        return
    rpc("pane.focus", {"pane_id": fzf.stdout.split("\t", 1)[0]})


if __name__ == "__main__":
    main()
