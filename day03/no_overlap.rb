require 'set'

FIELD = []
2000.times { FIELD << ([nil] * 2000) }

no_overlaps_yet = Set.new

File.open('day03/input.txt').each do |l|
  /#(?<id>\d+) @ (?<x_coord>\d+),(?<y_coord>\d+): (?<width>\d+)x(?<height>\d+)/ =~ l
  x_coord = x_coord.to_i
  y_coord = y_coord.to_i
  width = width.to_i
  height = height.to_i

  found_overlap = false

  (0...width).each do |i|
    (0...height).each do |j|
      prev_claim = FIELD[x_coord + i][y_coord + j]
      if prev_claim
        found_overlap = true
        no_overlaps_yet.delete(prev_claim)
      else
        FIELD[x_coord + i][y_coord + j] = id
      end
    end
  end

  no_overlaps_yet.add(id) unless found_overlap
end

p no_overlaps_yet
