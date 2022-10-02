# frozen_string_literal: false

# require 'date'

# Serializer class for saving chess games.
class Serializer
  def initialize; end

  # Saves game state
  def serialize_game; end

  # Retrieves game state
  def deserialize_game; end

  # Init save directory
  def make_dir; end

  # Print directory contents
  def print_dir; end

  # Read files
  def read_files; end

  # Gets the current datetime for stamping files
  def timestamp
    Time.now.to_s.split[0..1].join('_')
  end
end
