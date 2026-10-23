import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// O pacote precisa compilar na web e não conhecer o app: nada de bloc, intl,
/// l10n do app, `dart:io` nem plugins de plataforma em `lib/src`.
void main() {
  test('lib/src é puro', () {
    final proibidos = <Pattern>[
      RegExp(r"import\s+'dart:(io|ffi)'"),
      RegExp(
        r"import\s+'package:(flutter_bloc|bloc|intl|freezed_annotation|go_router|drift|webview_flutter|flutter_tts|multistockfish|sound_effect)\b",
      ),
      RegExp(r'AppLocalizations'),
      RegExp(r"import\s+'package:lucena/"),
    ];
    final violacoes = <String>[];
    for (final f
        in Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))) {
      final texto = f.readAsStringSync();
      for (final p in proibidos) {
        if (texto.contains(p)) violacoes.add('${f.path}: $p');
      }
    }
    expect(violacoes, isEmpty);
  });

  test(
    'lucena_ui.dart não alcança chessground nem dartchess (compila na web)',
    () {
      // O dartchess usa inteiros de 64 bits e não compila com dart2js.
      final visitados = <String>{};
      final fila = <String>['lib/lucena_ui.dart'];
      final diretos = RegExp(
        r"^\s*(?:import|export)\s+'([^']+)'",
        multiLine: true,
      );
      final violacoes = <String>[];
      while (fila.isNotEmpty) {
        final atual = fila.removeLast();
        if (!visitados.add(atual)) continue;
        final texto = File(atual).readAsStringSync();
        for (final m in diretos.allMatches(texto)) {
          final alvo = m.group(1)!;
          if (alvo.startsWith('package:chessground') ||
              alvo.startsWith('package:dartchess')) {
            violacoes.add('$atual -> $alvo');
          } else if (alvo.startsWith('package:lucena_ui/')) {
            fila.add('lib/${alvo.substring('package:lucena_ui/'.length)}');
          } else if (!alvo.contains(':')) {
            fila.add(File(atual).parent.uri.resolve(alvo).toFilePath());
          }
        }
      }
      expect(violacoes, isEmpty);
    },
  );
}
