import 'package:flutter/widgets.dart';

import 'board_colors.dart';
import 'piece_style.dart';

/// Como o tabuleiro aparece: cores das casas, conjunto de peças e coordenadas.
@immutable
class BoardAppearance {
  const BoardAppearance({
    this.colors = BoardColors.fallback,
    this.pieces = PieceStyle.fallback,
    this.coordinates = true,
  });

  final BoardColors colors;
  final PieceStyle pieces;

  /// Letras e números das casas na borda do tabuleiro.
  final bool coordinates;

  BoardAppearance copyWith({
    BoardColors? colors,
    PieceStyle? pieces,
    bool? coordinates,
  }) => BoardAppearance(
    colors: colors ?? this.colors,
    pieces: pieces ?? this.pieces,
    coordinates: coordinates ?? this.coordinates,
  );

  @override
  bool operator ==(Object other) =>
      other is BoardAppearance &&
      other.colors == colors &&
      other.pieces == pieces &&
      other.coordinates == coordinates;

  @override
  int get hashCode => Object.hash(colors, pieces, coordinates);
}

/// Entrega a [BoardAppearance] a todo `PositionBoard` abaixo. Sem escopo, vale a
/// aparência de fábrica.
class BoardAppearanceScope extends InheritedWidget {
  const BoardAppearanceScope({
    required this.appearance,
    required super.child,
    super.key,
  });

  final BoardAppearance appearance;

  /// A aparência do escopo mais próximo (e reconstrói quando ela muda).
  static BoardAppearance of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<BoardAppearanceScope>()
          ?.appearance ??
      const BoardAppearance();

  @override
  bool updateShouldNotify(BoardAppearanceScope oldWidget) =>
      appearance != oldWidget.appearance;
}
