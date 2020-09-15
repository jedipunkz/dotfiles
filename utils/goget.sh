#!/bin/bash

cat << EOS
gvm install goX.XX.XX
gvm use goX.XX.XX --default
gvm pkgenv global
## Edit: export GOPRIVATE; GOPRIVATE="github.com/readyfor"
gvm pkgset use global
git config --global ghq.root "$GOPATH/src"
bash ./goget.sh
## boot vim and exec :LspInstallServer
##
## if you already did abobe operations, exec: bash dotfiles/utils/goget.sh -f # -f: force opts
EOS

if [ "$1" = "-f" ]; then
  go get github.com/x-motemen/ghq
  go get golang.org/x/tools/cmd/goimports
  go get -u golang.org/x/lint/golint
  go get golang.org/x/tools/gopls
  go get github.com/nametake/golangci-lint-langserver
fi
