## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 4
-- WITH is used here to create a temp view called `vision_models` which we will
-- work with for our final result. It gives us a result set that we can
-- reference by name, without polluting the full table
--
WITH
```

Model result:
```
Parser Error: syntax error at end of input
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
-- SELECT means we're going to return just one number, which is the count of
-- rows from the next part of the query.
--
SELECT COUNT(name) FROM models WHERE TRSPLIT(capabilities, ',') @> 'tools'
```

Model result:
```
Catalog Error: Scalar Function with name trsplit does not exist!
Did you mean "split"?

LINE 1: SELECT COUNT(name) FROM models WHERE TRSPLIT(capabilities, ',') @> 'tools'
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
-- seconds: 4
-- A `SELECT` statement is used to retrieve specific columns of data
-- (`models.name`, `models.pulls`, and `models.tag_count`) from the `models`
-- table. The `ORDER BY` clause is used to sort the results in descending order
-- (`DESC`) so that the models with the most pulls are listed first. The
-- `LIMIT` clause is used to limit the number of results returned to the top 5
-- models.
--
SELECT models.name, models.pulls, models.tag_count FROM models ORDER BY models.pulls DESC LIMIT 5
```

Model result:
```
+------------------+-----------+-----------+
| name             | pulls     | tag_count |
+------------------+-----------+-----------+
| llama3.1         | 120400000 | 93        |
| deepseek-r1      | 93900000  | 35        |
| nomic-embed-text | 91700000  | 3         |
| llama3.2         | 85800000  | 63        |
| qwen2.5          | 43000000  | 133       |
+------------------+-----------+-----------+
5 rows · 8ms
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
-- seconds: 4
-- This SELECT statement is asking for the names of models. The WHERE clause is
-- looking at the 'updated' column to find rows where the date is newer than
-- one week ago (today minus 7 days). The `>` operator means 'greater than',
-- and this means it will return all the rows where the `updated` date is more
-- recent than one week ago.
--
SELECT name FROM models WHERE updated > (CURRENT_DATE - INTERVAL '7 days')
```

Model result:
```
Binder Error: No function matches the given name and argument types '(DATE, INTERVAL)'. You might need to add explicit type casts.
	Candidate functions:


LINE 1: SELECT name FROM models WHERE updated > (CURRENT_DATE - INTERVAL '7 days')
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

