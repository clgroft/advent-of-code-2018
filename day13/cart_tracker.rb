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
      @x -= 1
    when ">"
      @x += 1
    when "^"
      @y -= 1
    when "v"
      @y += 1
    end
  end

  SLASH_TURN = {"<" => "v", "v" => "<", ">" => "^", "^" => ">"}
  BACKSLASH_TURN = {"<" => "^", "^" => "<", ">" => "v", "v" => ">"}
  LEFT_TURN = {"<" => "v", "v" => ">", ">" => "^", "^" => "<"}
  RIGHT_TURN = {"<" => "^", "^" => ">", ">" => "v", "v" => "<"}

  def turn(grid_char)
    case grid_char
    when "/"
      @dir = SLASH_TURN[dir]
    when "\\"
      @dir = BACKSLASH_TURN[dir]
    when "+"
      case next_plus_turn
      when :left
        @dir = LEFT_TURN[dir]
        @next_plus_turn = :straight
      when :straight
        @next_plus_turn = :right
      when :right
        @dir = RIGHT_TURN[dir]
        @next_plus_turn = :left
      end
    end
  end
end

grid = nil
carts = {}
File.open("day13/input.txt") do |f|
  grid = f.each_line.map(&:chars)
  grid.each_with_index do |row, j|
    row.each_with_index do |cell, i|
      # replace <>^v with --|| and create a cart
      case cell
      when "<"
        carts[[j,i]] = Cart.new(i, j, "<")
        row[i] = "-"
      when ">"
        carts[[j,i]] = Cart.new(i, j, ">")
        row[i] = "-"
      when "^"
        carts[[j,i]] = Cart.new(i, j, "^")
        row[i] = "|"
      when "v"
        carts[[j,i]] = Cart.new(i, j, "v")
        row[i] = "|"
      else
        # do nothing
      end
    end
  end
end

while carts.size > 1
  curr_positions = carts.keys.sort
  curr_positions.each do |p|
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
