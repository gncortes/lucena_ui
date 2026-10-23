import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucena_ui/lucena_ui.dart';
import 'package:lucena_ui/lucena_ui_board.dart';

const _fen = '8/8/8/4k3/8/4K3/4P3/8 w - - 0 1';
const _board = Key('teste.board');

Widget _app(Widget child) => MaterialApp(
  theme: AppTheme.of(Brightness.light),
  home: Scaffold(body: child),
);

StaticChessboardSettings _settings(WidgetTester tester) =>
    tester.widget<StaticChessboard>(find.byKey(_board)).settings;

void main() {
  testWidgets('sem escopo vale a aparência de fábrica', (tester) async {
    await tester.pumpWidget(
      _app(const PositionBoard(fen: _fen, size: 120, boardKey: _board)),
    );
    final s = _settings(tester);
    expect(s.colorScheme, BoardColors.fallback.scheme);
    expect(s.pieceAssets, PieceStyle.fallback.assets);
    expect(s.enableCoordinates, isFalse); // coordinates = false por padrão
  });

  testWidgets('lê cores e peças do BoardAppearanceScope', (tester) async {
    await tester.pumpWidget(
      _app(
        const BoardAppearanceScope(
          appearance: BoardAppearance(
            colors: BoardColors.gray,
            pieces: PieceStyle.merida,
          ),
          child: PositionBoard(fen: _fen, size: 120, boardKey: _board),
        ),
      ),
    );
    final s = _settings(tester);
    expect(s.colorScheme, BoardColors.gray.scheme);
    expect(s.pieceAssets, PieceStyle.merida.assets);
  });

  testWidgets('o parâmetro appearance sobrescreve o escopo', (tester) async {
    await tester.pumpWidget(
      _app(
        const BoardAppearanceScope(
          appearance: BoardAppearance(colors: BoardColors.gray),
          child: PositionBoard(
            fen: _fen,
            size: 120,
            boardKey: _board,
            appearance: BoardAppearance(colors: BoardColors.purple),
          ),
        ),
      ),
    );
    expect(_settings(tester).colorScheme, BoardColors.purple.scheme);
  });

  testWidgets('trocar a aparência do escopo redesenha o tabuleiro', (
    tester,
  ) async {
    Widget com(BoardColors c) => _app(
      BoardAppearanceScope(
        appearance: BoardAppearance(colors: c),
        child: const PositionBoard(fen: _fen, size: 120, boardKey: _board),
      ),
    );
    await tester.pumpWidget(com(BoardColors.green));
    expect(_settings(tester).colorScheme, BoardColors.green.scheme);
    await tester.pumpWidget(com(BoardColors.brown));
    expect(_settings(tester).colorScheme, BoardColors.brown.scheme);
  });

  test('BoardAppearance compara por valor', () {
    expect(
      const BoardAppearance(colors: BoardColors.gray),
      const BoardAppearance(colors: BoardColors.gray),
    );
    expect(
      const BoardAppearance(),
      isNot(const BoardAppearance(coordinates: false)),
    );
    expect(
      const BoardAppearance().copyWith(pieces: PieceStyle.pixel).pieces,
      PieceStyle.pixel,
    );
  });

  test('os códigos gravados continuam os mesmos', () {
    expect(BoardColors.values.map((e) => e.code), [
      'blue',
      'green',
      'brown',
      'gray',
      'purple',
    ]);
    expect(BoardColors.fromCode('x'), BoardColors.fallback);
    expect(PieceStyle.fromCode('merida'), PieceStyle.merida);
    expect(PieceStyle.fromCode(null), PieceStyle.fallback);
  });
}
