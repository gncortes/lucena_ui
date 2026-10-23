import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/painting.dart';

/// Cores das casas do tabuleiro.
enum BoardColors {
  blue,
  green,
  brown,
  gray,
  purple;

  static const fallback = BoardColors.blue;

  /// Valor gravado nas preferências.
  String get code => name;

  static BoardColors fromCode(String? code) =>
      values.asNameMap()[code] ?? fallback;
}

/// Como as cores do tabuleiro aparecem no `chessground`.
extension BoardColorsScheme on BoardColors {
  ChessboardColorScheme get scheme => switch (this) {
    BoardColors.blue => ChessboardColorScheme.blue,
    BoardColors.green => ChessboardColorScheme.green,
    BoardColors.brown => ChessboardColorScheme.brown,
    BoardColors.gray => _gray,
    BoardColors.purple => _purple,
  };

  // Esquemas próprios, de cor lisa (sem imagem de terceiros).
  static const _gray = ChessboardColorScheme(
    lightSquare: _grayLight,
    darkSquare: _grayDark,
    background: SolidColorChessboardBackground(
      lightSquare: _grayLight,
      darkSquare: _grayDark,
    ),
    whiteCoordBackground: SolidColorChessboardBackground(
      lightSquare: _grayLight,
      darkSquare: _grayDark,
      coordinates: true,
    ),
    blackCoordBackground: SolidColorChessboardBackground(
      lightSquare: _grayLight,
      darkSquare: _grayDark,
      coordinates: true,
      orientation: Side.black,
    ),
    lastMove: HighlightDetails(solidColor: Color(0x809bc700)),
    selected: HighlightDetails(solidColor: Color(0x6014551e)),
    validMoves: Color(0x4014551e),
    validPremoves: Color(0x40203085),
  );
  static const _grayLight = Color(0xffe3e3e3);
  static const _grayDark = Color(0xff9a9a9a);

  static const _purple = ChessboardColorScheme(
    lightSquare: _purpleLight,
    darkSquare: _purpleDark,
    background: SolidColorChessboardBackground(
      lightSquare: _purpleLight,
      darkSquare: _purpleDark,
    ),
    whiteCoordBackground: SolidColorChessboardBackground(
      lightSquare: _purpleLight,
      darkSquare: _purpleDark,
      coordinates: true,
    ),
    blackCoordBackground: SolidColorChessboardBackground(
      lightSquare: _purpleLight,
      darkSquare: _purpleDark,
      coordinates: true,
      orientation: Side.black,
    ),
    lastMove: HighlightDetails(solidColor: Color(0x809bc700)),
    selected: HighlightDetails(solidColor: Color(0x6014551e)),
    validMoves: Color(0x4014551e),
    validPremoves: Color(0x40203085),
  );
  static const _purpleLight = Color(0xffe7dff0);
  static const _purpleDark = Color(0xff9079b0);
}
