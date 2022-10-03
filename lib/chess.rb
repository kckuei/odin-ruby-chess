# frozen_string_literal: false

require_relative './intro'
require_relative './board'
require_relative './player'
require_relative './logger'
require_relative './rules'
require_relative './serializer'
require 'set'

# ChessGame class.
#
# Attributes
#   @intro - pointer to Intro object for intro screen
#   @board - pointer to ChessBoard object
#   @player1 - pointer to player 1 Player object
#   @player2 - pointer to player 2 Player object
#   @current_player - pointer to current active player
#   @log - pointer to Log object
#   @options - hash of options mode
#   @goodbye - array of goodbyes
#   @valid - a set representing all valid chess code for the tiles on the board.
#            could be removed, or moved to board.
#   @note - string for game note tags for saved states
class ChessGame
  attr_reader :board, :player1, :player2, :current_player, :log, :serializer, :options, :note

  include Rules

  # Initializes a Chess Game.
  def initialize
    @intro = Intro.new
    @board = ChessBoard.new
    @player1 = Player.new(1, 'human')
    @player2 = Player.new(2, 'human')
    @current_player = @player1
    @log = Logger.new
    @serializer = Serializer.new
    @options = { move_suggest: true, init_mode: 'standard' }
    @goodbye = ['Hasta luego!', 'бакат!', 'Tschüß!', 'さようなら!', 'See ya next time!']
    @valid = valid_input
    @note = ''
  end

  # Saves the game state.
  def save_game
    print 'Add a save note or ENTER to continue: '
    add_note(gets.chomp)
    @serializer.serialize_game(self)
  end

  # Loads the game state.
  # returns 0 - don't draw anything.
  # returns 1 - draw board.
  def load_game
    # Queries user selection.
    menu = lambda {
      puts 'Select a game state to load or go back: '.yellow
      print_saves
      puts 'back'.cyan
    }
    saves = @serializer.list_of_saves
    valid = Set.new(0..saves.length)
    valid.add('back')
    input = get_user_input(valid, menu)
    return 0 if input == 'back' && @board.pieces.empty?
    return 1 if input == 'back' && !@board.pieces.empty?

    # Deserializes state.
    fullpath = saves[input.to_i]
    game_obj = @serializer.deserialize_game(fullpath)

    # Transfers the mutable state attributes.
    @board = game_obj.board
    @player1 = game_obj.player1
    @player2 = game_obj.player2
    @current_player = game_obj.current_player
    @log = game_obj.log
    @serializer = game_obj.serializer
    @options = game_obj.options
    @note = game_obj.note

    # draw_board
    1
  end

  # Add game note for saving.
  def add_note(string)
    @note = string
  end

  # Print saves
  def print_saves
    @serializer.print_saves
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

  # Prints the start menu navigation.
  def print_start_menu
    puts "\nMake a selection:\n".yellow +
         "\e[32m[1]\e[0m New game\n" +
         "\e[32m[2]\e[0m Load saved game\n" +
         "\e[32m[3]\e[0m How to play\n" +
         "\e[32m[4]\e[0m Options\n" +
         "\e[32m[5]\e[0m Exit"
  end

  # Prints the gameloop menu navigation.
  def print_gameloop_menu
    puts "Move a piece by selecting a tile, e.g. #{'b7'.bold}, or make a selection:\n".yellow +
         "\e[32m[1]\e[0m Save game \e[32m[2]\e[0m Load game \e[32m[3]\e[0m Print move log \e[32m[4]\e[0m Exit"
  end

  # Prints the rules.
  def print_how_to_play
    puts "\nSummary: Chess How to Play\n".red
    puts RULES_PIECES
    puts RULES_CHECK
    puts RULES_CASTLING
    puts RULES_PASSANT
    puts RULES_DRAWS
    puts RULES_OTHERS
  end

  # Prints the options.
  def print_options_menu
    puts "\nMake a selection:\n".yellow +
         "\e[32m[1]\e[0m Standard\n" +
         "\e[32m[2]\e[0m Standard Chaos\n" +
         "\e[32m[3]\e[0m Chaos²"
  end

  # Prints the current players turn.
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

  # Enters the start menu navigation.
  def start_menu
    valid = Set.new(1..5)
    input = get_user_input(valid, method(:print_start_menu))
    eval_start_menu_selection(input)
  end

  # Evaluates the start menu selection.
  def eval_start_menu_selection(input)
    case input.to_i
    # Sets up a new board, then enters the game loop.
    when 1
      setup
      @board.scramble_muster if options[:init_mode] == 'standard chaos'
      @board.scramble_battlefield if options[:init_mode] == 'chaos'
      new_game
    # Loads the game state, then enters the game loop.
    when 2
      load_game
      @board.pieces.empty? ? start_menu : new_game
    # Prints rules of the game, and returns to start menu.
    when 3
      print_how_to_play
      start_menu
    # Sets gaming options and easter eggs.
    when 4
      options_menu
      start_menu
    # Exits with random farewell.
    when 5
      puts @goodbye.sample(1)[0].yellow
      exit
    end
  end

  # Enters options menu navigation.
  def options_menu
    valid = Set.new(1..3)
    input = get_user_input(valid, method(:print_options_menu))
    eval_options_menu(input)
  end

  # Evaluates the options menu selection
  def eval_options_menu(input)
    case input.to_i
    when 1
      @options[:init_mode] = 'standard'
    when 2
      @options[:init_mode] = 'standard chaos'
    when 3
      @options[:init_mode] = 'chaos'
    end
  end

  # Enters the gameloop menu navigation.
  def gameloop_menu
    print_player_turn
    valid = Set.new(1..4).merge(@valid)
    input = get_user_input(valid, method(:print_gameloop_menu))
    eval_loop_menu_selection(input)
  end

  # Evaluates the gameloop menu selection.
  def eval_loop_menu_selection(input)
    case input.to_i
    # Saves the game.
    when 1
      save_game
    # Loads a saved game.
    when 2
      render_flag = load_game
      draw_board if render_flag == 1
    # Prints the current state move log.
    when 3
      @log.print_log
    # Exits the game with random farewell.
    when 4
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

      # Otherwise it is a user piece, so get the valid moves (ignoring safety).
      moves = nxt.find_next_valid_moves

      # If the piece can't be moved anywhere, start over.
      if moves.empty?
        draw_board
        msg = "The piece can't be moved anywhere."
        puts "\nInvalid input: #{@board.hash_point(point)}: #{msg}".magenta.italic
        return
      end
      # Otherwise show the valid moves.
      nxt.print_valid_moves(moves)
      puts ', back'.cyan.bold

      # The user must either pick a valid move which does not put the
      # king in danger or go back.
      move_is_safe = false
      until move_is_safe
        # Get the user input.
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
        from = nxt.pos
        to = @board.hash_move(input.to_sym)
        if @board.safe?(from, to)
          move_is_safe = true
        else
          puts 'Invalid selection. The King must be protected!'.magenta.italic
        end
      end

      # Move the piece.
      dest = @board.hash_move(input.to_sym)
      force_move(point, dest)

      # Log successful move.
      log_move(nxt.player, nxt.piece,
               @board.hash_point(point), @board.hash_point(dest))

      # Render board.
      draw_board

      # Switch players
      switch_players
    end
  end

  # Logs successful moves to logger.
  def log_move(player, piece, from, to, echo: true)
    @log.add_success([player, piece, from, to])
    puts "Moved #{piece} from #{from.bold} to #{to.bold}\n".green.italic if echo
  end

  # Declares the winner.
  def declare_winner
    if @board.checkmate?(:p1)
      puts "\nCheckmate! Player 2 wins!".bold.blue
    elsif @board.checkmate?(:p2)
      puts "\nCheckmate! Player 1 wins".bold.red
    end
    puts 'Press any key to continue.'
    gets
  end

  # Declares check.
  def declare_check(symbol)
    case symbol
    when :p1
      puts "\nPlayer 1 check! Protect the King!".bold.red
    when :p2
      puts "\nPlayer 2 check! Protect the King".bold.blue
    end
  end

  # Toggles/switches the player turn attribute.
  def switch_players
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  # Implements one full game loop.
  def new_game
    draw_board
    loop do
      gameloop_menu
      @board.ponds_to_promote.each { |piece| @board.promote(piece) } if @board.promote_any?
      if @board.checkmate?(:p1) || @board.checkmate?(:p2)
        declare_winner
        break
      elsif @board.check?(:p1)
        declare_check(:p1)
      elsif @board.check?(:p2)
        declare_check(:p2)
      end
    end
    reset
    start_menu
  end

  # Starts the game.
  def start
    intro_screen
    start_menu
  end

  # Returns a set of strings corresponding to all tile locations.
  def valid_input
    set = Set.new
    ('a'..'h').each { |c| 8.times { |i| set.add(c + i.to_s) } }
    set
  end
end
