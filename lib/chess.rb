# frozen_string_literal: false

require_relative './intro'
require_relative './board'
require_relative './logger'
require 'set'

# ChessGame class.
class ChessGame
  attr_reader :board

  # Initializes a Chess Game.
  def initialize
    @intro = Intro.new
    @board = ChessBoard.new
    @log = Logger.new
    @options = { move_suggest: true }
    @goodbye = ['Hasta luego!', 'бакат!', 'Tschüß!', 'さようなら!', 'See ya next time!']
  end

  # Displays the game intro screen.
  def intro_screen
    puts @intro.to_s
  end

  # Renders the chess board and pieces.
  def draw_board
    @board.draw_board
  end

  # Returns the chess object at the tile location.
  # tile : a symbol representing the tile at a particular location
  def piece_at(tile)
    i, j = @board.hash_move(tile)
    @board.board[i][j]
  end

  # Force moves a piece without consideration of whether it is a valid move.
  # Just intended for testing for now.
  # from : a string or symbol, representing the starting tile to move a piece from
  # to : a string or symbol, representing the ending tile to move a piece to
  def force_move(from, to)
    from = from.instance_of?(String) ? @board.hash_move(from.to_sym) : from
    to = to.instance_of?(String) ? @board.hash_move(to.to_sym) : to
    @board.force_move(from, to)
  end

  # Inits/populates the chess board with pieces.
  def setup
    @board.setup_standard_game
  end

  # Clears the board and log for a new game.
  def reset
    @board = ChessBoard.new
    @log = Logger.new
  end

  def print_start_menu
    puts "\nMake a selection:
    \e[32m[1]\e[0m New game
    \e[32m[2]\e[0m Load saved game
    \e[32m[3]\e[0m How to play
    \e[32m[4]\e[0m Options
    \e[32m[5]\e[0m Exit
    "
  end

  def print_gameloop_menu
    puts "\nMake a selection:
    \e[32m[1]\e[0m Enter a move
    \e[32m[2]\e[0m Save game
    \e[32m[3]\e[0m Quit
    "
  end

  def print_how_to_play
    puts "\e[33mChess - How to Play\e[0m
    Check out these guides:
    \e[33m[1]\e[0m https://www.chess.com/lessons/playing-the-game
    \e[33m[2]\e[0m https://en.wikipedia.org/wiki/Rules_of_chess
    "
  end

  def start_menu
    valid = Set.new(1..5)
    print_start_menu
    input = gets.chomp.to_i
    loop do
      break if valid.include?(input)

      print_start_menu
      input = gets.chomp.to_i
    end
    eval_start_menu_selection(input)
  end

  def eval_start_menu_selection(input)
    case input
    when 1
      new_game
    when 2
      # To be implemented...load saved state
    when 3
      print_how_to_play
      start_menu
    when 4
      # To be implemented...options..maybe for color or scrambling pieces
      # Maybe option to turn off automatic move suggestion?
    when 5
      puts @goodbye.sample(1)[0].yellow
      exit
    end
  end

  def gameloop_menu
    valid = Set.new(1..3)
    print_gameloop_menu
    input = gets.chomp.to_i
    loop do
      break if valid.include?(input)

      print_gameloop_menu
      input = gets.chomp.to_i
    end
    eval_loop_menu_selection(input)
  end

  def eval_loop_menu_selection(input)
    # Print player turn
    case input
    when 1
      # Get current player move
      #
      # Pick a piece to move, e.g. 'b7'
      # Validate the move
      #
    when 2
      # Save the game, then...
      puts "I should have saved your game but didn't because I haven't been implemented yet."
      gameloop_menu
    when 3
      puts @goodbye.sample(1)[0].yellow
      exit
    end
    # Toggle the active player
  end

  def new_game
    setup
    draw_board
    gameloop_menu
    # end game message
    # view log, or any key to continue to new game
    reset
    start_menu
  end

  # Start the game
  def start
    intro_screen
    start_menu
  end
end

# Parse user input
# Is it in the board? Is there a piece there? Does it belong to the player?
# If not, query again.
# If yes, get the valid moves, and print them.
#   Query for next move
#   Loop until valid move or to go back
#   If go back flag, then
