# Tabstack + DuckDB + tql with local models: experiment findings

Run 2026-10-20 on an Apple Silicon Mac. tql 0.17.0, DuckDB 1.5.6, tabstack-cli, Ollama.

## Pipeline

1. `tabstack extract json https://ollama.com/library --schema @schema.json` returns all 257 models as JSON (78s v1 schema, 131s v2 schema).
2. DuckDB loads the JSON with `read_json` + `unnest` (about 10 lines of SQL).
3. `tql open models.duckdb` browses, sorts, and filters the table.
4. tql's AI prompt (`a`) drafts SQL with a local Ollama model:
   `TQL_AI_URL=http://localhost:11434/v1 TQL_AI_MODEL=qwen3:8b tql connect ollama-library`

tql sends the model a system prompt naming the dialect ("a single SQL query for a duckdb database"), its rules (including "Add a limit unless the question is an aggregate"), and the schema as table names, column names, and column types. It sends no row values and no column comments (tested with `COMMENT ON COLUMN`). Captured request: `tql-ai-request-sample.json`. (tql's settings text says "Only table and column names are sent, never rows"; the request also carries types.)

## Test

4 questions, 3 local models, 3 runs each, drafted through the tql TUI (driven by tmux, `ask.sh`), scored by running the drafted SQL against a known-correct query (`score.py`).

- q1 Top 10 vision models available in 8b or smaller, by pulls
- q2 How many models support tools?
- q3 Which 5 embedding models have the most pulls?
- q4 Which models were updated in the last 7 days?

Two table designs from the same page:

- **v1, raw:** `capabilities` (list of tags), `sizes` (list of strings), `pulls`, `updated` (text like "3 weeks ago")
- **v2, self-describing:** `supports_tools`, `supports_vision`, `supports_thinking`, `is_embedding_model`, `is_cloud_model` (booleans, from the Tabstack schema), `smallest_size_billions_of_params`, `largest_size_billions_of_params`, `total_pulls`, `last_updated_approx_date` (computed at load from the relative label and the extraction date)

## Results (correct out of 12; q4 scored with tql's default LIMIT removed)

| Model | v1 raw | v2 self-describing | Avg seconds per draft (v2) |
|---|---|---|---|
| qwen3:8b | 3/12 | 10/12 | 13 |
| qwen2.5-coder:14b | 3/12 | 10/12 | 7 |
| llama3.1:8b | 0/12 | 3/12 | 5 |

Without removing the LIMIT, v2 scores are qwen3:8b 8/12, qwen2.5-coder:14b 8/12, llama3.1:8b 3/12.

## Observations

- On v1, no model passed q1 or q4 in any run. The models saw `capabilities varchar[]`, `sizes varchar[]`, and `updated varchar`, but no values. They filtered `sizes @> ['8b']` (exact tag) for "8b or smaller", ignored `capabilities` for "embedding", and compared the `updated` text to dates.
- On v2, qwen3:8b passed q1 3/3. qwen2.5-coder:14b passed q1 1/3; its misses used `largest_size_billions_of_params <= 8`, a different reading of "comes in a size of 8b or smaller".
- tql's system prompt says "Add a limit unless the question is an aggregate." The models chose `LIMIT 10`. For q4 (33 matching rows on v2) that truncated otherwise-correct SQL.
- llama3.1:8b produced many SQL errors on both tables: Postgres-only syntax, `public.models` schema prefix, nonexistent functions.
- Every draft was visible in tql's SQL pane before running, with a comment explaining the query.
- DuckDB allows one read-write process per file. While tql had the `.duckdb` file open, a second `tql query` on the same file failed with a lock error.
- `extract json` returned `null`, never `false`, for all 1,285 boolean values; the `true` values matched the v1 capability tags on all 257 rows. Coalesced to `false` at load. Filed as a DX note.
- Pull counts and update labels changed between the two extractions (about two hours apart), so each version is scored against its own data.

## Files

`schema.json`, `schema-v2.json`, `library.json`, `library-v2.json`, `models.duckdb`, `models-v2.duckdb`, `ask.sh`, `run.sh`, `score.py`, `questions.tsv`, `questions-v2.tsv`, `results/`, `results-v2/`
