#!/bin/bash
# usage: ask.sh <ollama-model> "<question>"  -> prints the SQL tql's AI drafted
cd "$(dirname "$0")"; export XDG_CONFIG_HOME="$PWD/xdg"; model="$1"; q="$2"; s="tqlask$$"
tmux new-session -d -s "$s" -x 220 -y 100 "XDG_CONFIG_HOME=$XDG_CONFIG_HOME TQL_AI_URL=http://localhost:11434/v1 TQL_AI_MODEL=$model TQL_AI_TIMEOUT=600 tql connect ${CONN:-ollama-library}"
sleep 3; tmux send-keys -t "$s" a; sleep 1; tmux send-keys -t "$s" -l "$q"; sleep 0.5
start=$(date +%s); tmux send-keys -t "$s" Enter
while sleep 2; do
  pane=$(tmux capture-pane -t "$s" -p)
  echo "$pane" | grep -q 'ctrl+r Run' && break
  [ $(( $(date +%s) - start )) -gt 600 ] && { echo "TIMEOUT"; break; }
done
echo "-- seconds: $(( $(date +%s) - start ))"
tmux capture-pane -t "$s" -p | awk '/\[3\] SQL/{f=1;next} f&&/╰/{exit} f' | sed -E 's/^│[^│]*│ │ ?//; s/ *│ *$//'
tmux kill-session -t "$s"
