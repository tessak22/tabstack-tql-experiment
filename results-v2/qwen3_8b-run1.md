## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 16
-- This query selects model names and their pull counts. It filters for models
-- that support vision and have a smallest size of 8 billion parameters or
-- smaller. The results are sorted to show the most popular models first, then
-- limited to the top 10.
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
10 rows · 9ms
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
-- seconds: 10
-- The SELECT COUNT(*) counts all rows that meet the condition. The FROM models
-- specifies which table to look in. The WHERE clause filters rows to only
-- those where the supports_tools column is true.
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
1 row · 4ms
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
-- seconds: 12
-- This query selects the names and total pulls of embedding models. It filters
-- to include only rows where is_embedding_model is true. The results are
-- sorted in descending order of total_pulls to show the most pulled models
-- first, then limited to 5 rows.
--
SELECT "name" , "total_pulls "
FROM "models"
WHERE "is_embedding_model" = true
ORDER BY "total_pulls " DESC
LIMIT 5;
```

Model result:
```
Binder Error: Referenced column "total_pulls " not found in FROM clause!
Candidate bindings: "total_pulls", "tag_count", "supports_tools", "last_updated_approx_date", "is_cloud_model"

LINE 1: SELECT "name" , "total_pulls "
                        ^
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
-- The query selects model names and descriptions updated in the last 7 days.
-- It filters rows where the last update date is within the last week, sorts
-- them by date to show the most recent first, and limits results to 10 rows
-- for efficiency.
--
SELECT name, description
FROM models
WHERE last_updated_approx_date >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY last_updated_approx_date DESC
LIMIT 10;
```

Model result:
```
Binder Error: No function matches the given name and argument types '(DATE, INTERVAL)'. You might need to add explicit type casts.
	Candidate functions:


LINE 3: WHERE last_updated_approx_date >= CURRENT_DATE - INTERVAL '7 days'
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

