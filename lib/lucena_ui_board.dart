/// Parte do `lucena_ui` que usa o `chessground` (e o `dartchess`).
///
/// O `dartchess` não compila para a web (inteiros de 64 bits): quem builda para
/// a web (o painel) importa só `lucena_ui.dart`. O app importa os dois.
library;

export 'src/board/board_appearance_widgets.dart';
export 'src/board/board_colors_scheme.dart';
export 'src/board/piece_style_assets.dart';
export 'src/board/position_board.dart';
export 'src/cards/position_card.dart';
