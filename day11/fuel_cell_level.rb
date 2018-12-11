class FuelCellGrid
  def initialize(serial_no)
    @serial_no = serial_no
  end

  def power_level(x, y)
    rack_id = x + 10
    level = rack_id * y + @serial_no
    level *= rack_id
    (level / 100).to_i % 10 - 5
  end
end

grid = FuelCellGrid.new(9810)
values = (1..300).map { |x| (1..300).map { |y| grid.power_level(x,y) } }

max_power_level = -50
arg_max_power_level = nil
(1..298).each do |x|
  (1..298).each do |y|
    square_power_level = (x-1..x+1).map { |x1| (y-1..y+1).map { |y1| values[x1][y1] }.sum }.sum
    if square_power_level > max_power_level
      max_power_level = square_power_level
      arg_max_power_level = [x, y]
    end
  end
end

puts "#{arg_max_power_level}, power level #{max_power_level}"

max_power_level = -50
arg_max_power_level = nil

(1..300).each do |s|
  collapses = values.map { |col| (0..300-s).map { |y| col[y...y+s].sum } }
  collapses = collapses.transpose.map { |row| (0..300-s).map { |x| row[x...x+s].sum } }.transpose
  (1..301-s).each do |x|
    (1..301-s).each do |y|
      square_power_level = collapses[x-1][y-1]
      if square_power_level > max_power_level
        max_power_level = square_power_level
        arg_max_power_level = [x,y,s]
      end
    end
  end
end

puts "#{arg_max_power_level}, power level #{max_power_level}"
