# frozen_string_literal: true

# to do: pretty print methods for bulletizing, padding, marginizing, and colorizing text

# Module containing strings of the rules for chess.
# Rules from:  https://www.chessstrategyonline.com/content/tutorials/how-to-play-chess-summary
module Rules
  RULES_PIECES = "\e[31mThe Pieces\e[0m
\e[33mPawns\e[0m   move one square forwards. Have the option of moving one or two squares
        on their first move. Capture by moving one square diagonally forwards.
        Promoted to another piece if they reach the far end of the board.
\e[33mKnights\e[0m move in an L-shape - one square vertically and two squares horizontally,
        or one square horizontally and two squares vertically. Can jump over
        any pieces in its path.
\e[33mBishops\e[0m move any number of squares diagonally in a straight line. May not
        jump over other pieces.
\e[33mRooks\e[0m   move any number of squares vertically or horizontally in a straight line.
        May not jump over other pieces.
\e[33mQueen\e[0m   moves any number of squares vertically, horizontally, or diagonally
        in a straight line. May not jump over other pieces.
\e[33mKing\e[0m    moves one square in any direction. May not move onto a square
        threatened by an enemy piece.\n\n"

  RULES_CHECK = "\e[31mCheck and Checkmate\e[0m
\e[33mCheck\e[0m if the king is threatened by an enemy piece, he is in 'check', and must
        escape from check. This can be done by moving the king, capturing the
        checking piece, or blocking the checking piece (so long as it isn't a
        knight).
\e[33mCheckmate\e[0m if the king is in check and can't get out of check, he is in checkmate
        and the game is lost.\n\n"

  RULES_CASTLING = "\e[31mCastling\e[0m
\e[33mCastling\e[0m move the king two squares towards the rook, and jump the rook to the
        square on the other side of the king.
        \e[30mYou cannot castle if...\e[0m
          You have previously moved your king or rook.
          There are pieces between your king and rook.
          Your king in check.
          Your king would be in check at the end of the move.
          Your king would cross a square that is threatened by an enemy piece.\n\n"

  RULES_PASSANT = "\e[31mEn Passant\e[0m
\e[33mEn Passant\e[0m if you have a pawn on the fifth rank, and your opponent moves an
        adjacent pawn two squares, you can capture the pawn as if it had only
        moved one square.
        \e[30mYou cannot capture en passant if...\e[0m
          Your pawn is not on the fifth rank.
          The enemy pawn did not move two squares on the previous move.\n\n"

  RULES_DRAWS = "\e[31mDraws\e[0m
\e[33mMutual agreement\e[0m - the players can agree to a draw at any time.
\e[33mInsufficient material\e[0m - the game is drawn if there aren't enough pieces left
        on the board for checkmate to occur.
\e[33mStalemate\e[0m - if the player whose turn it is has no legal moves, but is not in
        checkmate, then the game is drawn.
\e[33mThreefold repetition\e[0m - if the same position is repeated three times, with the
        same player to move each time, either player may claim a draw.
\e[33mThe 50 move rule\e[0m - if 50 moves have passed without either side making a pawn
        move or capture, either player may claim a draw.\n\n"

  RULES_OTHERS = "\e[31mOther rules\e[0m
\e[33mThe board\e[0m - place it so that each player has a light square in their bottom
        right hand corner.
\e[33mThe players\e[0m - white always moves first.\n"
end
