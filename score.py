import json, re, subprocess, glob, collections
truth = {}
import os
DB=os.environ.get('DB','models.duckdb'); RES=os.environ.get('RES','results')
for line in open(os.environ.get('QFILE','questions.tsv')):
    i, q, t = line.rstrip('\n').split('\t'); truth[i] = t
def run(sql):
    p = subprocess.run(['duckdb', '-readonly', '-json', DB, '-c', sql], capture_output=True, text=True)
    if p.returncode or 'Error' in p.stderr: return None, (p.stderr or p.stdout).strip().splitlines()[0][:90]
    try: rows = json.loads(p.stdout.strip() or '[]')
    except ValueError: return None, 'unparseable output: ' + p.stdout.strip()[:80]
    return rows, None
def key(rows, qid):
    if qid == 'q2': return [list(r.values())[0] for r in rows][:1]
    vals = [r.get('name') for r in rows]
    return sorted(vals) if qid == 'q4' else vals
score = collections.defaultdict(lambda: collections.Counter()); notes = []
for f in sorted(glob.glob(RES+'/*-run*.md')):
    model = re.sub(r'-run\d+\.md$', '', f.split('/')[-1])
    for qid, block in re.findall(r'## (q\d):.*?```sql\n(.*?)```', open(f).read(), re.S):
        secs = re.search(r'-- seconds: (\d+)', block).group(1)
        sql = '\n'.join(l for l in block.splitlines() if not l.startswith('--'))
        if os.environ.get('STRIP_Q4_LIMIT') and qid=='q4': sql=re.sub(r'(?i)\s+limit\s+\d+\s*;?\s*$','',sql.strip())
        got, err = run(sql); want, _ = run(truth[qid])
        ok = err is None and key(got, qid) == key(want, qid)
        score[model][qid] += ok; score[model]['secs'] += int(secs)
        if not ok: notes.append(f"{model} {qid}: {err or f'{len(got)} rows, wrong'}")
for m, c in score.items():
    print(f"{m}: " + ' '.join(f"{q}={c[q]}/3" for q in ['q1','q2','q3','q4']) + f"  total={sum(c[q] for q in ['q1','q2','q3','q4'])}/12  avg {c['secs']/12:.0f}s/question")
print(); print('\n'.join(notes))
