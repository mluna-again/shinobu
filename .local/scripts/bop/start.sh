#! /usr/bin/env sh

# DO NOT CHANGE
export GOOSE_DRIVER=postgres
export GOOSE_DBSTRING=$DATABASE_URL
export GOOSE_MIGRATION_DIR=/app/migrations

goose up || exit
bop serve
