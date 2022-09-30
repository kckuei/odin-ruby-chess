# frozen_string_literal: false

# Player class
class Player
  attr_reader :id, :name, :type

  def initialize(id, type)
    @id = id
    @type = type
  end
end
