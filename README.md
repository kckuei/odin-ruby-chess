# Odin: Ruby Chess
A command line chess game implemented with `ruby` for the TOP ruby final project. Uses a composition-ish object-oriented programming approach.

Implements most of the basic game mechanics (i.e., movement, check, checkmate, castling, pond promotion, etc.), in addition to a few easter egg features (e.g. chaos modes). Play against another human, a computer, or spectate by setting up two computers to play against each other in the options menu.

[👉Live Demo👈](https://replit.com/@KevinKuei/Odin-Ruby-Chess#main.rb)

## Demonstration
<a href="https://www.youtube.com/watch?v=W-tnn7g5kRQ">
<img alt="demo" src="imgs/demo.png" width="800">
</a>

## Requirements
- [x] Properly constrained, prevent players from making illegal moves, and declare check or check mate in correct situations
- [x] Save board at any time
- [x] Write tests for important parts
- [x] Keep classes modular and clean, methods each only do one thing; single responsibility principle
- [x] (Optional) Build a very simple AI computer player
- [x] (Optional) Chaos/fun mode that scrambles the pieces into random positions

## Limitations
* [En passant](https://en.wikipedia.org/wiki/En_passant) move for ponds not implemented.
* Replay mode not yet implemented.

## Resources
* [Chess Wiki](https://en.wikipedia.org/wiki/Chess)
* [Illustrated rules of chess](http://www.chessvariants.org/d.chess/chess.html)
* [Chess Notation](https://en.wikipedia.org/wiki/Chess_notation)
* [Chess Unicode Characters](https://en.wikipedia.org/wiki/Chess_symbols_in_Unicode)
* [Colorizing Text](https://stackoverflow.com/questions/1489183/how-can-i-use-ruby-to-colorize-the-text-output-to-a-terminal)
* [Checkmate Patterns for Testing](https://www.chess.com/article/view/fastest-chess-checkmates)

## Gameplay

### Splash Screen
Because who doesn't like a nice ascii splash screen?

<img src="imgs/intro.png" width="500">

### Checkmate
Yes, it works! :) Load up one of the checkmate demos and verify for yourself!

<img src="imgs/checkmate.png" width="500">

### Check (Safe Move Enforcement)
Where's the Kingsguard? Protect the King! 

<img src="imgs/check.png" width="500">

### Castling
Castling can be called from either the rook or the king, if applicable.

<img src="imgs/castle.png" width="500">

#### Pond Promotion
Give that hardworking pond that long overdue promotion! ...and uh, sex change!

<img src="imgs/promotion.png" width="500">

### Syntax Highlighting
Not sure what move to make next? Let syntax highlighting assist you--just choose violence by picking the red moves!

<img src="imgs/syntax-highlight.png" width="500">

### Saving Games
Have other things to do? No problem, save your game...

<img src="imgs/save-game.png" width="500">

### Loading Games
...and then pick up where you left off!

<img src="imgs/load-game.png" width="500">

### Standard Mode
Play your standard vanilla chess game...

<img src="imgs/board-large.png" width="500">

### Standard Chaos Mode
...or spice things up with standard chaos mode!

<img src="imgs/standard-chaos.png" width="500">

### Chaos² Mode
...or if you're feeling **extra** adventurous, try Chaos²!

<img src="imgs/chaos.png" width="500">

### Logging
Ever wonder you did/were doing a minute ago? Be at ease, with move logging. 

<img src="imgs/log.png" width="500">