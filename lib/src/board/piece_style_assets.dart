import 'package:chessground/chessground.dart';

import 'piece_style.dart';

/// As imagens de cada conjunto de peças.
extension PieceStyleAssets on PieceStyle {
  PieceAssets get assets => switch (this) {
    PieceStyle.cburnett => PieceSet.cburnettAssets,
    PieceStyle.merida => PieceSet.meridaAssets,
    PieceStyle.chessnut => PieceSet.chessnutAssets,
    PieceStyle.pirouetti => PieceSet.pirouettiAssets,
    PieceStyle.mpchess => PieceSet.mpchessAssets,
    PieceStyle.firi => PieceSet.firiAssets,
    PieceStyle.rhosgfx => PieceSet.rhosgfxAssets,
    PieceStyle.fantasy => PieceSet.fantasyAssets,
    PieceStyle.celtic => PieceSet.celticAssets,
    PieceStyle.spatial => PieceSet.spatialAssets,
    PieceStyle.pixel => PieceSet.pixelAssets,
    PieceStyle.letter => PieceSet.letterAssets,
  };
}
