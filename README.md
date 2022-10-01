# odin-ruby-chess
Command line chess game for the TOP final `ruby` project.

### Requirements
* Properly constrained, prevent players from making illegal moves, and declare check or check mate in correct situations
* Save board at any time
* Write tests for important parts (TDD not required)
* Keep classes modular and clean, methods each only do one thing; single responsibility principle
* (Optional) Build a very simple AI computer player
* (Optional my idea) Chaos/fun mode that scrambles the pieces into ramble positions or enable pieces to do crazy/illegal moves

### Resources
* [chess wiki](https://en.wikipedia.org/wiki/Chess)
* [illustrated rules of chess](http://www.chessvariants.org/d.chess/chess.html)
* [chess notation](https://en.wikipedia.org/wiki/Chess_notation)
* [chess unicode characters](https://en.wikipedia.org/wiki/Chess_symbols_in_Unicode)
* [for colorizing text and shading tiles](https://stackoverflow.com/questions/1489183/how-can-i-use-ruby-to-colorize-the-text-output-to-a-terminal)
*[some fastest checkmates for testing](https://www.chess.com/article/view/fastest-chess-checkmates)

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