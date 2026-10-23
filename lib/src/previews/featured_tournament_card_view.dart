import 'package:flutter/material.dart';

import '../theme/app_shape.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../widgets/info_chip.dart';

/// O cartão de um torneio (em andamento, na lista): chip, nome, resumo e a
/// seta para a tela dele. Só desenha: os textos vêm por parâmetro.
class FeaturedTournamentCardView extends StatelessWidget {
  const FeaturedTournamentCardView({
    required this.chipIcon,
    required this.chipLabel,
    required this.name,
    required this.onTap,
    this.place,
    this.summary = '',
    this.cardKey,
    super.key,
  });

  final IconData chipIcon;
  final String chipLabel;
  final String name;
  final String? place;
  final String summary;
  final VoidCallback onTap;
  final Key? cardKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      key: cardKey,
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppShape.large),
        side: BorderSide(color: colors.primaryContainer, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xs,
                  children: [
                    Row(
                      spacing: AppSpacing.sm,
                      children: [
                        InfoChip(
                          compact: true,
                          background: colors.primaryContainer,
                          foreground: colors.primary,
                          icon: chipIcon,
                          label: chipLabel,
                        ),
                        if (place != null)
                          Flexible(
                            child: Text(
                              place!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(name, style: context.cardTitle),
                    if (summary.isNotEmpty)
                      Text(
                        summary,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
