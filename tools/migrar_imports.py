#!/usr/bin/env python3
"""Codemod da extração para o lucena_ui (E1.19).

Move arquivos do app para o pacote (git mv) e troca todo import deles, no app, por
`package:lucena_ui/lucena_ui.dart` (sem re-exports). Dentro do pacote, os imports
entre arquivos movidos viram relativos. Atualiza o barrel `lib/lucena_ui.dart`.

Uso:
  python3 migrar_imports.py --app APP --pkg PKG MOVES.txt
MOVES.txt: uma linha por arquivo, `caminho/no/app.dart -> caminho/no/pacote.dart`
(caminhos relativos às raízes; `lib/...` do app vira `lib/src/...` do pacote;
arquivos de `test/` vão para `test/` do pacote e importam o barrel).
`--dry-run` só relata.
"""
import argparse
import os
import re
import subprocess
import sys

IMPORT_RE = re.compile(r"^(import|export)\s+'([^']+)'([^;]*);[ \t]*\n", re.M)
BARREL = "package:lucena_ui/lucena_ui.dart"
PKG_IMPORT = f"import '{BARREL}';\n"


def resolver(origem, alvo, app):
    """Caminho do app (relativo à raiz) a que o import aponta, ou None."""
    if alvo.startswith("package:lucena/"):
        return "lib/" + alvo[len("package:lucena/"):]
    if alvo.startswith(("package:", "dart:")):
        return None
    return os.path.normpath(os.path.join(os.path.dirname(origem), alvo))


def inserir_import(texto):
    if PKG_IMPORT in texto:
        return texto
    imports = list(IMPORT_RE.finditer(texto))
    pacotes = [m for m in imports if m.group(2).startswith("package:")]
    for m in pacotes:
        if m.group(2) > BARREL:
            return texto[: m.start()] + PKG_IMPORT + texto[m.start():]
    if pacotes:
        m = pacotes[-1]
        return texto[: m.end()] + PKG_IMPORT + texto[m.end():]
    if imports:
        m = imports[0]
        return texto[: m.start()] + PKG_IMPORT + "\n" + texto[m.start():]
    return PKG_IMPORT + "\n" + texto


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--app", required=True)
    ap.add_argument("--pkg", required=True)
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("moves")
    a = ap.parse_args()

    moves = {}
    for linha in open(a.moves, encoding="utf-8"):
        linha = linha.strip()
        if not linha or linha.startswith("#"):
            continue
        antigo, novo = [p.strip() for p in linha.split("->")]
        moves[antigo] = novo
    erros = []

    # 1. Reescreve os imports dos arquivos que ficam no app.
    app_arquivos = []
    for pasta in ("lib", "test", "integration_test", "testing"):
        for raiz, _, nomes in os.walk(os.path.join(a.app, pasta)):
            for n in nomes:
                if n.endswith(".dart"):
                    app_arquivos.append(os.path.relpath(os.path.join(raiz, n), a.app))
    tocados = 0
    for rel in app_arquivos:
        if rel in moves:
            continue
        caminho = os.path.join(a.app, rel)
        texto = open(caminho, encoding="utf-8").read()
        usa = False

        def troca(m):
            nonlocal usa
            alvo = resolver(rel, m.group(2), a.app)
            if alvo in moves:
                if " as " in m.group(3):
                    erros.append(f"{rel}: import com prefixo de {alvo}")
                    return m.group(0)
                usa = True
                return ""
            return m.group(0)

        novo = IMPORT_RE.sub(troca, texto)
        if usa:
            novo = inserir_import(novo)
            tocados += 1
            if not a.dry_run:
                open(caminho, "w", encoding="utf-8").write(novo)

    # 2. Move e reescreve os arquivos movidos.
    for antigo, novo_rel in moves.items():
        src = os.path.join(a.app, antigo)
        texto = open(src, encoding="utf-8").read()
        eh_teste = not antigo.startswith("lib/")

        def troca2(m):
            alvo = resolver(antigo, m.group(2), a.app)
            if alvo is None:
                return m.group(0)
            if alvo in moves:
                if eh_teste:
                    return PKG_IMPORT if m.group(1) == "import" else m.group(0)
                rel = os.path.relpath(
                    moves[alvo], os.path.dirname(novo_rel)
                ).replace(os.sep, "/")
                return f"{m.group(1)} '{rel}'{m.group(3)};\n"
            if eh_teste and alvo.startswith("lib/"):
                erros.append(f"{antigo}: depende de {alvo}, que não foi movido")
                return m.group(0)
            if not eh_teste:
                erros.append(f"{antigo}: depende de {alvo}, que não foi movido")
            return m.group(0)

        novo_texto = IMPORT_RE.sub(troca2, texto)
        if eh_teste:
            # um import do barrel só
            partes = novo_texto.split(PKG_IMPORT)
            if len(partes) > 2:
                novo_texto = partes[0] + PKG_IMPORT + "".join(partes[1:])
        if not a.dry_run:
            dst = os.path.join(a.pkg, novo_rel)
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            open(dst, "w", encoding="utf-8").write(novo_texto)
            subprocess.run(["git", "-C", a.app, "rm", "-q", "-f", antigo], check=True)

    # 3. Barrel.
    barrel = os.path.join(a.pkg, "lib", "lucena_ui.dart")
    texto = open(barrel, encoding="utf-8").read()
    exports = set(re.findall(r"^export '([^']+)';$", texto, re.M))
    for novo_rel in moves.values():
        if novo_rel.startswith("lib/src/"):
            exports.add(novo_rel[len("lib/"):])
    cabeca = texto.split("\nexport ", 1)[0].rstrip("\n")
    corpo = "\n".join(f"export '{e}';" for e in sorted(exports))
    if not a.dry_run:
        open(barrel, "w", encoding="utf-8").write(cabeca + "\n\n" + corpo + "\n")

    print(f"{len(moves)} arquivos movidos, {tocados} arquivos do app com import trocado")
    for e in erros:
        print("ERRO:", e)
    sys.exit(1 if erros else 0)


if __name__ == "__main__":
    main()
