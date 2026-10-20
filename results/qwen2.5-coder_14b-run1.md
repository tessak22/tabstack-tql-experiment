## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 18
-- This query selects the top 10 models that have the 'vision' capability and
-- come in a size of '8b' or smaller, ranking them by the number of pulls in
-- descending order.
--
-- - `SELECT name, description, capabilities, sizes, pulls_label, pulls,
-- tag_count, updated`: This part of the query specifies the columns we want to
-- retrieve from the `models` table.
--
-- - `FROM models`: This indicates that the data should be taken from the
-- `models` table.
--
-- - `WHERE 'vision' = ANY(capabilities)`: This condition filters the models to
-- include only those that have the 'vision' capability. The `ANY` operator
-- checks if 'vision' is present in the array of capabilities.
--
-- - `AND '8b' >= ALL(sizes)`: This additional condition ensures that only
-- models that come in a size of '8b' or smaller are selected. The `ALL`
-- operator checks that '8b' is greater than or equal to all sizes in the
-- array.
--
-- - `ORDER BY pulls DESC`: This sorts the results in descending order based on
-- the number of pulls, so the models with the most pulls appear first.
--
-- - `LIMIT 10`: This limits the output to the top 10 models after sorting.
--
SELECT name, description, capabilities, sizes, pulls_label, pulls, tag_count, updated
FROM models
WHERE 'vision' = ANY(capabilities)
AND '8b' >= ALL(sizes)
ORDER BY pulls DESC
LIMIT 10;
```

Model result:
```
+------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------------+-------------+----------+-----------+--------------+
| name             | description                                                                                                                                                                            | capabilities                  | sizes                               | pulls_label | pulls    | tag_count | updated      |
+------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------------+-------------+----------+-----------+--------------+
| gemma3           | The current, most capable model that runs on a single GPU.                                                                                                                             | ["vision"]                    | ["270m","1b","4b","12b","27b"]      | 41.3M       | 41300000 | 29        | 1 week ago   |
| llava            | 🌋 LLaVA is a novel end-to-end trained large multimodal model that combines a vision encoder and Vicuna for general-purpose visual and language understanding. Updated to version 1.6. | ["vision"]                    | ["7b","13b","34b"]                  | 15.2M       | 15200000 | 98        | 2 years ago  |
| glm-ocr          | GLM-OCR is a multimodal OCR model for complex document understanding, built on the GLM-V encoder–decoder architecture.                                                                 | ["vision","tools"]            | NULL                                | 8.5M        | 8500000  | 3         | 6 days ago   |
| qwen3.6          | Qwen3.6 delivers substantial upgrades in agentic coding and thinking preservation than previous Qwen models.                                                                           | ["vision","tools","thinking"] | ["27b","35b"]                       | 7.2M        | 7200000  | 35        | 1 week ago   |
| qwen3-vl         | The most powerful vision-language model in the Qwen model family to date.                                                                                                              | ["vision","tools","thinking"] | ["2b","4b","8b","30b","32b","235b"] | 6.8M        | 6800000  | 57        | 13 hours ago |
| minicpm-v        | A series of multimodal LLMs (MLLMs) designed for vision-language understanding.                                                                                                        | ["vision"]                    | ["8b"]                              | 5.5M        | 5500000  | 17        | 1 year ago   |
| qwen2.5vl        | Flagship vision-language model of Qwen and also a significant leap from the previous Qwen2-VL.                                                                                         | ["vision"]                    | ["3b","7b","32b","72b"]             | 5.5M        | 5500000  | 17        | 1 year ago   |
| qwen3.8          | Qwen3.8 delivers substantial gains across coding, professional work, research, and long-horizon agentic tasks.                                                                         | ["vision","tools","thinking"] | ["27b"]                             | 4.4M        | 4400000  | 12        | 3 weeks ago  |
| translategemma   | A new collection of open translation models built on Gemma 3, helping people communicate across 55 languages.                                                                          | ["vision"]                    | ["4b","12b","27b"]                  | 2.7M        | 2700000  | 13        | 9 months ago |
| mistral-small3.2 | An update to Mistral Small that improves on function calling, instruction following, and less repetition errors.                                                                       | ["vision","tools"]            | ["24b"]                             | 2.5M        | 2500000  | 5         | 1 year ago   |
+------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------------+-------------+----------+-----------+--------------+
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
10 rows · 6ms
```

## q2: How many models support tools?

```sql
-- seconds: 6
-- This query counts the number of models that support tools. The SELECT
-- count(*) part tells SQL to count the rows that match the condition. The FROM
-- models part specifies that we are looking in the models table. The WHERE
-- 'tools' = ANY(capabilities) part checks if the 'tools' capability is present
-- in the capabilities array for each model. The = ANY operator is used to
-- check for the presence of an element in an array. The result is returned as
-- model_count.
--
SELECT count(*) AS model_count FROM models WHERE 'tools' = ANY(capabilities);
```

Model result:
```
+-------------+
| model_count |
+-------------+
| 103         |
+-------------+
1 row · 6ms
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
-- SELECT name, pulls: This part of the query specifies that we want to
-- retrieve the 'name' and 'pulls' columns from the 'models' table. These are
-- the columns that will be shown in the output.
--
-- FROM models: This clause indicates that the data should be fetched from the
-- 'models' table, which contains the information about different models.
--
-- ORDER BY pulls DESC: This clause sorts the results by the 'pulls' column in
-- descending order. 'DESC' means descending, so models with the highest number
-- of pulls will appear first.
--
-- LIMIT 5: This clause restricts the output to the first 5 rows of the sorted
-- results. Since the results are sorted by the number of pulls in descending
-- order, these 5 rows will be the models with the most pulls.
--
SELECT name, pulls FROM models ORDER BY pulls DESC LIMIT 5;
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
-- seconds: 7
-- This query selects the 'name' column from the 'models' table. It filters the
-- rows to include only those where the 'updated' column value is within the
-- last 7 days from the current date and time. The 'NOW() - INTERVAL '7 days''
-- part calculates the date and time that was 7 days ago. The LIMIT 10 clause
-- restricts the result to the first 10 rows.
--
SELECT name FROM models WHERE updated >= NOW() - INTERVAL '7 days' LIMIT 10;
```

Model result:
```
Binder Error: No function matches the given name and argument types '-(TIMESTAMP WITH TIME ZONE, INTERVAL)'. You might need to add explicit type casts.
	Candidate functions:
	-(TINYINT) -> TINYINT
	-(TINYINT, TINYINT) -> TINYINT
	-(SMALLINT) -> SMALLINT
	-(SMALLINT, SMALLINT) -> SMALLINT
	-(INTEGER) -> INTEGER
	-(INTEGER, INTEGER) -> INTEGER
	-(BIGINT) -> BIGINT
	-(BIGINT, BIGINT) -> BIGINT
	-(HUGEINT) -> HUGEINT
	-(HUGEINT, HUGEINT) -> HUGEINT
	-(FLOAT) -> FLOAT
	-(FLOAT, FLOAT) -> FLOAT
	-(DOUBLE) -> DOUBLE
	-(DOUBLE, DOUBLE) -> DOUBLE
	-(DECIMAL) -> DECIMAL
	-(DECIMAL, DECIMAL) -> DECIMAL
	-(UTINYINT) -> UTINYINT
	-(UTINYINT, UTINYINT) -> UTINYINT
	-(USMALLINT) -> USMALLINT
	-(USMALLINT, USMALLINT) -> USMALLINT
	-(UINTEGER) -> UINTEGER
	-(UINTEGER, UINTEGER) -> UINTEGER
	-(UBIGINT) -> UBIGINT
	-(UBIGINT, UBIGINT) -> UBIGINT
	-(UHUGEINT) -> UHUGEINT
	-(UHUGEINT, UHUGEINT) -> UHUGEINT
	-(BIGNUM) -> BIGNUM
	-(BIGNUM, BIGNUM) -> BIGNUM
	-(DATE, DATE) -> BIGINT
	-(DATE, INTEGER) -> DATE
	-(TIMESTAMP, TIMESTAMP) -> INTERVAL
	-(INTERVAL, INTERVAL) -> INTERVAL
	-(DATE, INTERVAL) -> TIMESTAMP
	-(TIME, INTERVAL) -> TIME
	-(TIMESTAMP, INTERVAL) -> TIMESTAMP
	-(TIME WITH TIME ZONE, INTERVAL) -> TIME WITH TIME ZONE
	-(INTERVAL) -> INTERVAL


LINE 1: SELECT name FROM models WHERE updated >= NOW() - INTERVAL '7 days' LIMIT 10;
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

