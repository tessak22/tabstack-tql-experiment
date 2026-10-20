## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 6
-- SELECT is a clause that says we want to return a list of columns from the
-- database. In this case, we're only asking for the `pulls` column, so it's a
-- bit like asking for a specific file in a folder. We're enclosing the table
-- and column names in double quotes, which is required in duckdb.
--
SELECT pulls FROM "public"."models"
```

Model result:
```
Catalog Error: Table with name "public.models" does not exist because schema "public" does not exist.

LINE 1: SELECT pulls FROM "public"."models"
                          ^
```

Correct:
```
+----------------+
| name           |
+----------------+
| gemma3         |
| qwen3.5        |
| llava          |
| qwen3-vl       |
| minicpm-v      |
| qwen2.5vl      |
| translategemma |
| llava-llama3   |
| moondream      |
| ministral-3    |
+----------------+
10 rows · 5ms
```

## q2: How many models support tools?

```sql
-- seconds: 4
-- This query is a SELECT statement, which is used to retrieve data from the
-- database. The WITH clause is used to specify a temporary result set, in this
-- case with a custom capability. The WHERE clause filters the results to only
-- include models where 'tools' is in the capabilities array. The LIMIT clause
-- is used to restrict the number of results to 1.
--
-- The CAPABILITY_ENABLED = 'true' clause is used because the
-- capability_enabled column was never set. It would be nice to include an ELSE
-- COUNT(*) FROM models WHERE capability_enabled IS TRUE as well.
--
SELECT COUNT(*) FROM models WITH (CAPABILITY_ENABLED = 'true') WHERE capabilities @> ARRAY['tools'] LIMIT 1;
```

Model result:
```
Parser Error: syntax error at or near "WITH"

LINE 1: SELECT COUNT(*) FROM models WITH (CAPABILITY_ENABLED = 'true') WHERE capabilities @...
                                    ^
```

Correct:
```
+--------------+
| count_star() |
+--------------+
| 103          |
+--------------+
1 row · 5ms
```

## q3: Which 5 embedding models have the most pulls?

```sql
-- seconds: 2
-- 1. `SELECT`: This selects rows from the table, in this case the `name`
-- column from the `models` table. We want to show the names of the models, not
-- their whole details, so we only want 1 column.
--
SELECT name FROM "models" ORDER BY pulls DESC LIMIT 5;
```

Model result:
```
+------------------+
| name             |
+------------------+
| llama3.1         |
| deepseek-r1      |
| nomic-embed-text |
| llama3.2         |
| qwen2.5          |
+------------------+
5 rows · 5ms
```

Correct:
```
+-------------------+
| name              |
+-------------------+
| nomic-embed-text  |
| mxbai-embed-large |
| bge-m3            |
| qwen3-embedding   |
| all-minilm        |
+-------------------+
5 rows · 5ms
```

## q4: Which models were updated in the last 7 days?

```sql
-- seconds: 5
-- We're selecting (`SELECT`) only the `name` column from the `models` table.
-- The `WHERE` clause is filtering the results to show only rows where
-- `updated` is greater than the value of a parameter `:last_7_days`. We're
-- setting `:last_7_days` as the value we want to filter on, and this value
-- will be provided by the application. The `LIMIT` clause is limiting the
-- number of rows returned to 10.
--
SELECT name FROM models WHERE updated > :last_7_days LIMIT 10
```

Model result:
```
Parser Error: syntax error at or near ":"

LINE 1: SELECT name FROM models WHERE updated > :last_7_days LIMIT 10
                                                ^
```

Correct:
```
+------------------------+
| name                   |
+------------------------+
| beam                   |
| bonsai-2               |
| clef                   |
| clef-flash             |
| d1                     |
| d1-omni                |
| deepseek-v4.1-flash    |
| embeddinggemma-2       |
| gemma3n                |
| glm-ocr                |
| kev                    |
| laya                   |
| lfm2.5                 |
| minimax-m3.1-flash     |
| muse-spark-open        |
| nemotron-3-nano        |
| nemotron-3.5-bolt      |
| nemotron-3.5-lightning |
| nemotron-3.5-super     |
| nemotron-cascade-2     |
+------------------------+
26 rows · 5ms · showing the first 20
```

