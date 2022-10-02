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

* fix piece, pond dependency on 1 on player 1 or 2, or should be defined based on player orientation/board assignment works, but pieces move in wront direction otherwise []

* Implement logger []
  * stored as game attribute
  * passed start, end move
* Implement serializer, and save game methods []
  * mkdir
  * time/date
  * note/memo

* Replay option?

* Implement en passant []
* Implement pawn promotion []
  * the @pieces hash will need to be updated accordingly to remove old / add new
* As valid move patterns.

* Implement stalemate condition []

* Tidy/refine interface, user input and move UI scheme
* Tidy Readme
* Optional implement simple AI [prolly skip]
* Final Readme and demo page

# checkmate 1 (fool's mate)
1
r: f6 f5
b: e1 e3
r: g6 g4
b: d0 h4
works

# checkmate 2 (reversed fool's mate)
1
e6 e4
f1 f2
d6 d4
g1 g3
d7 h3
works

# checkmate 3 (grob's attack - fool's mate pattern)
1 
g6 g4
e1 e3
f6 f4
d0 h4
works

# checkmate 4 (dutch defense - fool's mate pattern)
1
d6 d4
f1 f3
c7 g3
h1 h2
g3 h4
g1 g3
e6 e4
g3 h4
d7 h3
works

# checkmate 5 (bird's opening - fool's mate pattern)
1
f6 f4
e1 e3
f4 e3
d1 d2
e3 d2
f0 d2
b7 c5
d0 h4
g6 g5
h4 g5
h6 g5
d2 g5
works!

# checkmate 6 (Caro-kann Defense smothered mate)

1
e6 e4
c1 c2
d6 d4
d1 d3
b7 c5
d3 e4
b0 d1
d7 e6
g0 f2
e4 d2
works!

# checkmate 7 (Italian Game Smothered Mate)

1
e6 e4
e1 e3
g7 f5
b0 c2
f7 c4
c2 d4
f5 e3
d0 g3
e3 f1
g3 g6
h7 f7
g6 e4
c4 e6
d4 f5
works

# Checkmate 8 (Owen's Defense - Fool's Mate Pattern)

1
e6 e4
b1 b2
d6 d4
c0 b1
f7 d5
f1 f3
e4 f3
b1 g6
d7 h3
g1 g2
f3 g2
g0 f2
g2 h1
f2 h3
d5 g2
works!

# Checkmate 9 (Englund Gambit Mate)

1 
d6 d4
e1 e3
d4 e3
d0 e1
g7 f5
b0 c2
c7 f4
e1 b4
f4 d6
b4 b6
d6 c5
f0 b4
d7 d6
b4 c5
d6 c5
b6 c7
works!

# Checkmate 10 (Budapest Defense Smothered Mate)

1
d6 d4
g0 f2
c6 c4
e1 e3
d4 e3
f2 g4
g7 f5
b0 c2
c7 f4
f0 b4
b7 d6
d0 e1
a6 a5
g4 e3
a5 b4
e3 d5
works!



