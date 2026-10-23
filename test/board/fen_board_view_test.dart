import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucena_ui/lucena_ui.dart';

const _fen = '8/8/8/4k3/8/4K3/4P3/8 w - - 0 1';

Widget _app(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

void main() {
  test('parse lê 64 casas e as peças certas', () {
    final cells = FenBoardView.parse(_fen);
    expect(cells, hasLength(64));
    expect(cells.whereType<String>().toList()..sort(), ['K', 'P', 'k']);
    expect(cells[3 * 8 + 4], 'k');
    expect(cells[5 * 8 + 4], 'K');
  });

  test('parse completa FEN curto com casas vazias', () {
    expect(FenBoardView.parse('8'), everyElement(isNull));
    expect(FenBoardView.parse('8'), hasLength(64));
  });

  testWidgets('desenha uma imagem por peça no tamanho pedido', (tester) async {
    await tester.pumpWidget(_app(const FenBoardView(fen: _fen, size: 160)));
    expect(find.byType(Image), findsNWidgets(3));
    expect(tester.getSize(find.byType(FenBoardView)), const Size(160, 160));
  });

  testWidgets('peças pretas embaixo quando joga o preto', (tester) async {
    await tester.pumpWidget(
      _app(const FenBoardView(fen: '8/8/8/4k3/8/4K3/8/8 b - - 0 1', size: 160)),
    );
    final tops = tester
        .widgetList<Positioned>(find.byType(Positioned))
        .where((p) => p.width == 20)
        .map((p) => p.top)
        .toList();
    // rei preto (fileira 5) vai para baixo: 7 - 3 = 4 -> 80; rei branco: 7-5=2 -> 40.
    expect(tops, containsAll([80.0, 40.0]));
  });

  test('cada esquema tem casa clara mais clara que a escura', () {
    for (final c in BoardColors.values) {
      final (l, d) = FenBoardView.squares(c);
      expect(l.computeLuminance(), greaterThan(d.computeLuminance()));
    }
  });
}
