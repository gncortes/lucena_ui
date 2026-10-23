#!/usr/bin/env python3
"""Apaga os imports que o analyzer acusa como não usados (depois do codemod).

Uso: python3 limpar_imports.py APP   (roda `flutter analyze` na pasta APP)
"""
import re
import subprocess
import sys
from collections import defaultdict

app = sys.argv[1]
saida = subprocess.run(["flutter", "analyze"], cwd=app, capture_output=True, text=True).stdout
alvos = defaultdict(list)
for m in re.finditer(r"Unused import.* • (\S+?):(\d+):\d+ • unused_import", saida):
    alvos[m.group(1)].append(int(m.group(2)))
for arq, linhas in alvos.items():
    if arq.startswith("tools/"):
        continue
    caminho = f"{app}/{arq}"
    ls = open(caminho, encoding="utf-8").read().split("\n")
    for n in sorted(linhas, reverse=True):
        l = ls[n - 1]
        if l.startswith("import ") and l.rstrip().endswith(";"):
            del ls[n - 1]
    open(caminho, "w", encoding="utf-8").write("\n".join(ls))
print(f"{sum(len(v) for v in alvos.values())} imports removidos em {len(alvos)} arquivos")
