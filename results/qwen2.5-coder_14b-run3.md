## q1: Top 10 models with vision capability that come in a size of 8b or smaller, by pulls

```sql
-- seconds: 6
-- This query selects the name, description, capabilities, sizes, pulls,
-- tag_count, and updated columns from the models table. It filters the results
-- to include only those models that have 'vision' in their capabilities array
-- and have a size of '8b' or smaller. The results are then ordered by the
-- pulls column in descending order, so the models with the most pulls appear
-- first. The limit clause restricts the output to the top 10 results.
--
SELECT name, description, capabilities, sizes, pulls, tag_count, updated FROM models WHERE 'vision' = ANY(capabilities) AND sizes <= '8b' ORDER BY pulls DESC LIMIT 10;
```

Model result:
```
Conversion Error: Type VARCHAR with value '8b' can't be cast to the destination type VARCHAR[]

LINE 1: ... FROM models WHERE 'vision' = ANY(capabilities) AND sizes <= '8b' ORDER BY pulls DESC LIMIT 10;
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
-- seconds: 6
-- The SELECT count(*) clause counts the number of rows returned by the query.
-- The FROM models clause specifies that the data is being pulled from the
-- models table. The WHERE 'tools' = ANY(capabilities) clause filters the rows
-- to only include those where 'tools' is present in the capabilities array.
-- The LIMIT 10 clause limits the number of rows returned to 10.
--
SELECT count(*) FROM models WHERE 'tools' = ANY(capabilities) LIMIT 10;
```

Model result:
```
+--------------+
| count_star() |
+--------------+
| 103          |
+--------------+
1 row · 7ms
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
-- This query selects the 'name' column from the 'models' table. It orders the
-- results by the 'pulls' column in descending order, so the models with the
-- most pulls come first. The 'LIMIT 5' clause restricts the output to the top
-- 5 rows.
--
SELECT name FROM models ORDER BY pulls DESC LIMIT 5;
```

Model result:
```
+------------------+
| name             |
+------------------+
| llama3.1         |
| deepseek-r1      |
| nomic-embed-text |
| llama3.2         |
| qwen2.5          |
+------------------+
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
-- This query selects the 'name' column from the 'models' table. It filters the
-- rows to include only those where the 'updated' column value is within the
-- last 7 days from the current timestamp. The 'LIMIT 10' clause restricts the
-- output to 10 rows, making it easier to read.
--
SELECT name FROM models WHERE updated >= (CURRENT_TIMESTAMP - INTERVAL '7 days') LIMIT 10;
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


LINE 1: ...ELECT name FROM models WHERE updated >= (CURRENT_TIMESTAMP - INTERVAL '7 days') LIMIT 10;
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

