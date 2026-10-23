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
