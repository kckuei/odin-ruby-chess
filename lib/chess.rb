# frozen_string_literal: false

require_relative './intro'
require_relative './board'
require_relative './player'
require_relative './logger'
require_relative './rules'
require 'set'

# ChessGame class.
class ChessGame
  attr_reader :board

  include Rules

  # Initializes a Chess Game.
  def initialize
    @intro = Intro.new
    @board = ChessBoard.new
    @player1 = Player.new(1, 'human')
    @player2 = Player.new(2, 'human')
    @current_player = @player1
    @log = Logger.new
    @options = { move_suggest: true }
    @goodbye = ['Hasta luego!', 'бакат!', 'Tschüß!', 'さようなら!', 'See ya next time!']
    @valid = valid_input
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
    @current_player = @player1
  end

  # Prints the start menu navigation
  def print_start_menu
    puts "\nMake a selection:\n".yellow +
         "\e[32m[1]\e[0m New game\n" +
         "\e[32m[2]\e[0m Load saved game\n" +
         "\e[32m[3]\e[0m How to play\n" +
         "\e[32m[4]\e[0m Options\n" +
         "\e[32m[5]\e[0m Exit"
  end

  # Prints the gameloop menu navigation
  def print_gameloop_menu
    puts "Move a piece by selecting a tile, e.g. #{'b7'.bold}, or make a selection:\n".yellow +
         "\e[32m[1]\e[0m Save game \e[32m[2]\e[0m Load game \e[32m[3]\e[0m Exit"
  end

  # Prints the rules
  def print_how_to_play
    puts "\nSummary: Chess How to Play\n".red
    puts RULES_PIECES
    puts RULES_CHECK
    puts RULES_CASTLING
    puts RULES_PASSANT
    puts RULES_DRAWS
    puts RULES_OTHERS
  end

  # Prints the current players turn
  def print_player_turn
    colorized = @current_player.id == 1 ? 'Player 1 turn'.red.bold : 'Player 2 turn'.blue.bold
    puts "\n#{colorized}"
  end

  # Gets user input until matches one of the valid input
  # valid: a set or list of valid items
  # menu: menu method
  # error_msg : error method, gets called on failure
  def get_user_input(valid, menu, error = -> {})
    menu.call
    input = gets.chomp.downcase
    loop do
      break if valid.include?(input.to_i) || valid.include?(input)

      error.call
      menu.call
      input = gets.chomp.downcase
    end
    input
  end

  # Enters the start menu navigation
  def start_menu
    valid = Set.new(1..5)
    input = get_user_input(valid, method(:print_start_menu))
    eval_start_menu_selection(input)
  end

  # Evaluates the start menu selection
  def eval_start_menu_selection(input)
    case input.to_i
    when 1
      new_game
    when 2
      puts "Load game hasn't been implemented yet."
    when 3
      print_how_to_play
      start_menu
    when 4
      puts "Options hasn't been implemented yet."
    when 5
      puts @goodbye.sample(1)[0].yellow
      exit
    end
  end

  # Enters the gameloop menu navigation
  def gameloop_menu
    print_player_turn
    valid = Set.new(1..3).merge(@valid)
    input = get_user_input(valid, method(:print_gameloop_menu))
    eval_loop_menu_selection(input)
  end

  # Evaluates the gameloop menu selection
  def eval_loop_menu_selection(input)
    case input.to_i
    # Evaluate the numbered selections.
    when 1
      puts "Save game hasn't been implemented yet."
    when 2
      puts "Load game hasn't been implemented yet."
    when 3
      puts @goodbye.sample(1)[0].yellow
      exit
    # Otherwise the user has selected a tile.
    else

      # Get the tile, indices and contents.
      point = @board.hash_move(input.to_sym)
      i, j = point
      nxt = @board.board[i][j]

      # Start over if the tile is empty or the piece belongs to the component.
      if nxt.empty? || nxt.player != @current_player.id
        draw_board
        msg = nxt.empty? ? 'no piece at that location.' : 'piece does not belong to player.'
        puts "\nInvalid input: #{@board.hash_point(point)}: #{msg}".magenta.italic
        return
      end

      # Otherwise it is a user piece, so get the valid moves.
      # *need integrate, safe move logic.
      moves = nxt.find_next_valid_moves

      # If the piece can't be moved anywhere, start over.
      if moves.empty?
        draw_board
        msg = "The piece can't be moved anywhere."
        puts "\nInvalid input: #{@board.hash_point(point)}: #{msg}".magenta.italic
        return
      end
      # Otherwise show the valid moves
      nxt.print_valid_moves(moves)
      puts ', back'.cyan.bold

      # Get the user input
      puts 'Select a move:'
      valid = moves.map { |move| @board.hash_point(move) }
      valid << 'back'
      menu = -> {}
      error = -> { puts 'Invalid selection. Select a different move:'.magenta.italic }
      input = get_user_input(valid, menu, error)
      if input == 'back'
        draw_board
        return
      end

      # move the piece
      dest = @board.hash_move(input.to_sym)
      force_move(point, dest)

      # report success of move
      # should update logger
      puts "Moved #{nxt.piece} from #{@board.hash_point(point).bold} to #{@board.hash_point(dest).bold}\n".green.italic

      # Render board.
      draw_board

      # Switch players
      switch_players
    end
  end

  # Declares the winner
  def declare_winner
    if @board.checkmate?(:p1)
      puts "\nCheckmate! Player 1 wins!".bold.red
    elsif @board.checkmate?(:p2)
      puts "\nCheckmate! Player 2 wins".bold.blue
    end
    puts 'Press any key to continue.'
    gets
  end

  # Toggles/switches the player turn attribute
  def switch_players
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  # Start new game
  def new_game
    setup
    draw_board
    loop do
      gameloop_menu
      if @board.checkmate?(:p1) || @board.checkmate?(:p2)
        declare_winner
        break
      end
    end
    reset
    start_menu
  end

  # Start the game
  def start
    intro_screen
    start_menu
  end

  # Returns a set of strings corresponding to all tile locations
  def valid_input
    set = Set.new
    ('a'..'h').each { |c| 8.times { |i| set.add(c + i.to_s) } }
    set
  end
end
