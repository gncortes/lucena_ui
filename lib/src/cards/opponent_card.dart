import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import 'character_avatar.dart';

/// Contra quem: o retrato, o nome, o nível e a frase do personagem. O texto
/// "Adversário" ([label]) vem de quem usa.
class OpponentCard extends StatelessWidget {
  const OpponentCard({
    required this.name,
    required this.label,
    this.image,
    this.level,
    this.tagline = '',
    this.heroTag,
    this.margin = const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.lg,
      AppSpacing.lg,
      0,
    ),
    super.key,
  });

  final String name;

  /// O rótulo pequeno acima do nome ("Adversário").
  final String label;

  /// O retrato. Sem ele (adversário sem personagem), só o texto.
  final ImageProvider? image;
  final int? level;
  final String tagline;

  /// Com a marca, o retrato voa até o da tela seguinte.
  final Object? heroTag;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final image = this.image;
    Widget avatar() =>
        CharacterAvatar(image: image!, size: CharacterAvatar.tour);
    return Card(
      margin: margin,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            if (image != null) ...[
              heroTag == null ? avatar() : Hero(tag: heroTag!, child: avatar()),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    [name, if (level case final level?) '$level'].join(' · '),
                    style: context.cardTitle,
                  ),
                  if (tagline.isNotEmpty)
                    Text(
                      '“$tagline”',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
