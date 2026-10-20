#!/bin/bash
# Builds both DuckDB files from the extracted JSON and registers them in a tql config
# private to this folder (./xdg), so your own tql connections and settings are untouched.
set -e
cd "$(dirname "$0")"
rm -f models.duckdb models-v2.duckdb
duckdb models.duckdb < load-v1.sql
duckdb models-v2.duckdb < load-v2.sql
export XDG_CONFIG_HOME="$PWD/xdg"
mkdir -p xdg/tql
tql config >/dev/null
sed -i.bak 's/^sql_height = 0/sql_height = 60/' xdg/tql/config.toml && rm -f xdg/tql/config.toml.bak
tql open models.duckdb --name=ollama-library --tag=local --no-interaction >/dev/null 2>&1 || true
tql open models-v2.duckdb --name=ollama-library-v2 --tag=local --no-interaction >/dev/null 2>&1 || true
tql connections | grep '"name"'
