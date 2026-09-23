#!/bin/bash
# Smoke test for the merged hooks: feeds both Claude Code and Codex tool vocabularies.
# Secret-looking literals are assembled at runtime so this file itself is not flagged.
H="$HOME/dotfiles/.claude/hooks"
FAIL=0

K1="API""_KEY=abcdefghijklmnopqrstuvwx"
K2="DB""_PASSWORD=abcdefghijklmnopqrst"

check() {
  local name="$1" want="$2" script="$3" payload="$4"
  shift 4
  local got
  printf '%s' "$payload" | bash "$H/$script" "$@" >/dev/null 2>&1
  got=$?
  if [ "$got" = "$want" ]; then
    printf '  ok    %-34s exit=%s\n' "$name" "$got"
  else
    printf '  FAIL  %-34s exit=%s want=%s\n' "$name" "$got" "$want"
    FAIL=1
  fi
}

echo "guard-rm"
check "recursive delete blocked" 2 guard-rm.sh '{"tool_name":"Bash","tool_input":{"command":"rm -rf /tmp/zz"}}'
check "flag order variant blocked" 2 guard-rm.sh '{"tool_name":"Bash","tool_input":{"command":"rm -fr /tmp/zz"}}'
check "plain delete passes"     0 guard-rm.sh '{"tool_name":"Bash","tool_input":{"command":"rm /tmp/zz"}}'
check "quoted mention passes"   0 guard-rm.sh '{"tool_name":"Bash","tool_input":{"command":"git commit -m \"drop that call\""}}'

echo "block-force-push"
check "--force blocked"         2 block-force-push.sh '{"tool_name":"Bash","tool_input":{"command":"git push --force origin main"}}'
check "-f blocked"              2 block-force-push.sh '{"tool_name":"Bash","tool_input":{"command":"git push origin -f main"}}'
check "plain push passes"       0 block-force-push.sh '{"tool_name":"Bash","tool_input":{"command":"git push origin main"}}'

echo "block-sensitive-access"
check "Read .env blocked"       2 block-sensitive-access.sh '{"tool_name":"Read","tool_input":{"file_path":"/repo/.env"}}'
check "Read ssh key blocked"    2 block-sensitive-access.sh '{"tool_name":"Read","tool_input":{"file_path":"~/.ssh/id_rsa"}}'
check "Grep aws dir blocked"    2 block-sensitive-access.sh '{"tool_name":"Grep","tool_input":{"path":"/Users/x/.aws/credentials"}}'
check "Read normal passes"      0 block-sensitive-access.sh '{"tool_name":"Read","tool_input":{"file_path":"/repo/main.go"}}'
check "patch .env blocked"      2 block-sensitive-access.sh '{"tool_name":"apply_patch","tool_input":{"command":"*** Begin Patch\n*** Add File: app/.env\n+X=1\n*** End Patch"}}'
check "patch normal passes"     0 block-sensitive-access.sh '{"tool_name":"apply_patch","tool_input":{"command":"*** Begin Patch\n*** Add File: app/main.go\n+package main\n*** End Patch"}}'
check "Bash read .env blocked"  2 block-sensitive-access.sh '{"tool_name":"Bash","tool_input":{"command":"cat /repo/.env"}}'

echo "check-secrets"
check "Write .env blocked"      2 check-secrets.sh '{"tool_name":"Write","tool_input":{"file_path":"/repo/.env","content":"X=1"}}'
check "Write secret blocked"    2 check-secrets.sh "{\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"/repo/a.go\",\"content\":\"$K1\"}}"
check "Write normal passes"     0 check-secrets.sh '{"tool_name":"Write","tool_input":{"file_path":"/repo/a.go","content":"package main"}}'
check "patch .env blocked"      2 check-secrets.sh '{"tool_name":"apply_patch","tool_input":{"command":"*** Add File: /repo/.env\n+X=1"}}'
check "patch secret blocked"    2 check-secrets.sh "{\"tool_name\":\"apply_patch\",\"tool_input\":{\"command\":\"*** Update File: a.go\n+$K2\"}}"
check "patch normal passes"     0 check-secrets.sh '{"tool_name":"apply_patch","tool_input":{"command":"*** Update File: a.go\n+package main"}}'

echo "lint-check (warn only, never blocks)"
check "Write .sh passes"        0 lint-check.sh '{"tool_name":"Write","tool_input":{"file_path":"/nonexistent/a.sh"}}'
check "patch passes"            0 lint-check.sh '{"tool_name":"apply_patch","cwd":"/tmp"}'

echo
if [ "$FAIL" = 0 ]; then echo "all passed"; else echo "FAILURES present"; fi
exit "$FAIL"
