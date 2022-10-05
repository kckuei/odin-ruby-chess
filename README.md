# Odin: Ruby Chess
Toy command line chess game implemented with `ruby` for the TOP `ruby` final project. Uses a composition-ish object-oriented programming approach to it's implementation.

[👉Live Demo👈](https://replit.com/@KevinKuei/Odin-Ruby-Chess#main.rb)

#### Demonstration
<a href="https://www.youtube.com/watch?v=W-tnn7g5kRQ">
<img alt="demo" src="imgs/demo.png" width="800">
</a>

### Requirements
- [x] Properly constrained, prevent players from making illegal moves, and declare check or check mate in correct situations
- [x] Save board at any time
- [x] Write tests for important parts
- [x] Keep classes modular and clean, methods each only do one thing; single responsibility principle
- [x] (Optional)(my idea) Chaos/fun mode that scrambles the pieces into random positions
- [ ] (Optional) Build a very simple AI computer player

### Limitations
Implements most of the basic game mechanics (i.e., movement, check, checkmate, castling, pond promotion, etc.), but is still missing a few features:
* En passant
* Stalemate checking

### Resources
* [Chess Wiki](https://en.wikipedia.org/wiki/Chess)
* [Illustrated rules of chess](http://www.chessvariants.org/d.chess/chess.html)
* [Chess Notation](https://en.wikipedia.org/wiki/Chess_notation)
* [Chess Unicode Characters](https://en.wikipedia.org/wiki/Chess_symbols_in_Unicode)
* [Colorizing Text](https://stackoverflow.com/questions/1489183/how-can-i-use-ruby-to-colorize-the-text-output-to-a-terminal)
* [Checkmate Patterns for Testing](https://www.chess.com/article/view/fastest-chess-checkmates)

### Example Gameplay
----
#### Splash Screen
Because who doesn't like ascii art?

<img src="imgs/intro.png" width="500">

#### Checkmate
Yes, it works! You can test it yourself by loading one of the ten saved states!

<img src="imgs/checkmate.png" width="500">

#### Check (Safe Move Enforcement)
Where's the Kinguard? Protect the King!

<img src="imgs/check.png" width="500">

#### Castling
Castle from your rook/king!

<img src="imgs/castle.png" width="500">

#### Pond Promotion
Give that hardworking pond that long overdue promotion!

<img src="imgs/promote.png" width="500">

#### Syntax Highlighting
Feeling lazy? Let syntax highlighting assist. you. Just pick the red moves!

<img src="imgs/syntax-highlight.png" width="500">

#### Saving Games
Have other things to do like eating cereal? No problem, we can serialize your game!

<img src="imgs/save-game.png" width="500">

#### Loading Games
Pick up from where you left off! (Try some of the demos to verify the game functionality ofr yourself!)

<img src="imgs/load-game.png" width="500">

#### Standard Mode
Play your standard chess game...

<img src="imgs/board-large.png" width="500">

#### Standard Chaos Mode
Or if your feeling adventurous, mix the pieces up a bit...

<img src="imgs/standard-chaos.png" width="500">

#### Chaos² Mode
Or if you're feeling **extra** adventurous, spice up your life with Chaos².

<img src="imgs/chaos.png" width="500">

#### Logging
Ever wonder you did/were doing a minute ago? No worries, we got you covered with logging. :)

<img src="imgs/log.png" width="500">