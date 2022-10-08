# frozen_string_literal: false

# IntegerError class exception
class IntegerError < StandardError
  def initialize(msg = 'Input must be a board tile, e.g. b6', exception_type = 'custom')
    @exception_type = exception_type
    super(msg)
  end
end
