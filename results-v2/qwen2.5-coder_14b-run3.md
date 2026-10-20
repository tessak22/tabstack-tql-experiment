## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 10
-- This SQL query selects all columns from the 'models' table where the model
-- supports vision and its largest size in billions of parameters is 8 or
-- smaller. The results are then ordered by the 'total_pulls' column in
-- descending order. Finally, the query limits the results to the top 10 rows.
-- This will provide the top 10 models that meet the specified criteria and
-- have the highest number of pulls.
--
SELECT *
FROM models
WHERE supports_vision = true
AND largest_size_billions_of_params <= 8
ORDER BY total_pulls DESC
LIMIT 10;
```

Model result:
```
+-------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------+-----------------+-------------------+--------------------+----------------+----------------------------------+---------------------------------+-------------------------------+-------------+-----------+--------------------------+
| name              | description                                                                                                                                                                                                 | supports_tools | supports_vision | supports_thinking | is_embedding_model | is_cloud_model | smallest_size_billions_of_params | largest_size_billions_of_params | size_tags                     | total_pulls | tag_count | last_updated_approx_date |
+-------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------+-----------------+-------------------+--------------------+----------------+----------------------------------+---------------------------------+-------------------------------+-------------+-----------+--------------------------+
| minicpm-v         | A series of multimodal LLMs (MLLMs) designed for vision-language understanding.                                                                                                                             | false          | true            | false             | false              | false          | 8                                | 8                               | ["8b"]                        | 5500000     | 17        | 2025-10-20               |
| llava-llama3      | A LLaVA model fine-tuned from Llama 3 Instruct with better scores in several benchmarks.                                                                                                                    | false          | true            | false             | false              | false          | 8                                | 8                               | ["8b"]                        | 2300000     | 4         | 2024-10-20               |
| moondream         | moondream2 is a small vision language model designed to run efficiently on edge devices.                                                                                                                    | false          | true            | false             | false              | false          | 1.8                              | 1.8                             | ["1.8b"]                      | 2100000     | 18        | 2024-10-20               |
| granite3.2-vision | A compact and efficient vision-language model, specifically designed for visual document understanding, enabling automated content extraction from tables, charts, infographics, plots, diagrams, and more. | true           | true            | false             | false              | false          | 2                                | 2                               | ["2b"]                        | 1000000     | 5         | 2025-10-20               |
| bakllava          | BakLLaVA is a multimodal model consisting of the Mistral 7B base model augmented with the LLaVA architecture.                                                                                               | false          | true            | false             | false              | false          | 7                                | 7                               | ["7b"]                        | 905900      | 17        | 2024-10-20               |
| llava-phi3        | A new small LLaVA model fine-tuned from Phi 3 Mini.                                                                                                                                                         | false          | true            | false             | false              | false          | 3.8                              | 3.8                             | ["3.8b"]                      | 726600      | 4         | 2024-10-20               |
| deepseek-ocr      | DeepSeek-OCR is a vision-language model that can perform token-efficient OCR.                                                                                                                               | false          | true            | false             | false              | false          | 3                                | 3                               | ["3b"]                        | 558800      | 3         | 2025-11-24               |
| medgemma1.5       | MedGemma 1.5 4B is an updated version of the MedGemma 4B model.                                                                                                                                             | false          | true            | false             | false              | false          | 4                                | 4                               | ["4b"]                        | 214400      | 5         | 2026-04-23               |
| minicpm-v4.6      | A Pocket-Sized MLLM for Ultra-Efficient Image and Video Understanding on Your Phone                                                                                                                         | false          | true            | false             | false              | false          | 1                                | 1                               | ["1b"]                        | 73900       | 13        | 2026-06-22               |
| embeddinggemma-2  | EmbeddingGemma 2 is a multimodal embedding model from Google built on the Gemma 4 architecture.                                                                                                             | false          | true            | false             | true               | false          | 0.27                             | 0.74                            | ["270m","440m","570m","740m"] | 68900       | 21        | 2026-10-15               |
+-------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------+-----------------+-------------------+--------------------+----------------+----------------------------------+---------------------------------+-------------------------------+-------------+-----------+--------------------------+
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
-- seconds: 4
-- This query counts the number of rows in the 'models' table where the
-- 'supports_tools' column is true. The COUNT(*) function counts all rows that
-- meet the condition, and the result is labeled as 'count'. This gives us the
-- total number of models that support tools.
--
SELECT COUNT(*) AS count FROM models WHERE supports_tools = true
```

Model result:
```
+-------+
| count |
+-------+
| 103   |
+-------+
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
-- This query selects the name and description of the 5 embedding models that
-- have the most total pulls. It filters the models table to include only those
-- models where is_embedding_model is true. Then, it orders the results by
-- total_pulls in descending order, so the models with the highest pulls come
-- first. Finally, it limits the results to the top 5.
--
SELECT name, description, total_pulls
FROM models
WHERE is_embedding_model = TRUE
ORDER BY total_pulls DESC
LIMIT 5;
```

Model result:
```
+-------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-------------+
| name              | description                                                                                                                                          | total_pulls |
+-------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-------------+
| nomic-embed-text  | A high-performing open embedding model with a large token context window.                                                                            | 91800000    |
| mxbai-embed-large | State-of-the-art large embedding model from mixedbread.ai                                                                                            | 16000000    |
| bge-m3            | BGE-M3 is a new model from BAAI distinguished for its versatility in Multi-Functionality, Multi-Linguality, and Multi-Granularity.                   | 7800000     |
| qwen3-embedding   | Building upon the foundational models of the Qwen3 series, Qwen3 Embedding provides a comprehensive range of text embeddings models in various sizes | 4300000     |
| all-minilm        | Embedding models on very large sentence level datasets.                                                                                              | 3800000     |
+-------------------+------------------------------------------------------------------------------------------------------------------------------------------------------+-------------+
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
-- This query selects the name, description, and last_updated_approx_date
-- columns from the models table. It filters the results to include only those
-- models that were updated in the last 7 days by using the WHERE clause. The
-- condition last_updated_approx_date >= CURRENT_DATE - INTERVAL '7 days'
-- checks if the last_updated_approx_date is within the last 7 days. The LIMIT
-- 100 clause restricts the output to 100 rows, which is a common practice to
-- prevent overwhelming the user with too much data at once.
--
SELECT name, description, last_updated_approx_date
FROM models
WHERE last_updated_approx_date >= CURRENT_DATE - INTERVAL '7 days'
LIMIT 100;
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

