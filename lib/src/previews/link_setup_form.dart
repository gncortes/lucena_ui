import 'package:flutter/material.dart';

import '../board/board_appearance.dart';
import '../board/board_appearance_widgets.dart';
import '../board/board_colors.dart';
import '../board/piece_style.dart';
import '../theme/app_spacing.dart';
import '../widgets/section_title.dart';

/// O miolo do "Antes do desafio": dica, miniatura, cores e peças do tabuleiro e
/// o som. Só desenha: o estado e os textos vêm por parâmetro.
class LinkSetupForm extends StatelessWidget {
  const LinkSetupForm({
    required this.hint,
    required this.appearance,
    required this.animated,
    required this.colorsTitle,
    required this.piecesTitle,
    required this.colorLabelOf,
    required this.colorKeyOf,
    required this.pieceKeyOf,
    required this.onColors,
    required this.onPieces,
    required this.soundTitle,
    required this.sound,
    required this.onSound,
    this.fen,
    this.previewKey,
    this.soundKey,
    super.key,
  });

  final String hint;
  final String? fen;
  final BoardAppearance appearance;
  final bool animated;
  final String colorsTitle;
  final String piecesTitle;
  final String Function(BoardColors colors) colorLabelOf;
  final Key Function(BoardColors colors) colorKeyOf;
  final Key Function(PieceStyle pieces) pieceKeyOf;
  final ValueChanged<BoardColors> onColors;
  final ValueChanged<PieceStyle> onPieces;
  final String soundTitle;
  final bool sound;
  final ValueChanged<bool> onSound;
  final Key? previewKey;
  final Key? soundKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              hint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: BoardPreview(
              boardKey: previewKey,
              size: 216,
              fen: fen,
              appearance: appearance.copyWith(coordinates: false),
              animated: animated,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          SectionTitle(colorsTitle),
          BoardColorsCarousel(
            selected: appearance.colors,
            keyOf: colorKeyOf,
            labelOf: colorLabelOf,
            onSelected: onColors,
          ),
          SectionTitle(piecesTitle),
          PieceStyleCarousel(
            selected: appearance.pieces,
            colors: appearance.colors,
            keyOf: pieceKeyOf,
            onSelected: onPieces,
          ),
          SwitchListTile(
            key: soundKey,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
            ),
            secondary: const Icon(Icons.volume_up_outlined),
            title: Text(soundTitle),
            value: sound,
            onChanged: onSound,
          ),
        ],
      ),
    );
  }
}
