ROOT = $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD_DIR = $(ROOT)/build
CHANNEL ?= canary
VERSION ?= $(shell git describe --tags --dirty  --always)
GOOS ?= $(shell ./bin/go version | awk '{print $$NF}' | cut -d/ -f1)
GOARCH ?= $(shell ./bin/go version | awk '{print $$NF}' | cut -d/ -f2)
BIN = $(BUILD_DIR)/gckd-$(GOOS)-$(GOARCH)

.PHONY: build

build:
	mkdir -p $(BIN)
	go build -tags musl -o $(BIN) ./
	gzip -9 -f $(BIN)/gorelease-kafka-demo

clean:
	rm -rf $(BUILD_DIR)