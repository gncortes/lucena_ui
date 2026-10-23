#!/usr/bin/env python3
"""Em lib/src, troca `import 'package:lucena_ui/lucena_ui.dart'` por imports relativos.

Importa todos os arquivos de src/ e depois `limpar_imports.py .` apaga os que sobrarem.
Uso: python3 relativizar_barrel.py PACOTE
"""
import os
import sys

raiz = sys.argv[1]
src = os.path.join(raiz, "lib", "src")
todos = []
for r, _, fs in os.walk(src):
    for f in fs:
        if f.endswith(".dart"):
            todos.append(os.path.join(r, f))
BARRELS = [
    "import 'package:lucena_ui/lucena_ui.dart';\n",
    "import 'package:lucena_ui/lucena_ui_board.dart';\n",
]
for arq in todos:
    t = open(arq, encoding="utf-8").read()
    BARREL = next((b for b in BARRELS if b in t), None)
    if BARREL is None:
        continue
    rels = sorted(
        os.path.relpath(o, os.path.dirname(arq)).replace(os.sep, "/")
        for o in todos if o != arq
    )
    imports = "".join(
        f"import '{r}';\n" for r in rels if f"import '{r}';\n" not in t
    )
    for b in BARRELS:
        t = t.replace(b, imports if b == BARREL else "")
    open(arq, "w", encoding="utf-8").write(t)
