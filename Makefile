.PHONY: clean check test build fmt

export GO111MODULE=on

SRCS = $(shell git ls-files '*.go' | grep -v '^vendor/')

TAG_NAME := $(shell git tag -l --contains HEAD)
SHA := $(shell git rev-parse HEAD)
VERSION := $(if $(TAG_NAME),$(TAG_NAME),$(SHA))

default: clean check test build

clean:
	rm -rf dist/ builds/ cover.out

build: clean
	@echo Version: $(VERSION)
	GO111MODULE=on go build -v -ldflags '-X "main.version=${VERSION}"'

test: clean
	go test -v -cover ./...

check:
	golangci-lint run

generate:
	go generate

fmt:
	gofmt -s -l -w $(SRCS)
