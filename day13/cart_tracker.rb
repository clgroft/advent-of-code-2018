class Cart
  attr_accessor :x, :y, :dir, :next_plus_turn

  def initialize(x, y, dir)
    @x = x
    @y = y
    @dir = dir
    @next_plus_turn = :left
  end

  def position
    [y,x]
  end

  def advance
    case dir
    when "<"
      self.x -= 1
    when ">"
      self.x += 1
    when "^"
      self.y -= 1
    when "v"
      self.y += 1
    end
  end

  SLASH_TURN = {"<" => "v", "v" => "<", ">" => "^", "^" => ">"}.freeze
  BACKSLASH_TURN = {"<" => "^", "^" => "<", ">" => "v", "v" => ">"}.freeze
  LEFT_TURN = {"<" => "v", "v" => ">", ">" => "^", "^" => "<"}.freeze
  RIGHT_TURN = {"<" => "^", "^" => ">", ">" => "v", "v" => "<"}.freeze

  def turn(grid_char)
    case grid_char
    when "/"
      self.dir = SLASH_TURN[dir]
    when "\\"
      self.dir = BACKSLASH_TURN[dir]
    when "+"
      case next_plus_turn
      when :left
        self.dir = LEFT_TURN[dir]
        self.next_plus_turn = :straight
      when :straight
        self.next_plus_turn = :right
      when :right
        self.dir = RIGHT_TURN[dir]
        self.next_plus_turn = :left
      end
    end
  end
end

grid = File.open("day13/input.txt") { |f| f.each_line.map(&:chars) }

# Carts are keyed by [column, row] for natural sort order
TRACK_DIRECTIONS = {"<" => "-", ">" => "-", "^" => "|", "v" => "|"}.freeze
carts = {}
grid.each_with_index do |row, j|
  row.each_with_index do |cell, i|
    track = TRACK_DIRECTIONS[cell]
    if track
      carts[[j,i]] = Cart.new(i, j, cell)
      row[i] = track
    end
  end
end

while carts.size > 1
  carts.keys.sort.each do |p|
    cart = carts[p]
    next unless cart # could have died to an earlier collision

    cart.advance
    cart.turn(grid[cart.y][cart.x])

    new_p = cart.position
    carts.delete(p)

    if carts[new_p]
      puts "Collision at #{cart.x},#{cart.y}"
      carts.delete(new_p)
    else
      carts[new_p] = cart
    end
  end
end

final_cart = carts.values.first
puts "Final cart at #{final_cart.x},#{final_cart.y}"
