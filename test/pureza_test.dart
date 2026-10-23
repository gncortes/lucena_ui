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
}
