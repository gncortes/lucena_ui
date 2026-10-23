import 'package:flutter/material.dart';

import '../board/position_board.dart';
import '../theme/app_colors.dart';
import '../theme/app_icon_size.dart';
import '../theme/app_shape.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../widgets/info_chip.dart';

/// A marca de um final em destaque: já jogado ou novo.
enum FeaturedMark { none, played, isNew }

/// Um final em destaque numa lista: miniatura, origem, título, quem jogou e o
/// tema. Só desenha: textos, ícone e keys vêm por parâmetro.
class FeaturedCardView extends StatelessWidget {
  const FeaturedCardView({
    required this.fen,
    required this.originIcon,
    required this.originLabel,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.topic,
    this.mark = FeaturedMark.none,
    this.markLabel = '',
    this.cardKey,
    this.originKey,
    this.markKey,
    super.key,
  });

  static const thumbnail = 92.0;

  final String fen;
  final IconData originIcon;
  final String originLabel;
  final String title;
  final String subtitle;
  final String? topic;
  final FeaturedMark mark;

  /// O texto da marca (ignorado sem marca).
  final String markLabel;
  final VoidCallback onTap;
  final Key? cardKey;
  final Key? originKey;
  final Key? markKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      key: cardKey,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.md,
            children: [
              ExcludeSemantics(
                child: PositionBoard(
                  fen: fen,
                  size: thumbnail,
                  radius: AppShape.small,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xs,
                  children: [
                    Row(
                      children: [
                        InfoChip(
                          key: originKey,
                          compact: true,
                          background: colors.primaryContainer,
                          foreground: colors.primary,
                          icon: originIcon,
                          label: originLabel,
                        ),
                        const Spacer(),
                        if (mark == FeaturedMark.played)
                          _Badge(
                            key: markKey,
                            icon: Icons.check_circle,
                            label: markLabel,
                            color: AppColors.successColor,
                          )
                        else if (mark == FeaturedMark.isNew)
                          _Badge(
                            key: markKey,
                            label: markLabel,
                            color: colors.primary,
                          ),
                      ],
                    ),
                    Text(
                      title,
                      style: context.cardTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (topic != null)
                      Text(
                        topic!,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    this.icon,
    super.key,
  });

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium
        ?.copyWith(color: color, fontWeight: AppWeight.strong);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.xs,
      children: [
        if (icon != null) Icon(icon, size: AppIconSize.small, color: color),
        Text(label, style: style),
      ],
    );
  }
}
