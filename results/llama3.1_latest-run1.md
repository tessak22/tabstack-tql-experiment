## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 11
-- WITH is used to divide a big query into smaller, reusable parts. We're
-- calling it 'models_with_vision' and it will return all rows where the
-- capability of 'vision' exists in the array. The @> symbol means 'contains',
-- it's a way of checking if one value is contained within another value for
-- arrays.
--
-- The capabilities column is an array, so we need to use the @> operator to
-- check if 'vision' exists within it. The sizes column is also an array, so we
-- need to use [8b] instead of '8b' when creating the array of sizes to look
-- for. No writing is required, just reading.
--
WITH models_with_vision AS (SELECT name, pulls FROM models WHERE capabilities @> ARRAY['vision']::varchar[]), models_with_size AS (SELECT name, sizes FROM models WHERE sizes @>
'[8b]'::varchar[]), models_with_vision_and_size AS (SELECT m.name, m.pulls FROM models_with_vision m INNER JOIN models_with_size m2 ON m.name = m2.name), ranked_models AS (SELECT name,
pulls FROM models_with_vision_and_size ORDER BY pulls DESC LIMIT 10) SELECT name, pulls FROM ranked_models;
```

Model result:
```
+--------------+---------+
| name         | pulls   |
+--------------+---------+
| qwen3-vl     | 6800000 |
| minicpm-v    | 5500000 |
| llava-llama3 | 2300000 |
| ministral-3  | 1500000 |
| minicpm-v4.5 | 58300   |
+--------------+---------+
5 rows · 8ms
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
10 rows · 6ms
```

## q2: How many models support tools?

```sql
-- seconds: 2
-- We're doing a 'count' operation which will return the total number of rows
-- that match our condition. We're looking at the 'capabilities' column of the
-- 'models' table. The condition for matching is that the column value starts
-- with 'tools'.
--
SELECT COUNT(*) FROM(models) WHERE capabilities GLOB '%tools%'
```

Model result:
```
Parser Error: syntax error at or near ")"

LINE 1: SELECT COUNT(*) FROM(models) WHERE capabilities GLOB '%tools%'
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
-- seconds: 4
-- This query selects the column 'name' (which is the name of the model) from
-- the table 'models'. It orders the results by the number of 'pulls' in
-- descending order, so the models with the most pulls are at the top. The
-- 'LIMIT 5' clause means it will only return the top 5 models, so it won't
-- load and return the entire table if there are more than 5 models with the
-- most pulls.
--
SELECT name FROM models ORDER BY pulls DESC LIMIT 5;
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
5 rows · 6ms
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
5 rows · 6ms
```

## q4: Which models were updated in the last 7 days?

```sql
-- seconds: 4
-- SELECT is selecting all columns (`*`) from the tables in this database
-- (`models`). WHERE is filtering this selection to only models whose `updated`
-- column is within the last 7 days. Note: `EXTRACT` is used to convert the
-- date in the `updated` column into an epoch timestamp that can be compared
-- with the current timestamp, and `EXTRACT(EPOCH FROM ...)` is used to get
-- just the epoch part. LIMIT is to only show at most 10 models.
--
SELECT * FROM models WHERE EXTRACT(EPOCH FROM updated) > EXTRACT(EPOCH FROM CURRENT_TIMESTAMP()) - 604800 LIMIT 10
```

Model result:
```
Binder Error: No function matches the given name and argument types 'date_part(STRING_LITERAL, VARCHAR)'. You might need to add explicit type casts.
	Candidate functions:
	date_part(VARCHAR[], DATE) -> STRUCT()
	date_part(VARCHAR[], INTERVAL) -> STRUCT()
	date_part(VARCHAR[], TIME) -> STRUCT()
	date_part(VARCHAR[], TIMESTAMP) -> STRUCT()
	date_part(VARCHAR[], TIME WITH TIME ZONE) -> STRUCT()
	date_part(VARCHAR[], TIME_NS) -> STRUCT()
	date_part(VARCHAR, DATE) -> BIGINT
	date_part(VARCHAR, INTERVAL) -> BIGINT
	date_part(VARCHAR, TIME) -> BIGINT
	date_part(VARCHAR, TIMESTAMP) -> BIGINT
	date_part(VARCHAR, TIME WITH TIME ZONE) -> BIGINT
	date_part(VARCHAR, TIME_NS) -> BIGINT
	date_part(VARCHAR[], TIMESTAMP WITH TIME ZONE) -> STRUCT()
	date_part(VARCHAR, TIMESTAMP WITH TIME ZONE) -> BIGINT


LINE 1: SELECT * FROM models WHERE EXTRACT(EPOCH FROM updated) > EXTRACT(EPOCH FROM CURRENT_TI...
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

