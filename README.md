# Odin: Ruby Chess
Command line chess game implemented with `ruby` for the TOP `ruby` final project. [👉Live Demo.👈]("")

### Limitations
Implements basic game mechanics (movement and checkmate, etc.), but is still missing a few features:
* En passant
* Pond promotion
* Integrate castling methods with UI
* Stalemate checking

### Requirements
- [x] Properly constrained, prevent players from making illegal moves, and declare check or check mate in correct situations
- [x] Save board at any time
- [x] Write tests for important parts (TDD not required)
- [x] Keep classes modular and clean, methods each only do one thing; single responsibility principle
- [ ] (Optional) Build a very simple AI computer player
- [ ] (Optional my idea) Chaos/fun mode that scrambles the pieces into ramble positions or enable pieces to do crazy/illegal moves

### Resources
* [chess wiki](https://en.wikipedia.org/wiki/Chess)
* [illustrated rules of chess](http://www.chessvariants.org/d.chess/chess.html)
* [chess notation](https://en.wikipedia.org/wiki/Chess_notation)
* [chess unicode characters](https://en.wikipedia.org/wiki/Chess_symbols_in_Unicode)
* [for colorizing text and shading tiles](https://stackoverflow.com/questions/1489183/how-can-i-use-ruby-to-colorize-the-text-output-to-a-terminal)
* [some checkmate patterns for testing](https://www.chess.com/article/view/fastest-chess-checkmates)

### Example Gameplay
----
**E1. Intro Screen**

<img src="imgs/intro.png" width="500">

**E2. Checkmate**

<img src="imgs/checkmate.png" width="500">

**E3. Board on Setup**

<img src="imgs/board-large.png" width="500">

**E4. Syntax Highlighting**

<img src="imgs/syntax-highlight.png" width="500">

**E5. Saving/Loading Games**

<img src="imgs/save-game.png" width="500">

**E5. Logging**

<img src="imgs/log.png" width="500">