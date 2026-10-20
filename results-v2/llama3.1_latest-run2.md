## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 8
-- 1. `SELECT name FROM` : Retrieving only the `name` column from the `models`
-- table. Think of this like selecting the column headers you need for the data
-- you want to retrieve. You're only interested in the names of the models, so
-- you select the `name` column specifically. The `FROM` keyword tells the
-- database where to look for the data: the `models` table. (Note: The `SELECT
-- *` you might be familiar with from Eloquent can quickly get out of hand in
-- plain SQL, as it grabs all columns, whether you need them or not. The
-- `SELECT name FROM` is much more concise and efficient.)
--
-- If this were a write query, we would need to know what action needs to be
-- taken on the models: what would trigger the update or insertion that would
-- affect the 'pulls' count?
--
SELECT name FROM models WHERE supports_vision = TRUE AND largest_size_billions_of_params <= 8 ORDER BY total_pulls DESC LIMIT 10;
```

Model result:
```
+-------------------+
| name              |
+-------------------+
| minicpm-v         |
| llava-llama3      |
| moondream         |
| granite3.2-vision |
| bakllava          |
| llava-phi3        |
| deepseek-ocr      |
| medgemma1.5       |
| minicpm-v4.6      |
| embeddinggemma-2  |
+-------------------+
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
-- seconds: 2
-- This query asks for the number of rows in the models table where
-- `supports_tools` is True.
--
-- Here, we're using a parameterized query, which is like Eloquent's bindings.
-- The `:` before the column name indicates it's a parameter.
--
SELECT count(*) AS count FROM models WHERE supports_tools = :supportstools
```

Model result:
```
Parser Error: syntax error at or near ":"

LINE 1: ...ELECT count(*) AS count FROM models WHERE supports_tools = :supportstools
                                                                      ^
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
-- seconds: 2
-- SELECT is choosing rows from the models table. WHERE is filtering the rows
-- to only get the rows where is_embedding_model is true. ORDER BY is sorting
-- the rows in descending order by the total_pulls column. LIMIT is saying to
-- only return the first 5 rows.
--
SELECT name FROM models WHERE is_embedding_model = TRUE ORDER BY total_pulls DESC LIMIT 5;
```

Model result:
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
-- seconds: 2
-- This query selects all columns (*) from the "models" table.
--
SELECT * FROM "models" WHERE last_updated_approx_date > ?
```

Model result:
```
Wrong number of parameters passed to query. Got 0, needed 1
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

