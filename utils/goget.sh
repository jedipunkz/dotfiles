#!/bin/bash

cat << EOS
gvm install goX.XX.XX
gvm use goX.XX.XX --default
gvm pkgenv global
## Edit and Add below: export GOPRIVATE; GOPRIVATE="github.com/readyfor"
gvm pkgset use global
git config --global ghq.root "$GOPATH/src"
## boot vim and exec :LspInstallServer
## if you already did abobe operations, exec: bash dotfiles/utils/goget.sh -f # -f: force opts
EOS

if [ "$1" = "-f" ]; then
  go install github.com/x-motemen/ghq@latest
  go install golang.org/x/tools/cmd/goimports@latest
  go install golang.org/x/lint/golint@latest
  # go install golang.org/x/tools/gopls@latest
  go install github.com/nametake/golangci-lint-langserver@latest
  go install github.com/cweill/gotests/...@latest
  go install honnef.co/go/tools/cmd/staticcheck@latest
  echo "Installation completed."
fi
