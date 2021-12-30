#!/bin/bash

go install github.com/x-motemen/ghq@latest
go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/lint/golint@latest
# go install golang.org/x/tools/gopls@latest
go install github.com/nametake/golangci-lint-langserver@latest
go install github.com/cweill/gotests/...@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
