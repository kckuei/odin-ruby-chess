## To do
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
* Implment checkmate []
  * Issue: I should only iterate over pieces that are ON the board when doing check/chekmate.
  * Undecided:
    * should i remove the keys/values in @pieces once the pieces have been killed/are no longer on the board?..yes
    * will this interfere with checkmate logic?..no it won't because we're directly manipulating the board, not using force_move.
  * maybe add the key to the pieces as well, so I can reference them easily.

* force_move should update first_move as well.

* Implement player class [DONE_ALREADY]
* Update castle to use hash []
* Implement game loop mechanism []

* Implement pawn promotion
  * the @pieces hash will need to be updated accordingly to remove old / add new

* Implement logger
* Implement serializer, and save game methods

* A move is not valid if it puts the king in jeopardy
* Implement stalemate condition [HOW?]

* Game loop selection
  * save game
  * move piece
  * show valid moves for piece
  * exit
* Implement menu selection
  * new game
  * load game
  * rules
  * color settings possibly
  * computer opponent possibly
* Implement end game selection
  * new game
  * log output

* Tidy/refine interface, user input and move UI scheme
* Tidy Readme
* Optional implement simple AI
* Final Readme and demo page