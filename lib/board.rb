require_relative './string'

def make_gameboard(rows, columns)
  board = []
  rows.times { board << Array.new(columns, '') }
  board
end

def draw_board(show_open_moves = false)
  puts "\n  ╔════════════════╗"
  k = 0
  (0..@rows - 1).each do |i|
    offset =  i.even? ? 0 : 1
    print "#{i} "
    draw_vertical_divider
    (0..@columns - 1).each do |j|
      k += 1
      draw_value(@board[i][j], k, show_open_moves, offset)
      draw_vertical_divider if j == @columns - 1
    end
    draw_horizontal_divider if i < @rows - 1
  end
  puts "\n  ╚════════════════╝"
  puts '  ' << ('a'..'h').reduce(' ') { |a, letter| a << letter.center(2, ' ') } << "\n\n"
end

# Adds consistent padding so board draws correctly.
# Supports draw_board.
def format(val, tile = '')
  tile == 'dark' ? val.to_s.center(2, ' ').bg_gray : val.to_s.center(2, ' ')
end

# Draw value
# Supports draw_board.
def draw_value(val, idx, show_open_moves, offset)
  if val.empty?
    if show_open_moves
      print format(idx)
    elsif (idx + offset).odd?
      print format('', 'dark')
    else
      print format('')
    end
  elsif (idx + offset).odd?
    print format(val, 'dark')
  else
    print format(val)
  end
end

# Draw vertical divider.
# Supports draw_board.
def draw_vertical_divider
  #   print "\e[91m║\e[0m"
  # print "\e[91m|\e[0m"
  print '║'
end

# Draws a horizontal divider.
# Supports draw_board.
def draw_horizontal_divider
  row = "\n  "
  #   (@columns - 1).times { row << "\e[91m═══╬\e[0m" }
  #   row << "\e[91m═══\e[0m"
  #   (@columns - 1).times { row << "\e[91m───┼\e[0m" }
  #   row << "\e[91m───\e[0m"
  #   puts row
  puts ''
end

@rows =  8
@columns = 8

@board = make_gameboard(8, 8)
p @board

@board[0][0] = '♙'
@board[0][1] = '♘'
@board[0][2] = '♗'
@board[0][3] = '♖'
@board[0][4] = '♕'
@board[0][5] = '♔'

@board[7][0] = '♟'
@board[7][1] = '♞'
@board[7][2] = '♝'
@board[7][3] = '♜'
@board[7][4] = '♛'
@board[7][5] = '♚'

draw_board

# Need to make the pieces easier to differentiate/consistent. Maybe red vs plain color.
# When drawing the board, method needs to check the object, and what team it is on.

# Need to decide if I want 3 pad or not for centering letters and pieces, aspect is out if so
