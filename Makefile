SHELL := /usr/bin/env bash

include .env
export $(shell sed 's/=.*//' .env)

export GOBIN ?= $(shell pwd)/bin
DBMATE = $(GOBIN)/dbmate
SQLC = $(GOBIN)/sqlc
PROTOC_GEN_GO = $(GOBIN)/protoc-gen-go
BUF = $(GOBIN)/buf
PROTOC_GEN_GO_VTPROTO = $(GOBIN)/protoc-gen-go-vtproto
PROTOC_GEN_GO_GRPC = $(GOBIN)/protoc-gen-go-grpc

PROTO_TOOLS = $(BUF) $(PROTOC_GEN_GO) $(PROTOC_GEN_GO_VTPROTO) $(PROTOC_GEN_GO_GRPC)

run-server:
	go run pkg/main.go

start-db:
	docker-compose $(PARAMS) up -d
	until docker-compose exec -T db pg_isready -U $(POSTGRES_USER) -d $(POSTGRES_DB) ; do \
		printf '.' ; \
		sleep 5 ; \
	done

db-lint: $(SQLC)
	$(SQLC) vet -f schema/sqlc.yaml

db-schema: $(SQLC)
	$(SQLC) generate -f schema/sqlc.yaml

db-migrations: $(DBMATE) start-db
	$(DBMATE) --url "$(NEERAJ_DATABASE_URL)" --migrations-dir "schema/migrations" --migrations-table "migrations" --no-dump-schema up

db-rollback-last: $(DBMATE)
	$(DBMATE) --url "$(NEERAJ_DATABASE_URL)" --migrations-dir "schema/migrations" --migrations-table "migrations" --no-dump-schema rollback

buildprotos: $(PROTO_TOOLS)
	@echo generating pb.go files
	@rm -rf protos/gen/go/*
	@cd protos && $(BUF) generate && protoc --go-grpc_out=./gen/go --go-grpc_opt=paths=source_relative store_feedback.proto

protos: buildprotos
	@mkdir -p pkg/pb
	@rm -f pkg/pb/*.go
	@pwd
	@mv protos/gen/go/*.go ./pkg/pb/

$(BUF): go.mod
	go install github.com/bufbuild/buf/cmd/buf

$(DBMATE): go.mod
	go install github.com/amacneil/dbmate

$(SQLC): go.mod
	go install -tags=nowasm github.com/sqlc-dev/sqlc/cmd/sqlc

$(PROTOC_GEN_GO): go.mod
	go install google.golang.org/protobuf/cmd/protoc-gen-go

$(PROTOC_GEN_GO_VTPROTO): go.mod
	go install github.com/planetscale/vtprotobuf/cmd/protoc-gen-go-vtproto

$(PROTOC_GEN_GO_GRPC): go.mod
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

