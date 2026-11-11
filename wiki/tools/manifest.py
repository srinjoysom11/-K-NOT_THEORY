#!/usr/bin/env python
"""Track which PDFs have been folded into the wiki.

    python wiki/tools/manifest.py status     # list NEW / CHANGED / MISSING / per-state counts
    python wiki/tools/manifest.py sync       # add newly found PDFs as state=todo, refresh hashes of known ones
    python wiki/tools/manifest.py set KEY STATE [note]   # STATE: todo | extracted | integrated

Source of truth: wiki/manifest.json  (one record per PDF, keyed by repo-relative path).
Citation keys come from wiki/tools/sources.tsv (key <TAB> batch <TAB> path); a PDF that is
not listed there shows up as NEW with key=None until someone assigns it a key in sources.tsv.

States
    todo        found on disk, nothing done
    extracted   wiki/_extracts/<Key>.md exists (faithful parse) but topic pages do not use it yet
    integrated  its results are cited from the topic pages (see SOURCES.md for where)
"""
import hashlib, json, os, sys, datetime

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
MAN = os.path.join(ROOT, 'wiki', 'manifest.json')
SRC = os.path.join(ROOT, 'wiki', 'tools', 'sources.tsv')
SKIP_DIRS = {'wiki', '.git', '.claude', '.vscode'}


def sha1(path):
    h = hashlib.sha1()
    with open(path, 'rb') as f:
        for chunk in iter(lambda: f.read(1 << 20), b''):
            h.update(chunk)
    return h.hexdigest()


def find_pdfs():
    out = []
    for d, dirs, files in os.walk(ROOT):
        dirs[:] = [x for x in dirs if x not in SKIP_DIRS]
        for f in files:
            if f.lower().endswith('.pdf'):
                out.append(os.path.relpath(os.path.join(d, f), ROOT).replace('\\', '/'))
    return sorted(out)


def keys():
    k = {}
    if os.path.exists(SRC):
        for line in open(SRC, encoding='utf8').read().splitlines()[1:]:
            p = line.split('\t')
            if len(p) >= 3:
                k[p[2]] = p[0]
    return k


def load():
    return json.load(open(MAN, encoding='utf8')) if os.path.exists(MAN) else {}


def save(m):
    json.dump(m, open(MAN, 'w', encoding='utf8'), indent=1, sort_keys=True)


def status(m):
    disk, k = find_pdfs(), keys()
    new = [p for p in disk if p not in m]
    missing = [p for p in m if p not in disk]
    changed = [p for p in disk if p in m and m[p]['sha1'] != sha1(os.path.join(ROOT, p))]
    counts = {}
    for p, r in m.items():
        counts[r['state']] = counts.get(r['state'], 0) + 1
    print('PDFs on disk: %d   in manifest: %d   states: %s' % (len(disk), len(m), counts))
    for label, lst in (('NEW (not in manifest)', new), ('CHANGED (hash differs)', changed), ('MISSING (in manifest, not on disk)', missing)):
        print('\n%s: %d' % (label, len(lst)))
        for p in lst:
            print('   %s   key=%s' % (p, k.get(p)))
    pend = [(r.get('key'), p) for p, r in m.items() if r['state'] != 'integrated']
    print('\nNOT YET INTEGRATED: %d' % len(pend))
    for key, p in sorted(pend, key=lambda x: str(x)):
        print('   [%s] %s  (%s)' % (key, p, m[p]['state']))
    ext = os.path.join(ROOT, 'wiki', '_extracts')
    noext = [r['key'] for r in m.values() if r.get('key') and not os.path.exists(os.path.join(ext, r['key'] + '.md'))]
    if noext:
        print('\nNO EXTRACT FILE: ' + ', '.join(sorted(noext)))


def sync(m):
    k = keys()
    for p in find_pdfs():
        full = os.path.join(ROOT, p)
        rec = m.get(p, {'state': 'todo', 'added': datetime.date.today().isoformat(), 'note': ''})
        rec.update(sha1=sha1(full), bytes=os.path.getsize(full), key=k.get(p, rec.get('key')))
        m[p] = rec
    save(m)


if __name__ == '__main__':
    m = load()
    cmd = sys.argv[1] if len(sys.argv) > 1 else 'status'
    if cmd == 'status':
        status(m)
    elif cmd == 'sync':
        sync(m); status(m)
    elif cmd == 'set':
        key, state = sys.argv[2], sys.argv[3]
        note = ' '.join(sys.argv[4:])
        hit = [p for p, r in m.items() if r.get('key') == key]
        assert hit, 'unknown key ' + key
        for p in hit:
            m[p]['state'] = state
            m[p]['updated'] = datetime.date.today().isoformat()
            if note:
                m[p]['note'] = note
        save(m)
    else:
        print(__doc__)
