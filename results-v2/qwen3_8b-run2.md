## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 21
-- The WHERE clause filters models that support vision and have a smallest size
-- of 8 billion parameters or smaller. The ORDER BY sorts them by pull count in
-- descending order, and LIMIT 10 returns the top 10 most pulled models.
--
SELECT name, total_pulls
FROM models
WHERE supports_vision = true
  AND smallest_size_billions_of_params <= 8.0
ORDER BY total_pulls DESC
LIMIT 10;
```

Model result:
```
+----------------+-------------+
| name           | total_pulls |
+----------------+-------------+
| gemma3         | 41300000    |
| qwen3.5        | 22900000    |
| llava          | 15200000    |
| qwen3-vl       | 6800000     |
| minicpm-v      | 5500000     |
| qwen2.5vl      | 5500000     |
| translategemma | 2700000     |
| llava-llama3   | 2300000     |
| moondream      | 2100000     |
| ministral-3    | 1500000     |
+----------------+-------------+
10 rows · 8ms
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
-- seconds: 13
-- The SELECT COUNT(*) counts all rows that meet the condition. The WHERE
-- clause filters models that support tools by checking if the boolean column
-- is true.
--
SELECT COUNT(*) FROM models WHERE "supports_tools" = true;
```

Model result:
```
+--------------+
| count_star() |
+--------------+
| 103          |
+--------------+
1 row · 6ms
```

Correct:
```
+--------------+
| count_star() |
+--------------+
| 103          |
+--------------+
1 row · 7ms
```

## q3: Which 5 embedding models have the most pulls?

```sql
-- seconds: 10
-- We select the name and total_pulls columns from the models table. We filter
-- to only include rows where is_embedding_model is true. Then we sort the
-- results in descending order by total_pulls to show the highest values first.
-- Finally, we limit the output to the top 5 rows.
--
SELECT name, total_pulls
FROM models
WHERE is_embedding_model = true
ORDER BY total_pulls DESC
LIMIT 5;
```

Model result:
```
+-------------------+-------------+
| name              | total_pulls |
+-------------------+-------------+
| nomic-embed-text  | 91800000    |
| mxbai-embed-large | 16000000    |
| bge-m3            | 7800000     |
| qwen3-embedding   | 4300000     |
| all-minilm        | 3800000     |
+-------------------+-------------+
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
-- seconds: 12
-- This query selects model names and descriptions updated in the last 7 days.
-- The WHERE clause filters for dates within the last 7 days by subtracting 7
-- days from today's date. The ORDER BY sorts the most recently updated models
-- first, and LIMIT 10 shows the top 10 results.
--
SELECT "name", "description" FROM models WHERE "last_updated_approx_date" >= CURRENT_DATE - INTERVAL '7 days' ORDER BY "last_updated_approx_date" DESC LIMIT 10;
```

Model result:
```
Binder Error: No function matches the given name and argument types '(DATE, INTERVAL)'. You might need to add explicit type casts.
	Candidate functions:


LINE 1: ..." FROM models WHERE "last_updated_approx_date" >= CURRENT_DATE - INTERVAL '7 days' ORDER BY "last_updated_approx_date"...
                                                                          ^
```

Correct:
```
+---------------------+
| name                |
+---------------------+
| beam                |
| bonsai-2            |
| clef                |
| clef-flash          |
| d1                  |
| d1-omni             |
| deepseek-v4.1-flash |
| embeddinggemma-2    |
| gemma3              |
| gemma3n             |
| gemma4              |
| glm-ocr             |
| gpt-oss             |
| kev                 |
| laya                |
| lfm2.5              |
| minimax-m3.1-flash  |
| muse-spark-open     |
| nemotron-3-nano     |
| nemotron-3.5-bolt   |
+---------------------+
33 rows · 5ms · showing the first 20
```

