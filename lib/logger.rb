# frozen_string_literal: false

# Logger class for storing move history.
#
# https://en.wikipedia.org/wiki/Algebraic_notation_(chess)#:~:text=Each%20piece%20type%20(other%20than,a%20silent%20letter%20in%20knight).
class Logger
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
    # Modify for pretty print.
    @log.each { |move| puts move }
  end
end
