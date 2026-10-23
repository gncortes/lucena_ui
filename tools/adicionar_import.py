#!/usr/bin/env python3
"""Acrescenta um import nos arquivos do app que o analyzer acusa por usar um símbolo.

Uso: python3 adicionar_board.py APP IMPORT SIMBOLO [SIMBOLO...]
  IMPORT: `board` (lucena_ui_board.dart), `ui` (lucena_ui.dart) ou o URI inteiro
  SIMBOLO: nome do identificador, do getter ou do método acusado
"""
import os
import re
import subprocess
import sys

sys.path.insert(0, os.path.dirname(__file__))
import migrar_imports as m  # noqa: E402

app, imp, simbolos = sys.argv[1], sys.argv[2], sys.argv[3:]
imp = {'board': m.BOARD_IMPORT, 'ui': m.PKG_IMPORT}.get(imp, f"import '{imp}';\n")
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
    open(p, "w", encoding="utf-8").write(m.inserir_import(t, imp))
print(f"{len(arqs)} arquivos com o import do board")
