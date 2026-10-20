## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 10
-- This query selects the 'name' and 'total_pulls' columns from the 'models'
-- table. It filters the results to include only models that support vision
-- (supports_vision = true) and have a largest size of 8 billion parameters or
-- less (largest_size_billions_of_params <= 8). The results are then ordered by
-- the 'total_pulls' column in descending order, so that the models with the
-- most pulls appear first. The LIMIT 10 clause restricts the output to the top
-- 10 results.
--
SELECT name, total_pulls
FROM models
WHERE supports_vision = true
AND largest_size_billions_of_params <= 8
ORDER BY total_pulls DESC
LIMIT 10;
```

Model result:
```
+-------------------+-------------+
| name              | total_pulls |
+-------------------+-------------+
| minicpm-v         | 5500000     |
| llava-llama3      | 2300000     |
| moondream         | 2100000     |
| granite3.2-vision | 1000000     |
| bakllava          | 905900      |
| llava-phi3        | 726600      |
| deepseek-ocr      | 558800      |
| medgemma1.5       | 214400      |
| minicpm-v4.6      | 73900       |
| embeddinggemma-2  | 68900       |
+-------------------+-------------+
10 rows · 66ms
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
-- This query counts all the rows in the 'models' table where the
-- 'supports_tools' column is true. It gives us the total number of models that
-- support tools. The 'LIMIT 100' clause is added to limit the result to 100
-- rows, which is useful when dealing with large datasets to prevent
-- overwhelming the output.
--
SELECT count(*) AS models_supporting_tools FROM models WHERE supports_tools = true LIMIT 100;
```

Model result:
```
+-------------------------+
| models_supporting_tools |
+-------------------------+
| 103                     |
+-------------------------+
1 row · 6ms
```

Correct:
```
+--------------+
| count_star() |
+--------------+
| 103          |
+--------------+
1 row · 6ms
```

## q3: Which 5 embedding models have the most pulls?

```sql
-- seconds: 6
-- This query selects the 'name' and 'total_pulls' columns from the 'models'
-- table. It filters the results to include only those rows where the
-- 'is_embedding_model' column is true, meaning the model is an embedding
-- model. The results are then ordered by the 'total_pulls' column in
-- descending order, so the models with the most pulls come first. Finally, the
-- 'LIMIT 5' clause restricts the output to the top 5 rows.
--
SELECT name, total_pulls FROM models WHERE is_embedding_model = true ORDER BY total_pulls DESC LIMIT 5;
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
-- seconds: 7
-- This SQL query selects the `name` and `last_updated_approx_date` columns
-- from the `models` table. It filters the results to include only those models
-- where the `last_updated_approx_date` is within the last 7 days from the
-- current date. The `CURRENT_DATE` function retrieves today's date, and
-- `INTERVAL '7 days'` subtracts 7 days from it. The `WHERE` clause applies
-- this condition to filter the records. Finally, `LIMIT 10` restricts the
-- output to the first 10 records that meet this filter.
--
SELECT name, last_updated_approx_date FROM models WHERE last_updated_approx_date >= CURRENT_DATE - INTERVAL '7 days' LIMIT 10;
```

Model result:
```
Binder Error: No function matches the given name and argument types '(DATE, INTERVAL)'. You might need to add explicit type casts.
	Candidate functions:


LINE 1: ... FROM models WHERE last_updated_approx_date >= CURRENT_DATE - INTERVAL '7 days' LIMIT 10;
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
33 rows · 6ms · showing the first 20
```

