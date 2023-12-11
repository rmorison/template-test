.PHONY: clean distclean

# Edit: go module path to this package: https://go.dev/ref/mod#glos-module-path
GO_TOOLCHAIN_PACKAGE := $(GO_PACKAGE)/toolchain
# Edit: protoc version from releases page: https://github.com/protocolbuffers/protobuf/releases/
PROTOC_VERSION := 25.1
# Edit: protoc build arch from releases page: https://github.com/protocolbuffers/protobuf/releases/
PROTOC_ARCH := $(if $(PROTOC_ARCH),$(PROTOC_ARCH),linux-x86_64)

# Derived values
PROTOC_ZIP := protoc-$(PROTOC_VERSION)-$(PROTOC_ARCH).zip
PROTOC_URL := https://github.com/protocolbuffers/protobuf/releases/download/v$(PROTOC_VERSION)/$(PROTOC_ZIP)
SHELL=/bin/bash

tools: go.mod go.sum bin/protoc bin/protoc-gen-go bin/protoc-gen-go-grpc

go.mod go.sum: tools.go
	[ -f go.mod ] || go mod init $(GO_TOOLCHAIN_PACKAGE)
	go mod tidy

bin/protoc: downloads/$(PROTOC_ZIP)
	unzip -u $<
	touch $@ # fresh mtime over archive time

downloads/$(PROTOC_ZIP): | downloads
	wget --directory-prefix=downloads "$(PROTOC_URL)"

bin/protoc-gen-go: go.sum | bin
	export GOBIN=$$(pwd)/bin && go install google.golang.org/protobuf/cmd/protoc-gen-go

bin/protoc-gen-go-grpc: go.sum | bin
	export GOBIN=$$(pwd)/bin && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc

downloads bin:
	mkdir $@

clean:
	rm -rf downloads include bin readme.txt

distclean: clean
	rm -rf go.mod go.sum
