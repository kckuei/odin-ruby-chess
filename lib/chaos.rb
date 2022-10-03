# frozen_string_literal: false

# Chaos module.
# For non-standard, chaotic fun! :)
module Chaos
  # Returns a scrambled (randomly sampled) list of the tile coordinates
  # for the rows between from and to, for chaos mode player.
  #
  # from : integer representing start row
  # to : integer representing end row
  #
  # E.g., from, to = 0, 1  for player 2
  #       from, to = 6, 7  for player 1
  def sample_chaos(from, to)
    grid = []
    (from..to).each { |i| @columns.times { |j| grid << [i, j] } }
    samples = (0..grid.length-1).to_a.sample(grid.length)
    samples.map { |i| grid[i] }
  end

  # Scrambles a players pieces for the rows betwen from and to.
  #
  # from : integer representing start row
  # to : integer representing end row
  # player_sym : player symbol, :p1 or :p2
  def scramble_rows_from(from, to, player_sym)
    coords = sample_chaos(from, to)
    @pieces[player_sym].each_with_index do |(_key, piece), i|
      m, n = coords[i]
      piece.update_position([m, n])
      @board[m][n] = piece
    end
  end

  # Scrambles the chess pieces for player 1 and 2!
  # Should be applied right after board setup.
  def scramble_board
    # scramble_rows_from(6, 7, :p1)
    # scramble_rows_from(0, 1, :p2)

    coords = sample_chaos(6, 7)
    @pieces[:p1].each_with_index do |(_key, piece), i|
      m, n = coords[i]
      piece.update_position([m, n])
      @board[m][n] = piece
    end

    coords = sample_chaos(0, 1)
    @pieces[:p2].each_with_index do |(_key, piece), i|
      m, n = coords[i]
      piece.update_position([m, n])
      @board[m][n] = piece
    end
  end
end
