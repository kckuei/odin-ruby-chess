# frozen_string_literal: false

# Player class
class Player
  attr_reader id:, :name, :type
  def initialize(id, name, type)
    @id = id
    @name = name
    @type = type
  end
end
