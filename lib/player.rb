# frozen_string_literal: false

# Player class
#
# Attributes:
#   @id : integer representing the player id, 1 or 2
#   @type : string describing type of player, 'human' or 'computer'
class Player
  attr_reader :id, :name, :type
  attr_accessor :type

  def initialize(id, type)
    @id = id
    @type = type
  end

  def set_computer
    @type = 'computer'
  end

  def set_human
    @type = 'human'
  end
end
