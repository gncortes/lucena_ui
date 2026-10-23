import 'dart:math' as math;

import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

import '../board/position_board.dart';
import '../theme/app_icon_size.dart';
import '../theme/app_spacing.dart';
import '../widgets/info_chip.dart';

/// Um chip da prévia do desafio: ícone opcional e rótulo.
class ChallengeChip {
  const ChallengeChip({required this.label, this.icon});

  final String label;
  final IconData? icon;
}

/// Uma linha travada do cartão do desafio: o que é, o valor e o cadeado.
class ChallengeLockedRow {
  const ChallengeLockedRow({
    required this.icon,
    required this.label,
    required this.value,
    this.rowKey,
  });

  final IconData icon;
  final String label;
  final String value;
  final Key? rowKey;
}

/// A prévia de um desafio fechado: a posição e os chips (objetivo, vez), o
/// cartão do adversário, as linhas travadas e a nota do cadeado. Só desenha:
/// o adversário vem pronto e os textos por parâmetro.
class ChallengePreview extends StatelessWidget {
  const ChallengePreview({
    required this.fen,
    required this.orientation,
    required this.chips,
    required this.opponent,
    required this.rows,
    required this.lockedNote,
    this.boardKey,
    this.noteKey,
    super.key,
  });

  /// A fração da altura que o tabuleiro ocupa, no máximo.
  static const _maxBoardShare = 0.5;

  final String fen;
  final Side orientation;
  final List<ChallengeChip> chips;
  final Widget opponent;
  final List<ChallengeLockedRow> rows;
  final String lockedNote;
  final Key? boardKey;
  final Key? noteKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, box) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              0,
            ),
            child: Column(
              spacing: AppSpacing.md,
              children: [
                // Colado no topo, como no quadro; encolhe se a tela for
                // baixa, para sobrar espaço aos cartões.
                SizedBox.square(
                  dimension: math.min(
                    box.maxWidth - 2 * AppSpacing.lg,
                    box.maxHeight * _maxBoardShare,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) => PositionBoard(
                      boardKey: boardKey,
                      fen: fen,
                      size: constraints.maxWidth,
                      orientation: orientation,
                      coordinates: true,
                    ),
                  ),
                ),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final chip in chips)
                      InfoChip(icon: chip.icon, label: chip.label),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              children: [
                opponent,
                Card(
                  margin: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    0,
                  ),
                  child: Column(
                    children: [for (final row in rows) _LockedRow(row: row)],
                  ),
                ),
                Padding(
                  key: noteKey,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.md,
                    children: [
                      Icon(
                        Icons.lock,
                        size: AppIconSize.button,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      Expanded(
                        child: Text(
                          lockedNote,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LockedRow extends StatelessWidget {
  const _LockedRow({required this.row});

  final ChallengeLockedRow row;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      key: row.rowKey,
      leading: Icon(row.icon),
      title: Text(row.label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.md,
        children: [
          Text(row.value, style: theme.textTheme.titleMedium),
          Icon(
            Icons.lock,
            size: AppIconSize.button,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
