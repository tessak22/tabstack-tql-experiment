# Tabstack + DuckDB + tql with local models

Can a model you run locally answer plain-English questions about live web data? This repo extracts the [Ollama model library](https://ollama.com/library) with [Tabstack](https://tabstack.ai), loads it into DuckDB, and asks [tql](https://github.com/VheissuLabs/tql)'s AI prompt to draft the SQL with a local Ollama model. Every drafted query is scored against a known-correct one.

The two qwen models go from 3 of 12 correct to 10 of 12 when the extraction schema produces columns whose names say what's in them. Full results: [FINDINGS.md](FINDINGS.md).

| Model | Raw table | Self-describing table |
|---|---|---|
| qwen3:8b | 3/12 | 10/12 |
| qwen2.5-coder:14b | 3/12 | 10/12 |
| llama3.1:8b | 0/12 | 3/12 |

4 questions × 3 runs per model. The self-describing scores count q4 with tql's default `LIMIT` removed; counted as drafted, the qwen models score 8/12.

## What's here

| File | What |
|---|---|
| `schema.json`, `schema-v2.json` | The two `extract.json` schemas: raw tags, and self-describing booleans |
| `library.json`, `library-v2.json` | The extracted data (257 models each) |
| `extract.sh` | Re-runs both extractions (needs `TABSTACK_API_KEY`) |
| `load-v1.sql`, `load-v2.sql` | Load the JSON into DuckDB |
| `setup.sh` | Builds both `.duckdb` files and registers them with tql in a config private to this folder |
| `questions.tsv`, `questions-v2.tsv` | Question, then the correct SQL for each table |
| `ask.sh` | Drives the tql TUI in tmux: asks one question, prints the drafted SQL |
| `run.sh` | Runs every question for one model and writes `results*/` |
| `score.py` | Runs each drafted query and compares it to the correct answer |
| `results/`, `results-v2/` | Every draft and its output from our runs |
| `tql-ai-request-sample.json` | A captured request tql sends the model, system prompt included |

## Run it

Needs [tql](https://github.com/VheissuLabs/tql), DuckDB, tmux, [Ollama](https://ollama.com), and Python 3. Re-extracting also needs [tabstack-cli](https://github.com/Mozilla-Ocho/tabstack-cli) and a [Tabstack API key](https://console.tabstack.ai/signup).

```bash
brew install vheissulabs/tap/tql duckdb tmux
ollama pull qwen3:8b

./setup.sh                                   # build the DuckDB files, register them with tql
XDG_CONFIG_HOME=$PWD/xdg TQL_AI_URL=http://localhost:11434/v1 TQL_AI_MODEL=qwen3:8b \
  tql connect ollama-library-v2              # browse, then press a to ask a question

./run.sh qwen3:8b 1                          # raw table, run 1
CONN=ollama-library-v2 QFILE=questions-v2.tsv SUFFIX=-v2 ./run.sh qwen3:8b 1
python3 score.py                             # score results/
DB=models-v2.duckdb RES=results-v2 QFILE=questions-v2.tsv python3 score.py
STRIP_Q4_LIMIT=1 DB=models-v2.duckdb RES=results-v2 QFILE=questions-v2.tsv python3 score.py
```

`./extract.sh` pulls fresh data. The page changes daily, so the correct answers change with it; re-run `setup.sh` after extracting, and update the date in `load-v2.sql` (`extracted_on`), since `last_updated_approx_date` is computed from the page's relative labels ("3 weeks ago").

## Notes

- `extract.json` returned `null` rather than `false` for boolean fields that were not in `required`, so `load-v2.sql` coalesces them. With the booleans added to `required` (`schema-v3-required.json`), every value came back `true` or `false` (`library-v3-required.json`).
- tql opens DuckDB files read-write, and DuckDB allows one writer per file, so close tql before running `score.py`.
- tql sends the model the table names, column names, and column types, never row values. That is why the column names matter.
