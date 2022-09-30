# odin-ruby-chess
Toy chess game and ruby final project for TOP

### requirements
* properly constrained, prevent players from making illegal moves, and declare check or check mate in correct situations
* Save board at any time
* write tests for important parts (TDD not required)
* keep classes modular and clean, methods each only do one thing; single responsibility principle
* (optional) build a very simple AI computer player
* (optional) chaos/fun mode that scrambles the pieces into ramble positions or enable pieces to do crazy/illegal moves

### resources
* [chess wiki](https://en.wikipedia.org/wiki/Chess)
* [illustrated rules of chess](http://www.chessvariants.org/d.chess/chess.html)
* [chess notation](https://en.wikipedia.org/wiki/Chess_notation)
* [chess unicode characters](https://en.wikipedia.org/wiki/Chess_symbols_in_Unicode)
* [chess tutorial](http://rubyquiz.com/quiz35.html)
* [ruby ai chess example](https://github.com/AlexanderRichey/RubyChess)
* [alpha zero](https://en.wikipedia.org/wiki/AlphaZero)

### questions to look into
* how can I produce the tiled chess board affect? how do I overlay a piece on top of a shaded tile?
  * See [this example](https://stackoverflow.com/questions/1489183/how-can-i-use-ruby-to-colorize-the-text-output-to-a-terminal) 
  * 8 x 8 board
  * columns numbered
  * rows letters
  * white king on black, black king on white
* board representation?
  * nested list filled populated with chess piece objects
* how should I check for valid moves?
  * hash of valid relative movements for each piece
  * check if each viable move is inside the board
  * each piece is an object with possible relative movements
* Special rules/mechanics
  * Winning condition
    * check
    * mate
    * statelmate (maybe skip for now)
  * Castling
  * Swapping peices
  * Cannot make a move that jeapordizes the king, i.e. puts it in check/check mate(maybe skip for now)
* what system for moving pieces around?
  * Specify coordinates? Start and end?
  * Given valid start, list viable/feasible end coordinates
  * A1 -> B2
* how do i want to save the state of the game? 
  * Marshall
* classes
  * game, player, board, piece, ai, serializer
* what kind of tests?
  * test for check
  * test for mate
  * test for valid moves
  * test for piece movement
  * test for board update

### classes and methods
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



# Generate new classes for movement/attack patterns. E.g.,
#
# Each piece will have a copy of one of these classes based on its designation, and saved as an attribute.
# In addition, the PieceClass will need another readable attribute, first_move?, which returns true if it is the first move of the piece.
# Should have methods
#   find_valid moves - finds the next immediate valid moves of a given piece given a gameboard
#   translate_moves - translates the indice locations to valid chess moves, e.g. a0
#
#
# all pieces
# can move onto another piece only if opposing
# only if it doesn't put the king in check
# must remain inside the board
#
# pond
# can move forward
#   2 squares if first move (only if no oposing piece at the location)
#   else 1 square (only if no opposing piece at the location)
# diaganol if attacking
#
# knight
# can move/attack in L pattern relative to its position
#
# king
# can move/attack in any direction 1 tile
# can castle if it is the king and adjacent rooks first move and there are no piece in between
#
# bishop
# can move in any diaganol direction, and distance
#
# rook
# can move in any vertical or horziontal direction, and distance
#
# queen
# can move in any direction, horizontal, vertical, diaganol, and any distance
#


# Generate new classes for movement/attack patterns. E.g.,
#
# Each piece will have a copy of one of these classes based on its designation, and saved as an attribute.
# In addition, the PieceClass will need another readable attribute, first_move?, which returns true if it is the first move of the piece.
# Should have methods
#   find_valid moves - finds the next immediate valid moves of a given piece given a gameboard
#   translate_moves - translates the indice locations to valid chess moves, e.g. a0
#
#
# all pieces
# can move onto another piece only if opposing
# only if it doesn't put the king in check
# must remain inside the board

# begin/rescues, faily gracefully when invalid input

# Loop options:
# [1] Enter a move
# [2] List valid moves of a chess piece
# [3] Save game
# [4] Quit


# was easier to use mixins vs inheritance
# favor general chesspiece module methods to specific pieces



# Need to write two methods that can be part of the ChessPieceModule
# 1 method to search diaganols
# 1 method to search horizontal/vertical
# an option limit argument can be included to make it applicable for king
# These will be used king, queen, rook, bishop

# checkmate notes
# PROBLEM
# -----------------------------------
# Problem is: check?
# It uses: @piece.find_next_valid_moves
#
# Dependent on:
# @pieces
#   if @pieces is not updated, for a piece that has been 'temp'
#   removed, check? will still attempt to find_next_valid_moves
#      problematic if we kill a piece because it will still be considered in check?
#      we need to remove it from the hash @piece temporarily
# find_next_valid_moves, @pos
#   if @pos is not updated, the valid moves are incorrect
#      remedy by updating the position as well