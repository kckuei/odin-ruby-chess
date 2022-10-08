# frozen_string_literal: false

# Logger class for storing move history.
#
# https://en.wikipedia.org/wiki/Algebraic_notation_(chess)#:~:text=Each%20piece%20type%20(other%20than,a%20silent%20letter%20in%20knight).
class Logger
  attr_reader :log

  # Initialize Logger instance.
  def initialize
    @log = clear
  end

  # Clear the log
  def clear
    @log = []
  end

  # Log successful moves
  def add_success(move)
    @log << move
  end

  # Print the log.
  def print_log
    puts ''
    @log.each do |player, piece, from, to|
      player = player == 1 ? "Player #{player}".red : "Player #{player}".blue
      piece = piece.to_s.yellow
      from = from.green
      to = to.green
      puts "#{player.bold} moved #{piece} from #{from.bold} to #{to.bold}".italic
    end
  end
end
