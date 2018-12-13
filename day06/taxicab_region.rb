require "set"
centers = ARGF.each_line.map do |l|
  l.chomp.split(", ").map(&:to_i)
end

x_coords = centers.map { |p| p[0] }
x_min = x_coords.min
x_max = x_coords.max
y_coords = centers.map { |p| p[1] }
y_min = y_coords.min
y_max = y_coords.max

# We search in the smallest rectangle containing all the centers.
# If a point on the boundary of that rectangle is in the "closest" region
# of a center, then that center's region is infinite (it extends perperdicular
# to the boundary forever) so we reject it.  This also means that every finite
# region will be counted completely.

def distance_to_coord(p, x, y)
  (p[0] - x).abs + (p[1] - y).abs
end

infinite_regions = Set.new
region_size = Hash.new(0)
(x_min..x_max).each do |x|
  (y_min..y_max).each do |y|
    closest, next_closest = centers.sort_by { |p| distance_to_coord(p, x, y) }.take(2)
    if distance_to_coord(closest, x, y) < distance_to_coord(next_closest, x, y)
      region_size[closest] += 1
      if [x_min, x_max].include?(x) || [y_min, y_max].include?(y)
        infinite_regions.add(closest)
      end
    end
  end
end

puts "Largest region has area #{centers.reject { |p| infinite_regions.include?(p) }.map { |p| region_size[p] }.max}"

# This performs a brute-force search of a rectangle surrounding the given coordinates.
# A more sophisticated algorithm would address the x- and y-distances separately,
# since l^1 distance separates neatly into x-distance and y-distance.
extra_window = (10000 / centers.size).floor

safe_points = 0
((x_min - extra_window)..(x_max + extra_window)).each do |x|
  ((y_min - extra_window)..(y_max + extra_window)).each do |y|
    safe_points += 1 if centers.map { |p| distance_to_coord(p, x, y) }.sum < 10000
  end
end

puts "There are #{safe_points} safe points"
