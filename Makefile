.PHONY: toolchain clean distclean

# Edit: go module path to this package: https://go.dev/ref/mod#glos-module-path
GO_PACKAGE := github.com/rmorison/protobuf-toolchain-template

# Edit: Add .proto files here
PROTO_FILES := proto/helloworld/helloworld.proto

# Derived: protoc built files
PROTOC_GO_FILES := $(PROTO_FILES:.proto=.pb.go) $(PROTO_FILES:.proto=_grpc.pb.go)
.SECONDARY: $(PROTOC_GO_FILES)

# Protocol compiler toolchain
PROTOC_BIN := toolchain/bin
PROTOC := $(PROTOC_BIN)/protoc
export PATH := $(shell pwd)/$(PROTOC_BIN):$(PATH)

# Build .pb.go from .proto
%.pb.go %_grpc.pb.go: %.proto $(PROTOC)
	$(PROTOC) $< \
		--go_out=. --go_opt=paths=source_relative \
		--go-grpc_out=. --go-grpc_opt=paths=source_relative

# Build go program from main.go
%/main: %/main.go go.mod $(PROTOC_GO_FILES)
	go mod tidy
	go build -o $@ $<

all: greeter_client/main greeter_server/main

greeter_client/main: greeter_client/main.go
greeter_server/main: greeter_server/main.go

go.mod:
	go mod init $(GO_PACKAGE)

toolchain: $(PROTOC)

$(PROTOC):
	make -C toolchain GO_PACKAGE=$(GO_PACKAGE)

clean:
	rm -f $(PROTOC_GO_FILES) greeter_client/main greeter_server/main
	make -C toolchain clean

distclean:
	rm -f $(PROTOC_GO_FILES) greeter_client/main greeter_server/main go.mod go.sum
	make -C toolchain distclean
