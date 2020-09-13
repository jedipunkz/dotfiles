#!/bin/bash

go get github.com/x-motemen/ghq
go get golang.org/x/tools/cmd/goimportsgo
g oget golang.org/x/tools/gopls
go get github.com/nametake/golangci-lint-langserver

# ToDo
# .gvm/environments/go1.15.1@global を参考に GOPATH, GOPRIVATE を設定する必要がある
