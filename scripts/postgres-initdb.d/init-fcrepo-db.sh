#!/usr/bin/env bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE DATABASE fcrepo;
	GRANT ALL PRIVILEGES ON DATABASE fcrepo TO "$POSTGRES_USER";
EOSQL