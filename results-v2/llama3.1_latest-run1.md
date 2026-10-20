## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 6
-- The WHERE clause filters the models to only include those with vision
-- capability, are 8b parameters or smaller, and have vision capability. This
-- clause filters out all models that don't meet these requirements. The ORDER
-- BY clause sorts the remaining models by the total number of pulls in
-- descending order, so the models with the most pulls come first. The LIMIT
-- clause limits the result to the top 10 models.
--
SELECT models.name as name, models.supports_vision as supports_vision, models.total_pulls as total_pulls  FROM public.models  WHERE supports_vision = 't' AND
models(smallest_size_billions_of_params)  <= 8  ORDER BY total_pulls DESC LIMIT 10;
```

Model result:
```
Catalog Error: Table with name "public.models" does not exist because schema "public" does not exist.

LINE 1: ... as supports_vision, models.total_pulls as total_pulls  FROM public.models  WHERE supports_vision = 't' AND
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
10 rows · 6ms
```

## q2: How many models support tools?

```sql
-- seconds: 4
-- SELECT: We want to retrieve only specific information from the database. In
-- this case, we want to count how many rows in the `models` table have
-- `supports_tools` set to true. Essentially, we want to get the total number
-- of models that support tools. The information we want is the `name` of these
-- models, but since we are counting them, we don't really care about the name
-- itself, so we can just use `COUNT(name)` to count them. It's like counting
-- how many students are taking a math class, rather than actually caring about
-- the names of those students. Because this query is asking for a single
-- answer (a count), SQL lets us know how many are found with LIMIT 1.
--
SELECT COUNT(name) FROM `models` WHERE supports_tools = TRUE LIMIT 1
```

Model result:
```
Parser Error: syntax error at or near "`"

LINE 1: SELECT COUNT(name) FROM `models` WHERE supports_tools = TRUE LIMIT 1
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
-- seconds: 6
-- SELECT: We're asking for select rows we want to see. It returns data (in
-- this case, names and pulls) that we can use. What comes after SELECT is what
-- we're selecting: the 'm' alias of 'models' table for 'name' and
-- 'total_pulls' column, but without an alias is the same as using the table or
-- column name directly.
--
-- The SELECT clause comes first, followed by the FROM clause. The FROM clause
-- specifies the table(s) we want to work with. In this case, it's the 'models'
-- table, which we're aliasing as 'm' for brevity. The table is only used when
-- we reference its name and columns, using the 'm.' prefix. We filter out
-- models with no pulls using the WHERE clause. The ORDER BY clause tells
-- DuckDB to sort our result by total_pulls in descending order (highest
-- first). We're applying the LIMIT clause to limit our results to the top 5
-- models.
--
SELECT m.name, m.total_pulls FROM models AS m WHERE m.is_embedding_model AND m.total_pulls > 0 ORDER BY m.total_pulls DESC LIMIT 5;
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
5 rows · 6ms
```

## q4: Which models were updated in the last 7 days?

```sql
-- seconds: 4
-- This query is selecting the name column from the models table. It's doing
-- this by creating a temporary table called T1 with only the name column from
-- models, to keep the rest of the columns out of the selection (WITH). The
-- WHERE clause is then applying a condition to only include models that were
-- updated after a certain date. This date is calculated by subtracting 7 days
-- from the current date (CURRENT_DATE - INTEGER '7') and comparing it to the
-- last_updated_approx_date column in the models table.
--
SELECT name FROM models  WITH T1(name) AS name WHERE last_updated_approx_date >= (CURRENT_DATE - INTEGER '7')
```

Model result:
```
Parser Error: syntax error at or near "WITH"

LINE 1: SELECT name FROM models  WITH T1(name) AS name WHERE last_updated_approx_date >=...
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

