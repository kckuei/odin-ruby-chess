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
* what system for moving pieces around?
  * Specify coordinates? piece at A1 -> B2
* how do i want to save the state of the game? 
  * Marshall
* classes
  * game, player, board, piece, ai, serializer

