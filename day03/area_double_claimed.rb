# Could have read the necessary region programatically, but enh.
FIELD = []
2000.times { FIELD << ([0] * 2000) }

ARGF.each_line do |l|
  /#\d+ @ (?<x_coord>\d+),(?<y_coord>\d+): (?<width>\d+)x(?<height>\d+)/ =~ l
  x_coord = x_coord.to_i
  y_coord = y_coord.to_i
  width = width.to_i
  height = height.to_i

  (0...width).each do |i|
    (0...height).each do |j|
      FIELD[x_coord + i][y_coord + j] += 1
    end
  end
end

puts "The multi-claimed area is #{FIELD.flatten.count { |c| c > 1 }}"
