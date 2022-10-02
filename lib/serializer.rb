# frozen_string_literal: false

require_relative './string'
# require 'date'

# Serializer class for saving and loading chess games.
#
# Example usage:
#   require_relative './lib/chess'
#   game = ChessGame.new
#   game.add_note('game 2')
#   game.save_game
#   game_copy = game.load_game('2022-10-02_09:52:59.chessbin')
#   game.print_saves
class Serializer
  def initialize(dirname: './saves')
    @dirname = dirname
  end

  # Saves game state.
  # game : ChessGame
  def serialize_game(game)
    make_dir
    str = Marshal.dump(game)
    filename = "#{timestamp}.chessbin"
    File.open("#{@dirname}/#{filename}", 'w') { |f| f.puts(str) }
  rescue Standard => e
    puts "Ran into an error with serializing the chess save file: #{e}".red
  else
    puts "Saved chess state: #{filename} to #{@dirname}".green
  end

  # Retrieves game state.
  # filename : string, filename of the chess game saved state
  def deserialize_game(filename)
    file = File.open("#{@dirname}/#{filename}", 'r')
  rescue StandardError => e
    puts "Ran into an error with deserializing the chess save file: #{e}".red
  else
    str = file.read
    file.close
    game_state = Marshal.load(str)
    puts "Loaded chess state: #{filename}".green
    game_state
  end

  # Inits save directory if it does not exist.
  def make_dir
    Dir.mkdir(@dirname) unless File.exist? @dirname
  rescue Standard => e
    puts "Ran into an error with creating a save directory: #{e}".red
  else
    puts "Created a save directory: #{@dirname}".yellow
  end

  # Gets the list of states.
  # Returns the the full file paths.
  def list_of_saves
    Dir.glob("#{@dirname}/*.{chessbin}")
  end

  # Print directory contents.
  def print_saves
    list_of_saves.each_with_index do |full_fnames, index|
      tag = full_fnames.delete("#{@dirname}/chessbin")
      file = File.open(full_fnames, 'r')
      str = file.read
      file.close
      game = Marshal.load(str)
      puts "[#{index}] ".green << tag.yellow << " #{game.note}"
    end
  end

  # Gets the current datetime for stamping files
  def timestamp
    Time.now.to_s.split[0..1].join('_')
  end
end
