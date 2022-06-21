ROOT = $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD_DIR = $(ROOT)/build
CHANNEL ?= canary
VERSION ?= $(shell git describe --tags --dirty  --always)
GOOS ?= $(shell ./bin/go version | awk '{print $$NF}' | cut -d/ -f1)
GOARCH ?= $(shell ./bin/go version | awk '{print $$NF}' | cut -d/ -f2)
BIN = $(BUILD_DIR)/gckd-$(GOOS)-$(GOARCH)

PACKAGE_NAME          := github.com/kalfonso/goreleaser-cross-kafka-demo
GOLANG_CROSS_VERSION  ?= v1.17.6

.PHONY: build release

build:
	mkdir -p $(BIN)
	go build -tags musl -o $(BIN) ./
	gzip -9 -f $(BIN)/gorelease-kafka-demo

release:
	docker run \
		--rm \
		-e CGO_ENABLED=1 \
		-e GITHUB_TOKEN=$(GITHUB_TOKEN)
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v `pwd`:/go/src/$(PACKAGE_NAME) \
		-w /go/src/$(PACKAGE_NAME) \
		goreleaser/goreleaser-cross:${GOLANG_CROSS_VERSION} \
		release --rm-dist

clean:
	rm -rf $(BUILD_DIR)