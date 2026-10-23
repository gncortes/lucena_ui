import 'package:chessground/chessground.dart';

/// Conjunto de peças. Só entram conjuntos de licença livre, compatível com a
/// AGPL do app (ver `THIRD-PARTY-NOTICES.md`).
enum PieceStyle {
  cburnett('Cburnett'),
  merida('Merida'),
  chessnut('Chessnut'),
  pirouetti('Pirouetti'),
  mpchess('MPChess'),
  firi('Firi'),
  rhosgfx('RhosGFX'),
  fantasy('Fantasy'),
  celtic('Celtic'),
  spatial('Spatial'),
  pixel('Pixel'),
  letter('Letter');

  const PieceStyle(this.label);

  /// Nome próprio do conjunto: não é traduzido.
  final String label;

  static const fallback = PieceStyle.cburnett;

  /// Valor gravado nas preferências.
  String get code => name;

  static PieceStyle fromCode(String? code) =>
      values.asNameMap()[code] ?? fallback;
}

/// As imagens de cada conjunto de peças.
extension PieceStyleAssets on PieceStyle {
  PieceAssets get assets => switch (this) {
    PieceStyle.cburnett => PieceSet.cburnettAssets,
    PieceStyle.merida => PieceSet.meridaAssets,
    PieceStyle.chessnut => PieceSet.chessnutAssets,
    PieceStyle.pirouetti => PieceSet.pirouettiAssets,
    PieceStyle.mpchess => PieceSet.mpchessAssets,
    PieceStyle.firi => PieceSet.firiAssets,
    PieceStyle.rhosgfx => PieceSet.rhosgfxAssets,
    PieceStyle.fantasy => PieceSet.fantasyAssets,
    PieceStyle.celtic => PieceSet.celticAssets,
    PieceStyle.spatial => PieceSet.spatialAssets,
    PieceStyle.pixel => PieceSet.pixelAssets,
    PieceStyle.letter => PieceSet.letterAssets,
  };
}
