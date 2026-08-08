import re
import os
root = r'c:\Users\Fabio\Downloads\code-projects\sa-reclaimed'
core = os.path.join(root, 'godot-project', 'scripts', 'CoreBridge.gd')
with open(core, 'r', encoding='utf-8') as f:
    data = f.read()

def extract(pattern):
    m = re.search(pattern, data, re.S)
    return m.group(1) if m else ''

inter = extract(r'func _source_interactable_type\(kind: String\) -> int:\n(.*?)(?:\nfunc )')
enemy = extract(r'func _source_enemy_type\(kind: String\) -> int:\n(.*?)(?:\nfunc )')
item = extract(r'func _source_item_kind\(kind: String\) -> int:\n(.*?)(?:\n(?:$|func ))')

patterns = {'interactables': set(), 'enemies': set(), 'items': set()}
for label, blk in [('interactables', inter), ('enemies', enemy), ('items', item)]:
    for m in re.finditer(r'if kind == "([^"]+)"|if kind\.begins_with\("([^"]+)"\)|if kind\.find\("([^"]+)"\) >= 0|match kind:|\t"([A-Z0-9_]+)":', blk):
        for g in m.groups():
            if g:
                patterns[label].add(g)

for m in re.finditer(r'"([A-Z0-9_]+)":\n\s*return', enemy):
    patterns['enemies'].add(m.group(1))

kinds = {'interactables': set(), 'enemies': set(), 'items': set()}
for filename, key in [('interactables.csv','interactables'), ('enemies.csv','enemies'), ('itemboxes.csv','items')]:
    for rootdir, _, files in os.walk(os.path.join(root, 'data', 'sa2', 'maps')):
        if filename in files:
            with open(os.path.join(rootdir, filename), encoding='utf-8') as f:
                lines = f.read().splitlines()[1:]
                for line in lines:
                    if not line.strip():
                        continue
                    parts = line.split(',')
                    if len(parts) >= 5:
                        kinds[key].add(parts[4].strip())

for key in ['items', 'enemies', 'interactables']:
    actual = kinds[key]
    supported = patterns[key]
    missing = sorted(actual - supported)
    print('---', key, 'missing', len(missing))
    for m in missing:
        print(m)
