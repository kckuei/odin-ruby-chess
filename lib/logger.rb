# frozen_string_literal: false

# Logger class for storing move history.
class Logger
  def initialize
    @log = clear
  end

  def clear
    @log = []
  end

  def print_log
    # Eventually probably want to do a pretty print of the log.
    # Colorized by player (blue or red) and piece (yellow), attacking or not (green).
    @log.each { |move| puts move }
  end
end
