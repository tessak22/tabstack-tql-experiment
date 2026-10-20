## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 12
-- First, we're selecting specific columns from the "models" table: the
-- description and name of the models, and two counts: the total number of
-- pulls for each model, and the number of tags for each model. This is done
-- using "SELECT", which gets specific data from a database table. The data is
-- being taken only from the "models" table, which has the table name escaped
-- with double quotes to handle the special character "", so in Eloquent it
-- would be a Models Table. The "FROM" specifies which table to select from.
-- Next, we're filtering the data to only include rows where the model has
-- vision ("supports_vision = TRUE"), which is done using "WHERE". This only
-- gives us models that can see. We're also limiting the data to models that
-- are small or smaller (size of 8b or smaller), done by saying "<= 8" in the
-- "WHERE" clause. The "<= 8" is comparing the
-- "smallest_size_billions_of_params" column value and only returning rows
-- whose value is equal to or lower than 8. Finally, we're ordering the results
-- by the number of pulls for each model, so the ones with the most pulls
-- appear first. This is done using "ORDER BY". The last step is specifying
-- that we only want the top 10 of these models, which is done with "LIMIT 10".
--
-- This will return the top 10 models with vision capability that come in a
-- size of 8b or smaller, sorted by the number of pulls each model has. If the
-- question also asked to get rid of the smallest models first, you would add
-- "ASC" to that same "ORDER BY" clause to sort ascending, so "ASC" doesn't fit
-- into this case.
--
SELECT t1.description, t1.name, COUNT(t1.total_pulls) AS total_pulls, t1.tag_count FROM "models" AS t1 WHERE t1.supports_vision = TRUE AND t1.smallest_size_billions_of_params <= 8 ORDER BY
t1.total_pulls DESC LIMIT 10;
```

Model result:
```
Binder Error: column "description" must appear in the GROUP BY clause or must be part of an aggregate function.
Either add it to the GROUP BY list, or use "ANY_VALUE(description)" if the exact value of "description" is not important.

LINE 1: SELECT t1.description, t1.name, COUNT(t1.total_pulls) AS total_pulls...
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
10 rows · 5ms
```

## q2: How many models support tools?

```sql
-- seconds: 4
-- The `SELECT` clause tells the database to return a list of results. In this
-- case, we're only interested in counting how many models support tools, so we
-- use `COUNT(*)`. The `WHERE` clause filters the results to only show models
-- where `supports_tools` is `TRUE`. This is the `condition` that is applied to
-- the `COUNT`. The `LIMIT` clause sets a limit on the number of results to
-- return, in this case only return the first record, which gives us the count.
--
SELECT COUNT(*) FROM "models" WHERE supports_tools = TRUE LIMIT 1
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
-- seconds: 2
-- This query is selecting rows from the `models` table.
--
SELECT models.* FROM models WHERE is_embedding_model = 1 LIMIT 5 ORDER BY total_pulls DESC;
```

Model result:
```
Parser Error: syntax error at or near "ORDER"

LINE 1: ... models.* FROM models WHERE is_embedding_model = 1 LIMIT 5 ORDER BY total_pulls DESC;
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
-- seconds: 5
-- SELECT: This tells DuckDB to return rows from the database. *: This is a
-- wildcard that means return all columns for each row. FROM models: This tells
-- DuckDB to read from the 'models' table. WHERE: This clause filters the rows
-- to only include those that match the condition. is_cloud_model = false: This
-- filters to models that are not cloud models, i.e. models stored locally.
-- last_updated_approx_date >= CURRENT_DATE - INTERVAL '7 DAY': This filters to
-- models that were last updated more than 7 days ago, but note that
-- 'approx_date' is potentially a string that represents a date, depending on
-- the database schema.
--
SELECT * FROM models WHERE `is_cloud_model` = false AND `last_updated_approx_date` >= CURRENT_DATE - INTERVAL '7 DAY' LIMIT 10;
```

Model result:
```
Catalog Error: Scalar Function with name `__postfix does not exist!
Did you mean "!__postfix"?

LINE 1: SELECT * FROM models WHERE `is_cloud_model` = false AND `last_updated_approx_date` >= CURRENT_DATE...
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

