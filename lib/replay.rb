# frozen_string_literal: false

# Work in progress. Not yet integrated.

# module for replaying games.
module Replay
  def view_replay
    menu = lambda {
      puts 'Select a game state to replay: '.yellow
      print_saves
      puts 'back'.cyan
    }
    saves = @serializer.list_of_saves
    valid = Set.new(0..saves.length)
    valid.add('back')
    input = get_user_input(valid, menu)
    return 0 if input == 'back' && @board.pieces.empty?
    return 1 if input == 'back' && !@board.pieces.empty?

    # Deserializes state.
    fullpath = saves[input.to_i]
    game_obj = @serializer.deserialize_game(fullpath)

    @log = game_obj.log

    ##### Experimenting with replay
    ##### Just need to fetch the log.
    temp_board = ChessBoard.new
    temp_board.new_game
    temp_board.draw_board
    sleep(0.5)
    @log.log.each do |move|
      start_tile = temp_board.hash_move(move[2].to_sym)
      end_tile = temp_board.hash_move(move[3].to_sym)
      temp_board.force_move(start_tile, end_tile)
      temp_board.draw_board
      sleep(0.5)
    end
  end
end
