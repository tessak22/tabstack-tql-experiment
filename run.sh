#!/bin/bash
# usage: [CONN=ollama-library-v2 QFILE=questions-v2.tsv SUFFIX=-v2] run.sh <ollama-model> [run-number]
cd "$(dirname "$0")"; export XDG_CONFIG_HOME="$PWD/xdg"; m="$1"; out="results${SUFFIX}/${m//[:\/]/_}-run${2:-1}.md"; mkdir -p results${SUFFIX}; : > "$out"
while IFS=$'\t' read -r id q truth; do
  sql=$(./ask.sh "$m" "$q")
  body=$(echo "$sql" | grep -v '^-- ' | grep -v '^--$' | grep -v '^\s*$')
  { echo "## $id: $q"; echo; echo '```sql'; echo "$sql"; echo '```'; echo; echo "Model result:"; echo '```';
    echo "$body" | tql query ${CONN:-ollama-library} --table --limit 20 2>&1; echo '```'; echo; echo "Correct:"; echo '```';
    tql query ${CONN:-ollama-library} "$truth" --table --limit 20 2>&1; echo '```'; echo; } >> "$out"
done < ${QFILE:-questions.tsv}
echo "$out"
