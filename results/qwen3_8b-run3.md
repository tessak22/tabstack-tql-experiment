## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 67
-- The query selects models with 'vision' in their capabilities. It checks if
-- any size in the sizes array is less than or equal to '8b'. Results are
-- ordered by pulls in descending order, and limited to 10 rows.
--
SELECT * FROM models
WHERE 'vision' = ANY(capabilities)
AND ANY(sizes <= '8b')
ORDER BY pulls DESC
LIMIT 10;
```

Model result:
```
Parser Error: syntax error at or near "ANY"

LINE 3: AND ANY(sizes <= '8b')
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
10 rows · 16ms
```

## q2: How many models support tools?

```sql
-- seconds: 23
-- The query counts how many models have 'tool' in their capabilities array.
-- The @> operator checks if the array contains the value 'tool'. This gives
-- the total number of models that support tools.
--
SELECT COUNT(*) FROM models WHERE capabilities @> ARRAY['tool'];

-- Count the number of models that have 'tool' in their capabilities array. The @> operator checks if the array contains the specified value. This gives the total count of models supporting
tools.
```

Model result:
```
Only read-only statements are allowed here: select, show, explain, describe, pragma or with, one at a time. Change data in the tql interface.
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
-- seconds: 8
-- The WHERE clause filters models that have 'embedding' in their capabilities
-- array. The ORDER BY sorts them by pull count descending. LIMIT 5 returns the
-- top 5 results.
--
SELECT name, pulls
FROM models
WHERE capabilities @> ARRAY['embedding'::varchar]::varchar[]
ORDER BY pulls DESC
LIMIT 5;
```

Model result:
```
+-------------------+----------+
| name              | pulls    |
+-------------------+----------+
| nomic-embed-text  | 91700000 |
| mxbai-embed-large | 16000000 |
| bge-m3            | 7800000  |
| qwen3-embedding   | 4300000  |
| all-minilm        | 3800000  |
+-------------------+----------+
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
5 rows · 5ms
```

## q4: Which models were updated in the last 7 days?

```sql
-- seconds: 14
-- The query selects model names and their update dates. It filters for models
-- updated within the last 7 days by comparing the updated date to today's date
-- minus 7 days. The LIMIT 10 clause ensures only 10 results are returned.
--
SELECT name, updated
FROM models
WHERE CAST(updated AS DATE) >= CURRENT_DATE - INTERVAL '7 days'
LIMIT 10;
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

