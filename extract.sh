#!/bin/bash
# Re-extracts the Ollama library with Tabstack. Needs TABSTACK_API_KEY. Overwrites library*.json.
set -e
cd "$(dirname "$0")"
tabstack extract json https://ollama.com/library --schema @schema.json -o json > library.json
tabstack extract json https://ollama.com/library --schema @schema-v2.json -o json > library-v2.json
