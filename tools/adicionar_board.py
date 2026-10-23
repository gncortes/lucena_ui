#!/usr/bin/env python3
"""Acrescenta `import 'package:lucena_ui/lucena_ui_board.dart'` nos arquivos do app que
o analyzer acusa por usar PositionBoard e afins (parte do pacote que usa chessground).

Uso: python3 adicionar_board.py APP SIMBOLO [SIMBOLO...]   (SIMBOLO: nome ou getter)
"""
import os
import re
import subprocess
import sys

sys.path.insert(0, os.path.dirname(__file__))
import migrar_imports as m  # noqa: E402

app, simbolos = sys.argv[1], sys.argv[2:]
saida = subprocess.run(["flutter", "analyze"], cwd=app, capture_output=True, text=True).stdout
arqs = set()
for linha in saida.splitlines():
    if " error " not in linha and "error •" not in linha:
        continue
    if not any(f"'{s}'" in linha for s in simbolos):
        continue
    mt = re.search(r" • (\S+?\.dart):\d+:\d+ • ", linha)
    if mt and not mt.group(1).startswith("tools/"):
        arqs.add(mt.group(1))
for a in sorted(arqs):
    p = os.path.join(app, a)
    t = open(p, encoding="utf-8").read()
    open(p, "w", encoding="utf-8").write(m.inserir_import(t, m.BOARD_IMPORT))
print(f"{len(arqs)} arquivos com o import do board")
