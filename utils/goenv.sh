#!/bin/bash

cat << EOS
gvm install goX.XX.XX
gvm use goX.XX.XX --default
gvm pkgenv global
## 右記を追記: export GOPRIVATE; GOPRIVATE="github.com/readyfor"
gvm pkgset use global
git config --global ghq.root "$GOPATH/src"
bash ./goget.sh
# vim で LspInstallServer 実行
EOS
