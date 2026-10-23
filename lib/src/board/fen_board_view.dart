import 'package:flutter/material.dart';

import 'board_colors.dart';
import 'piece_style.dart';

/// Tabuleiro estático de uma posição (FEN), que compila na web.
///
/// Mesma aparência do `PositionBoard` do app (cores das casas de
/// [BoardColors], peças do [PieceStyle] vindas do `chessground`), mas sem
/// importar `chessground` nem `dartchess` em código Dart: só lê as imagens do
/// pacote como asset. Serve ao painel de admin, que builda para a web.
/// Vista pelo lado que joga (o segundo campo do FEN); sem esse campo, brancas.
class FenBoardView extends StatelessWidget {
  const FenBoardView({
    required this.fen,
    required this.size,
    this.coordinates = false,
    this.radius = 6,
    this.colors = BoardColors.fallback,
    this.pieceStyle = PieceStyle.fallback,
    super.key,
  });

  final String fen;
  final double size;
  final bool coordinates;
  final double radius;
  final BoardColors colors;
  final PieceStyle pieceStyle;

  /// Casa clara e casa escura de cada esquema (iguais às do app).
  static (Color, Color) squares(BoardColors c) => switch (c) {
    BoardColors.blue => (const Color(0xffdee3e6), const Color(0xff8ca2ad)),
    BoardColors.green => (const Color(0xffffffdd), const Color(0xff86a666)),
    BoardColors.brown => (const Color(0xfff0d9b6), const Color(0xffb58863)),
    BoardColors.gray => (const Color(0xffe3e3e3), const Color(0xff9a9a9a)),
    BoardColors.purple => (const Color(0xffe7dff0), const Color(0xff9079b0)),
  };

  /// As 64 casas da fileira 8 à 1, colunas a até h; nulo é casa vazia.
  static List<String?> parse(String fen) {
    final cells = <String?>[];
    for (final c in fen.split(' ').first.runes.map(String.fromCharCode)) {
      if (c == '/') continue;
      final n = int.tryParse(c);
      if (n != null) {
        cells.addAll(List<String?>.filled(n, null));
      } else {
        cells.add(c);
      }
    }
    while (cells.length < 64) {
      cells.add(null);
    }
    return cells.take(64).toList();
  }

  @override
  Widget build(BuildContext context) {
    final parts = fen.split(' ');
    final blackBottom = parts.length > 1 && parts[1] == 'b';
    final cells = parse(fen);
    final side = size / 8;
    final (light, dark) = squares(colors);
    return SizedBox.square(
      dimension: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _BoardPainter(
                  light: light,
                  dark: dark,
                  blackBottom: blackBottom,
                  coordinates: coordinates,
                ),
              ),
            ),
            for (var i = 0; i < 64; i++)
              if (cells[i] case final piece?)
                Positioned(
                  left: (blackBottom ? 7 - i % 8 : i % 8) * side,
                  top: (blackBottom ? 7 - i ~/ 8 : i ~/ 8) * side,
                  width: side,
                  height: side,
                  child: Image(
                    image: AssetImage(
                      'assets/piece_sets/${pieceStyle.name}/'
                      '${piece == piece.toUpperCase() ? 'w' : 'b'}'
                      '${piece.toUpperCase()}.webp',
                      package: 'chessground',
                    ),
                    fit: BoxFit.contain,
                    errorBuilder: (context, _, _) => const SizedBox.shrink(),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _BoardPainter extends CustomPainter {
  _BoardPainter({
    required this.light,
    required this.dark,
    required this.blackBottom,
    required this.coordinates,
  });

  final Color light;
  final Color dark;
  final bool blackBottom;
  final bool coordinates;

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.width / 8;
    for (var i = 0; i < 64; i++) {
      final row = i ~/ 8;
      final col = i % 8;
      canvas.drawRect(
        Rect.fromLTWH(col * side, row * side, side, side),
        Paint()..color = (row + col).isEven ? light : dark,
      );
    }
    if (!coordinates) return;
    for (var k = 0; k < 8; k++) {
      final col = blackBottom ? 7 - k : k;
      final rank = blackBottom ? k + 1 : 8 - k;
      _text(
        canvas,
        String.fromCharCode(97 + col),
        Offset(k * side + side * 0.78, size.height - side * 0.28),
        side,
        k.isEven,
      );
      _text(
        canvas,
        '$rank',
        Offset(side * 0.05, k * side + side * 0.03),
        side,
        k.isEven,
      );
    }
  }

  void _text(Canvas canvas, String t, Offset o, double side, bool onLight) {
    TextPainter(
        text: TextSpan(
          text: t,
          style: TextStyle(fontSize: side * 0.2, color: onLight ? dark : light),
        ),
        textDirection: TextDirection.ltr,
      )
      ..layout()
      ..paint(canvas, o);
  }

  @override
  bool shouldRepaint(_BoardPainter old) =>
      old.light != light ||
      old.dark != dark ||
      old.blackBottom != blackBottom ||
      old.coordinates != coordinates;
}
