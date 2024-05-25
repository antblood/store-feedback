SHELL := /usr/bin/env bash

include .env
export $(shell sed 's/=.*//' .env)

export GOBIN ?= $(shell pwd)/bin
DBMATE = $(GOBIN)/dbmate
SQLC = $(GOBIN)/sqlc
TOOLS = $(DBMATE)

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


$(DBMATE): go.mod
	go install github.com/amacneil/dbmate

$(SQLC): go.mod
	go install -tags=nowasm github.com/sqlc-dev/sqlc/cmd/sqlc
