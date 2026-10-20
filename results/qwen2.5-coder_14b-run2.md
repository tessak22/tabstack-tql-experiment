## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 8
-- This query selects the top 10 models from the 'models' table. It filters the
-- models to include only those that have 'vision' in their capabilities and
-- either do not specify a size in billions (b) or specify a size of 8 billion
-- or smaller (like 1b, 2b, ..., 8b). The results are sorted by the number of
-- pulls in descending order, so the models with the most pulls appear first.
-- The 'LIMIT 10' clause ensures that only the top 10 results are returned.
--
SELECT name, description, capabilities, sizes, pulls_label, pulls, tag_count, updated FROM models WHERE 'vision' = ANY(capabilities) AND sizes !~ '.*[0-9]+b.*' OR sizes ~
'^[^0-9]*[1-7]b[^0-9]*$' ORDER BY pulls DESC LIMIT 10;
```

Model result:
```
Binder Error: No function matches the given name and argument types 'regexp_full_match(VARCHAR[], STRING_LITERAL)'. You might need to add explicit type casts.
	Candidate functions:
	regexp_full_match(VARCHAR, VARCHAR) -> BOOLEAN
	regexp_full_match(VARCHAR, VARCHAR, VARCHAR) -> BOOLEAN

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
-- This query counts the number of models that have 'tools' listed in their
-- capabilities. The FROM clause specifies the 'models' table. The WHERE clause
-- filters the rows to include only those where 'tools' is present in the
-- 'capabilities' array. The count(*) function then counts the number of such
-- rows.
--
SELECT count(*) FROM models WHERE 'tools' = ANY(capabilities);
```

Model result:
```
+--------------+
| count_star() |
+--------------+
| 103          |
+--------------+
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
-- seconds: 4
-- This query selects the name and pulls columns from the models table. It
-- orders the results by the pulls column in descending order, so that models
-- with the most pulls appear first. The LIMIT clause limits the results to the
-- top 5 rows.
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
5 rows · 5ms
```

## q4: Which models were updated in the last 7 days?

```sql
-- seconds: 6
-- SELECT name, updated FROM models: This part of the query selects the `name`
-- and `updated` columns from the `models` table. WHERE updated > NOW() -
-- INTERVAL '7 days': This condition filters the rows to only include those
-- where the `updated` column is later than the current time minus 7 days.
-- LIMIT 10: This limits the number of rows returned to 10.
--
SELECT name, updated FROM models WHERE updated > NOW() - INTERVAL '7 days' LIMIT 10;
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


LINE 1: SELECT name, updated FROM models WHERE updated > NOW() - INTERVAL '7 days' LIMIT 10;
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

