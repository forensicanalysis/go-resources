.PHONY: install
install:
	@echo "Installing..."
	go install github.com/bombsimon/wsl/v4/cmd...@v4.4.1
	go install mvdan.cc/gofumpt@v0.6.0
	go install github.com/daixiang0/gci@v0.13.4

.PHONY: generate
generate:
	@echo "Generating..."
	go generate ./...

.PHONY: fmt
fmt: generate
	@echo "Formatting..."
	go mod tidy
	go fmt ./...
	gci write -s standard -s default -s "prefix(github.com/forensicanalysis/go-resources)" .
	gofumpt -l -w .
	wsl -fix ./... || true

.PHONY: lint
lint: generate
	golangci-lint version
	golangci-lint run --config .golangci.yml ./...

.PHONY: test
test: generate
	@echo "Testing..."
	go test -v ./...
