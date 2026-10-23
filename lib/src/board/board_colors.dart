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
