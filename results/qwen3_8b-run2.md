## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 53
-- The WHERE clause checks if 'vision' is in the capabilities array. The
-- subquery unnests the sizes array to check if any size has a numeric value <=
-- 8. Models are ordered by pulls in descending order, and the top 10 are
-- selected.
--
SELECT * FROM models WHERE 'vision' = ANY(capabilities) AND EXISTS (SELECT 1 FROM unnest(sizes) AS size WHERE split_part(size, 'b', 1)::int <= 8) ORDER BY pulls DESC LIMIT 10;
```

Model result:
```
Binder Error: No function matches the given name and argument types 'string_split(STRUCT(unnest VARCHAR), STRING_LITERAL)'. You might need to add explicit type casts.
	Candidate functions:
	string_split(VARCHAR, VARCHAR) -> VARCHAR[]


LINE 1: ...'vision' = ANY(capabilities) AND EXISTS (SELECT 1 FROM unnest(sizes) AS size WHERE split_part(size, 'b', 1)::int <= 8)...
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
-- seconds: 33
-- The query counts all rows in the models table where the 'capabilities' array
-- contains 'tools'. ANY checks if the value exists in the array. COUNT(*)
-- returns the total number of matching rows.
--
SELECT COUNT(*) FROM models WHERE 'tools' = ANY(capabilities);
```

Model result:
```
+--------------+
| count_star() |
+--------------+
| 103          |
+--------------+
1 row · 7ms
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
-- seconds: 13
-- This query selects the model names and their pull counts. The ORDER BY
-- clause sorts them from highest to lowest pulls. The LIMIT 5 clause ensures
-- only the top 5 results are returned.
--
SELECT "name", "pulls"
FROM "models"
ORDER BY "pulls" DESC
LIMIT 5;
```

Model result:
```
+------------------+-----------+
| name             | pulls     |
+------------------+-----------+
| llama3.1         | 120400000 |
| deepseek-r1      | 93900000  |
| nomic-embed-text | 91700000  |
| llama3.2         | 85800000  |
| qwen2.5          | 43000000  |
+------------------+-----------+
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
5 rows · 6ms
```

## q4: Which models were updated in the last 7 days?

```sql
-- seconds: 17
-- The query selects model names and their last updated dates. It filters to
-- show only models updated within the last 7 days by comparing the updated
-- date (cast as a date) to the current date minus 7 days. The LIMIT 100
-- ensures a manageable number of results are returned.
--
SELECT name, updated
FROM models
WHERE CAST(updated AS DATE) >= CURRENT_DATE - INTERVAL '7 days'
LIMIT 100;
```

Model result:
```
Binder Error: No function matches the given name and argument types '(DATE, INTERVAL)'. You might need to add explicit type casts.
	Candidate functions:


LINE 3: WHERE CAST(updated AS DATE) >= CURRENT_DATE - INTERVAL '7 days'
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

