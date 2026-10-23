import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

/// O retrato do personagem, no quadrado de cantos arredondados do chess.com.
/// A imagem vem de quem usa ([image]); o pacote não conhece o personagem.
class CharacterAvatar extends StatelessWidget {
  const CharacterAvatar({
    required this.image,
    this.size = player,
    this.radius,
    super.key,
  });

  /// Os tamanhos do retrato (T73, D9; canvas 96d710e): fala em cartão fora do
  /// tabuleiro, linha da lição, jogador em linha, tour e confronto (VS), mais o mini dos chips.
  static const speech = 56.0;
  static const lesson = 40.0;
  static const player = 44.0;
  static const tour = 64.0;
  static const versus = 72.0;

  /// O retrato pequeno dentro de chip e de linha compacta.
  static const mini = 28.0;

  final ImageProvider image;
  final double size;

  /// Raio dos cantos; nulo: 14% do tamanho.
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? size * 0.14),
        child: AnimatedSwitcher(
          duration: AppMotion.state,
          child: Image(
            image: image,
            key: ValueKey(image),
            width: size,
            height: size,
            fit: BoxFit.cover,
            // O retrato é decorativo: o nome vem ao lado.
            excludeFromSemantics: true,
          ),
        ),
      ),
    );
  }
}
