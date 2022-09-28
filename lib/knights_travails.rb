require 'set'

# Node class
class Node
  attr_accessor :x, :y, :dist, :path

  def initialize(x, y, dist = 0, path = [])
    @x = x
    @y = y
    @dist = dist
    @path = path
  end
end

# returns true if pos=[x,y] is inside board
def valid_pos(x, y, size)
  !(x.negative? || y.negative? || x >= size || y >= size)
end

def deep_copy(obj)
  Marshal.load(Marshal.dump(obj))
end

# returns shortest distance by knight from start to dest node using breadth-first-search traversal
def knight_moves(start, dest, size)
  # relative movements in horizontal/vertical possible by knight
  row = [2, 2, -2, -2, 1, 1, - 1, -1]
  col = [-1, 1, 1, -1, 2, -2, 2, -2]

  # initialize start and end nodes
  start_node = Node.new(start[0], start[1], dist = 0, path = [start])
  dest_node = Node.new(dest[0], dest[1])

  # set to check if the matrix cell is visited before or not
  visited = Set.new

  # create a queue and enqueue the first node
  queue = []
  queue.push(start_node)

  # loop till queue is empty
  until queue.empty?

    # dequeue front node and process it
    node = queue.shift

    x = node.x
    y = node.y
    dist = node.dist
    path = deep_copy(node.path)

    # if the destination is reached, return distance
    return node if x == dest_node.x && y == dest_node.y

    # skip if the location is visited before
    next if visited.include?(node)

    # mark the current node as visited
    visited.add(node)
    (0..row.length - 1).each do |i|
      x1 = x + row[i]
      y1 = y + col[i]
      next unless valid_pos(x1, y1, size)

      next_path = deep_copy(path) << [x1, y1]
      next_node = Node.new(x1, y1, dist + 1, next_path)
      queue.push(next_node)
    end
  end
end

def print_results(node)
  puts "You made it in #{node.dist} moves! Here's your path:"
  node.path.each { |loc| p loc }
end

size = 8
start = [0, 7]
dest = [7, 0]
final_node = knight_moves(start, dest, size)
print_results(final_node)
