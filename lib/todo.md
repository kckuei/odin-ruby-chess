## To do
----
* Implement pond movements [DONE]
* Valid moves print pretty prints [DONE]
  * colorize moves that are combative
* Move movement modules to seperate files [DONE]
* Implement castle pattern [DONE]
* Add a hashes for each player of all pieces [DONE]
  * need for enumerating over all possible moves
* Implement check [DONE]
  * enumerate over all pieces, save to set, is king in set?
  * use hash to quick ref king
* Implment checkmate [DONE]
  * Issue: I should only iterate over pieces that are ON the board when doing check/chekmate.
  * Undecided:
    * should i remove the keys/values in @pieces once the pieces have been killed/are no longer on the board?..yes
    * will this interfere with checkmate logic?..no it won't because we're directly manipulating the board, not using force_move.
  * maybe add the key to the pieces as well, so I can reference them easily.
* force_move should update first_move as well. [DONE]
* Implement player class [DONE_ALREADY]
* Update castle to use hash [SKIP]
* Implement safe method [DONE]
  * A move is not valid if it puts the king in jeopardy
  * similar to checkmate logic, check if a move will result in check
* Game loop selection [DONE]
  * save game
  * move piece
  * show valid moves for piece
  * exit
* Implement menu selection [DONE]
  * new game
  * load game
  * rules
  * color settings possibly
  * computer opponent possibly
* Implement basic game loop mechanism [DONE]
* Implement end game selection [DONE]
  * new game
  * log output
* fix growing callstack error [DONE]
  * restructured the menu logic so that it fully exits gameloop, before starting another
* fix checkmate gameover errors [DONE]
  * was related to passing silent error. 
  * trying to delete a key from the hash 1 level above, versus the player specific hashes
* fix piece, pond dependency on 1 on player 1 or 2, or should be defined based on player orientation/board assignment works, but pieces move in wront direction otherwise [SKIP]
* Implement logger [DONE]
  * stored as game attribute
  * passed start, end move
  * decide on data structure/how data is stored
  * can be nice for doinga pretty print
* Implement serializer, and save game methods [DONE]
  * mkdir
  * time/date
  * note/memo
* Replay option? [SKIP]


* Declare checks []
  * print check declaration to screen
  * checked players move should take them out of check
    * Can use the safe? method for this as safe?(move) == true, means that the kind is no longer in check. 
    * query until this condition is satisfied.
* Integrate safe moves with valid move patterns []
  * valid patterns shouldn't need to remove moves that put player in check
  * it should just query for a different move until the piece is safe


* Integrate casle with valid moves []
* Implement en passant []
* Implement pawn promotion []
  * the @pieces hash will need to be updated accordingly to remove old / add new

* scramble mode
* Implement stalemate condition []

* Optional implement simple AI [prolly skip]
* Final Readme and demo page


## Notes
----
### Initial Brainstorm Notes
* chess board representation: nested list of chess piece objects
* move implementation
  * check movement patterns relative to current position
  * orhtongal, diaganol, 
  * filter by distance, friendly/combatants
  * jumping (knights, ponds)
* special mechanics/rules:
  * check, checkmate, stalemate, castling, pond promotion
  * moves cannot jeapordize the king
* move specification and display
  * chess code, 'a1 -> b2'
  * list feasible moves
* serialization: Marshall
* classes
  * game, player, board, piece, ai, serializer, logger
  * single responsibilitiy
* types of tests
  * check, checkmate, valid move?
* basic movement patterns
  * all pieces
    * can move onto another piece only if opposing
    * only if it doesn't put king in danger
    * must remain in board
  * pond
    * can move forward 2 square if first move and no combatant
    * else 1 square if no combatant
    * diaganoly 1 tile only if attacking
  * knight
    * can move/attack in L pattern relative to pos
  * king
    * can move/attack ortho/diag within 1 tile
  * queen
    * can move/attack ortho/diag to first obstruction
  * bishop
    * can move/attack diag to first obstruction
  * rook 
    * can move/attack ortho to first obstruction

### Initial Class and Methods Outline
* game
  * for general game logic
  * intro, turns, winner declaration, new game, saving/loading game
* player
  * for players
  * attributes
    * pointers to pieces??
  * methods
    * color
    * name
* board
  * for chess board
  * attributes
    * board
    * pieces???
  * methods
    * make_board
    * initialize_pieces
    * scramble_pieces
    * reset_board
    * draw_board
    * move_piece/update_board(piece)
    * check?(player)
        * player must and can move out of harms way
    * checkmate?(player)
        * player cannot move out king out of harms way
    * stalmate?(player)
    * castle(player)
    * valid_moves(piece)
        * it's only a valid move if it's a subset of piece valid move, inside the board, and doesn't put the king in harms way
    * save_board
* piece
  * for chess pieces
  * attributes
    * player
    * location
    * color
  * methods
    * valid_move?(board)
    * set_color(color)
* log
  * keeps track of chess history
  * e.g. 'Black Queen A5 => B2: Takes White Pond' (look at official notation rules)
* ai
  * AI algorithm
* serializer
  * for saving the game

### Design Decision Notes
* pieces should store a pointer to the board
* whether to use inheritance with superclasses vs proxy for multi-inheritance with mixins
  * mixins ended up being easier to use
  * there came a point when i wanted general methods in the superclass to reference methods in the subclass. I couldn't achieve this with inheritance, but modules provide a workaround.
  * favor general chess piece module for storing common methods, that are included to specific chess pieces versus chess piece super class
  * mixins also made it easier to include diag or ortho search methods for valid moves as needed. e.g. bishop needs to include diag methods, rook ortho methods, queen ortho and diag methods
* initially only stored pieces on the board
  * eventually added a hash with the chess piece object keys so the the board can reference pieces easier
  * also added a pointer to the chess board on the chess pieces so they could more easily check for valid moves
* check?
  * create a hash of all the pieces on the board, then cycle through all of them for a set of all possible moves. 
  * if the possible moves encompass opposing king, then they are checked.
* checkmate?
  * check if there is some move that can be made to get the king out of check
  * then enumerate over all pieces and possible moves, and evaluate check? until false
  * possible to create a deep copy of the board for each possible scenario, but wanted to avoid this and use the original board.
  * when, implementing, it was very important when simulating the possible move with the original board (vs making copying the board), to 1) remove combatant pieces from the board opponent pieces hash, and 2) to update the positions of the pieces themselves.
    * this is because check? uses the hash for checking all possible moves
    * valid_moves on the pieces also relies on the piece pos to compute new valid moves



