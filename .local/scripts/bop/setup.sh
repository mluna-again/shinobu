#! /usr/bin/env bash

: # bash 5+ required
# shellcheck disable=SC2120
die() { [ -n "$*" ] && tostderr "$*"; exit 1; }
info() { printf "%s\n" "$*"; }
tostderr() { tput setaf 1 && printf "%s@%s: %s\n" "$0" "${BASH_LINENO[-2]}" "$*" >&2; tput sgr0; }
assert_installed() { command -v "$1" &>/dev/null || die "$1 is not installed."; }

assert_installed go
assert_installed psql

# what an unfortunate prefix
declare DB="${PGDATABASE:-bop}" PUSER="${PGUSER:-postgres}" PASSWORD="${PGPASSWORD:-postgres}"

if ! command -v goose &>/dev/null; then
	echo installing goose...
	go install github.com/pressly/goose/v3/cmd/goose@latest &>/dev/null || die "could not install goose"
fi

if ! sudo -u "$PUSER" psql "$DB" -c "" &>/dev/null; then
	echo creating db...
	sudo -u "$PUSER" createdb "$DB" &>/dev/null || die "could not create database"
	sudo -u "$PUSER" psql -c "grant all privileges on database $DB to $PUSER" &>/dev/null || die "could not grant privileges to db"
fi

pgcreds="postgresql://$PUSER:$PASSWORD@${PGHOST:-localhost}:${PGPORT:-5432}/$DB"

echo running migrations...
GOOSE_DRIVER=postgres GOOSE_DBSTRING="$pgcreds" GOOSE_MIGRATION_DIR="$(pwd)/migrations" goose up &>/dev/null || die "Failed to run migrations with credentials: $pgcreds"

echo "all set, have fun!"
