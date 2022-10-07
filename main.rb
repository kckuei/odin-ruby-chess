# frozen_string_literal: false

require_relative './lib/chess'

game = ChessGame.new
game.start

# Let's make it so player 1 or player 2 can be computers
# For any player computer, use an algorithm to pick and execute their moves.
# If there are two computers, then we do this for both players,
# and add a delay/sleep so we can watch.
# Perhaps the delay/sleep time should be setting as a speed.

# By having the two players play against each other, we can 
# simulate a whole game.
# On the other hand, if our algorithm is too dumb, then, it will take forever to finish the game.
