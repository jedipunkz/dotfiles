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
check "Read tfstate blocked"     2 block-sensitive-access.sh '{"tool_name":"Read","tool_input":{"file_path":"/repo/terraform.tfstate"}}'
check "Read tfstate backup blocked" 2 block-sensitive-access.sh '{"tool_name":"Read","tool_input":{"file_path":"/repo/terraform.tfstate.backup"}}'
check "patch tfstate blocked"    2 block-sensitive-access.sh '{"tool_name":"apply_patch","tool_input":{"command":"*** Begin Patch\n*** Update File: infra/terraform.tfstate\n*** End Patch"}}'
check "Bash cat tfstate blocked" 2 block-sensitive-access.sh '{"tool_name":"Bash","tool_input":{"command":"cat infra/terraform.tfstate"}}'
check "Read .tf passes"          0 block-sensitive-access.sh '{"tool_name":"Read","tool_input":{"file_path":"/repo/main.tf"}}'

echo "check-secrets"
check "Write .env blocked"      2 check-secrets.sh '{"tool_name":"Write","tool_input":{"file_path":"/repo/.env","content":"X=1"}}'
check "Write secret blocked"    2 check-secrets.sh "{\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"/repo/a.go\",\"content\":\"$K1\"}}"
check "Write normal passes"     0 check-secrets.sh '{"tool_name":"Write","tool_input":{"file_path":"/repo/a.go","content":"package main"}}'
check "patch .env blocked"      2 check-secrets.sh '{"tool_name":"apply_patch","tool_input":{"command":"*** Add File: /repo/.env\n+X=1"}}'
check "patch secret blocked"    2 check-secrets.sh "{\"tool_name\":\"apply_patch\",\"tool_input\":{\"command\":\"*** Update File: a.go\n+$K2\"}}"
check "patch normal passes"     0 check-secrets.sh '{"tool_name":"apply_patch","tool_input":{"command":"*** Update File: a.go\n+package main"}}'

echo "quality-check (always exit 0, findings as decision:block on stdout)"
check "missing file passes"     0 quality-check.sh '{"tool_name":"Write","tool_input":{"file_path":"/nonexistent/a.sh"}}'
check "empty patch passes"      0 quality-check.sh '{"tool_name":"apply_patch","cwd":"/tmp"}'

# check_out <name> <want: block|none> <payload>
check_out() {
  local name="$1" want="$2" payload="$3" got
  if printf '%s' "$payload" | bash "$H/quality-check.sh" 2>/dev/null | jq -e '.decision == "block"' >/dev/null 2>&1; then
    got=block
  else
    got=none
  fi
  if [ "$got" = "$want" ]; then
    printf '  ok    %-34s %s\n' "$name" "$got"
  else
    printf '  FAIL  %-34s %s want=%s\n' "$name" "$got" "$want"
    FAIL=1
  fi
}

T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
if command -v shellcheck >/dev/null 2>&1; then
  printf '#!/bin/bash\nunused=1\n' > "$T/bad.sh"
  printf '#!/bin/bash\necho ok\n' > "$T/good.sh"
  check_out "Write bad .sh blocks"   block "{\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"$T/bad.sh\"}}"
  check_out "Write good .sh silent"  none  "{\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"$T/good.sh\"}}"
  check_out "patch relative .sh"     block "{\"tool_name\":\"apply_patch\",\"cwd\":\"$T\",\"tool_input\":{\"command\":\"*** Begin Patch\n*** Update File: bad.sh\n*** End Patch\"}}"
fi
if command -v terraform >/dev/null 2>&1; then
  printf 'variable "a" {\ndefault=1\n}\n' > "$T/fmt.tf"
  printf 'variable "a" {\n' > "$T/broken.tf"
  check_out "Write unformatted .tf"  none  "{\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"$T/fmt.tf\"}}"
  if grep -q 'default = 1' "$T/fmt.tf"; then
    printf '  ok    %-34s\n' ".tf formatted in place"
  else
    printf '  FAIL  %-34s\n' ".tf formatted in place"; FAIL=1
  fi
  check_out "Write broken .tf blocks" block "{\"tool_name\":\"Edit\",\"tool_input\":{\"file_path\":\"$T/broken.tf\"}}"
fi
if command -v gofmt >/dev/null 2>&1; then
  printf 'package main\nfunc main( {\n' > "$T/broken.go"
  check_out "Edit broken .go blocks" block "{\"tool_name\":\"Edit\",\"tool_input\":{\"file_path\":\"$T/broken.go\"}}"
fi

echo
if [ "$FAIL" = 0 ]; then echo "all passed"; else echo "FAILURES present"; fi
exit "$FAIL"
