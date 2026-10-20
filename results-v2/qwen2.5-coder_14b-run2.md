## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 10
-- This query selects the name, description, vision support status, smallest
-- size in billions of parameters, and total pulls for models that support
-- vision and have a smallest size of 8 billion parameters or less. The results
-- are ordered by the total pulls in descending order, and the top 10 results
-- are returned.
--
SELECT name, description, supports_vision, smallest_size_billions_of_params, total_pulls
FROM models
WHERE supports_vision = TRUE AND smallest_size_billions_of_params <= 8.0
ORDER BY total_pulls DESC
LIMIT 10;
```

Model result:
```
+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------+----------------------------------+-------------+
| name           | description                                                                                                                                                                            | supports_vision | smallest_size_billions_of_params | total_pulls |
+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------+----------------------------------+-------------+
| gemma3         | The current, most capable model that runs on a single GPU.                                                                                                                             | true            | 0.27                             | 41300000    |
| qwen3.5        | Qwen 3.5 is a family of open-source multimodal models that delivers exceptional utility and performance.                                                                               | true            | 0.8                              | 22900000    |
| llava          | 🌋 LLaVA is a novel end-to-end trained large multimodal model that combines a vision encoder and Vicuna for general-purpose visual and language understanding. Updated to version 1.6. | true            | 7                                | 15200000    |
| qwen3-vl       | The most powerful vision-language model in the Qwen model family to date.                                                                                                              | true            | 2                                | 6800000     |
| minicpm-v      | A series of multimodal LLMs (MLLMs) designed for vision-language understanding.                                                                                                        | true            | 8                                | 5500000     |
| qwen2.5vl      | Flagship vision-language model of Qwen and also a significant leap from the previous Qwen2-VL.                                                                                         | true            | 3                                | 5500000     |
| translategemma | A new collection of open translation models built on Gemma 3, helping people communicate across 55 languages.                                                                          | true            | 4                                | 2700000     |
| llava-llama3   | A LLaVA model fine-tuned from Llama 3 Instruct with better scores in several benchmarks.                                                                                               | true            | 8                                | 2300000     |
| moondream      | moondream2 is a small vision language model designed to run efficiently on edge devices.                                                                                               | true            | 1.8                              | 2100000     |
| ministral-3    | The Ministral 3 family is designed for edge deployment, capable of running on a wide range of hardware.                                                                                | true            | 3                                | 1500000     |
+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------+----------------------------------+-------------+
10 rows · 6ms
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
-- seconds: 6
-- This query counts the number of models that support tools. The SELECT
-- COUNT(*) clause is used to get the total number of rows that match the
-- condition. The FROM models clause specifies the table to query. The WHERE
-- supports_tools = TRUE condition filters the rows to only include models that
-- support tools. The LIMIT 1 clause is used to ensure that the query returns
-- only one result, which in this case is the total count.
--
SELECT COUNT(*) FROM models WHERE supports_tools = TRUE LIMIT 1;
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
-- seconds: 6
-- This query selects the names and total pulls of models that are embedding
-- models. It filters the models to include only those where
-- `is_embedding_model` is true. The results are then ordered by the
-- `total_pulls` column in descending order, showing the models with the most
-- pulls first. The `LIMIT 5` clause restricts the output to the top 5 models.
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
-- seconds: 6
-- This query selects the `name` and `last_updated_approx_date` columns from
-- the `models` table. It filters the rows to include only those where the
-- `last_updated_approx_date` is within the last 7 days from the current date.
-- The `CURRENT_DATE - INTERVAL '7 days'` expression calculates the date that
-- is 7 days before the current date. The `LIMIT 10` clause restricts the
-- result set to 10 rows to make it more manageable for reading.
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
33 rows · 5ms · showing the first 20
```

