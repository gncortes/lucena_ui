import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucena_ui/lucena_ui.dart';
import 'package:lucena_ui/lucena_ui_board.dart';

const _fen = '8/8/8/4k3/8/4K3/4P3/8 w - - 0 1';

Widget _app(Widget child) => MaterialApp(
  theme: AppTheme.of(Brightness.light),
  home: Scaffold(body: child),
);

void main() {
  testWidgets(
    'FeaturedCardView mostra os textos, a marca e responde ao toque',
    (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _app(
          FeaturedCardView(
            cardKey: const Key('card'),
            markKey: const Key('mark'),
            fen: _fen,
            originIcon: Icons.flag,
            originLabel: 'Origem',
            title: 'Título',
            subtitle: 'Quem jogou',
            topic: 'Tema',
            mark: FeaturedMark.played,
            markLabel: 'Jogado',
            onTap: () => taps++,
          ),
        ),
      );
      for (final t in ['Origem', 'Título', 'Quem jogou', 'Tema', 'Jogado']) {
        expect(find.text(t), findsOneWidget);
      }
      await tester.tap(find.byKey(const Key('card')));
      expect(taps, 1);
    },
  );

  testWidgets('FeaturedTournamentCardView esconde o resumo vazio', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        FeaturedTournamentCardView(
          chipIcon: Icons.emoji_events,
          chipLabel: 'Torneio',
          name: 'Candidatos',
          place: 'Toronto',
          onTap: () {},
        ),
      ),
    );
    expect(find.text('Candidatos'), findsOneWidget);
    expect(find.text('Toronto'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });

  testWidgets('ChallengePreview mostra chips, adversário, linhas e a nota', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        SizedBox(
          height: 800,
          child: ChallengePreview(
            boardKey: const Key('board'),
            fen: _fen,
            orientation: Side.white,
            chips: const [ChallengeChip(label: 'Vencer', icon: Icons.flag)],
            opponent: const Text('Adversário'),
            rows: const [
              ChallengeLockedRow(
                rowKey: Key('row'),
                icon: Icons.timer,
                label: 'Relógio',
                value: '5 min',
              ),
            ],
            lockedNote: 'Travado',
          ),
        ),
      ),
    );
    for (final t in ['Vencer', 'Adversário', 'Relógio', '5 min', 'Travado']) {
      expect(find.text(t), findsOneWidget);
    }
    expect(find.byKey(const Key('row')), findsOneWidget);
  });

  testWidgets('LinkSetupForm devolve a escolha de cores e o som', (
    tester,
  ) async {
    BoardColors? picked;
    bool? sound;
    await tester.pumpWidget(
      _app(
        LinkSetupForm(
          hint: 'Dica',
          appearance: const BoardAppearance(),
          animated: false,
          colorsTitle: 'Cores',
          piecesTitle: 'Peças',
          colorLabelOf: (c) => c.name,
          colorKeyOf: (c) => Key('cor.${c.name}'),
          pieceKeyOf: (p) => Key('peca.${p.name}'),
          onColors: (c) => picked = c,
          onPieces: (_) {},
          soundTitle: 'Som',
          sound: true,
          onSound: (v) => sound = v,
          soundKey: const Key('som'),
        ),
      ),
    );
    expect(find.text('Dica'), findsOneWidget);
    final other = BoardColors.values.firstWhere(
      (c) => c != const BoardAppearance().colors,
    );
    final cor = find.byKey(Key('cor.${other.name}'));
    await tester.ensureVisible(cor);
    await tester.tap(cor);
    expect(picked, other);
    await tester.ensureVisible(find.byKey(const Key('som')));
    await tester.tap(find.byKey(const Key('som')));
    expect(sound, isFalse);
  });
}
