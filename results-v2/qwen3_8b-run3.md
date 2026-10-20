## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 14
-- Filter models that support vision and have smallest size ≤8b. Sort by pull
-- count descending to find the most popular ones. Limit to top 10 results.
--
SELECT "name", "total_pulls"
FROM "models"
WHERE "supports_vision" = true
  AND "smallest_size_billions_of_params" <= 8
ORDER BY "total_pulls" DESC
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
10 rows · 5ms
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
-- seconds: 12
-- The SELECT COUNT(*) counts all rows. The FROM models specifies the table.
-- The WHERE supports_tools = true filters only the rows where the model
-- supports tools.
--
SELECT COUNT(*) FROM models WHERE supports_tools = true;
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
1 row · 4ms
```

## q3: Which 5 embedding models have the most pulls?

```sql
-- seconds: 11
-- This query selects the names and pull counts of models that are embedding
-- models. It sorts them by pull count in descending order to show the most
-- popular ones first, then limits the result to the top 5.
--
SELECT name, total_pulls
FROM models
WHERE is_embedding_model
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
-- seconds: 8
-- The WHERE clause filters models updated in the last 7 days by comparing
-- their last_updated_approx_date to today's date minus 7 days. DATEADD(day,
-- -7, CURRENT_DATE) calculates the cutoff date. LIMIT 100 ensures we don't
-- return too many rows at once.
--
SELECT * FROM models
WHERE last_updated_approx_date >= DATEADD(day, -7, CURRENT_DATE)
LIMIT 100;
```

Model result:
```
Catalog Error: Scalar Function with name dateadd does not exist!
Did you mean "date_add"?

LINE 2: WHERE last_updated_approx_date >= DATEADD(day, -7, CURRENT_DATE)
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

