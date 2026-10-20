## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 63
-- This query selects models with 'vision' in their capabilities and '8b' in
-- their sizes. The @> operator checks if the array contains the specified
-- value. It orders the results by pulls in descending order to show the most
-- popular models first, then limits the output to the top 10.
--
SELECT name, pulls FROM models
WHERE capabilities @> ARRAY['vision']
  AND sizes @> ARRAY['8b']
ORDER BY pulls DESC
LIMIT 10;
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
5 rows · 11ms
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
10 rows · 8ms
```

## q2: How many models support tools?

```sql
-- seconds: 10
-- The SELECT COUNT(*) gets the number of rows. The FROM models specifies the
-- table. The WHERE array_contains checks if 'tools' is in the capabilities
-- array.
--
SELECT COUNT(*) FROM models WHERE array_contains(capabilities, 'tools');
```

Model result:
```
+--------------+
| count_star() |
+--------------+
| 103          |
+--------------+
1 row · 5ms
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
-- seconds: 10
-- The SELECT clause gets the model names and their pull counts. ORDER BY sorts
-- them from highest to lowest pulls. LIMIT 5 shows only the top 5 results.
--
SELECT "name", "pulls" FROM models ORDER BY "pulls" DESC LIMIT 5;
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
5 rows · 5ms
```

## q4: Which models were updated in the last 7 days?

```sql
-- seconds: 19
-- CAST(updated AS DATE) converts the string date to a date type for
-- comparison. CURRENT_DATE - INTERVAL '7 days' calculates the date 7 days ago.
-- The WHERE clause filters models updated in the last 7 days. LIMIT 100
-- ensures we don't return too many rows at once.
--
SELECT name, description
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

