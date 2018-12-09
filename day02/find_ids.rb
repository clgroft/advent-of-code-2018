lines = File.open('day02/input.txt').map(&:chomp).map(&:chars)

lines.each do |line_1|
  lines.each do |line_2|
    diffs = line_1.zip(line_2).select { |a| a[0] != a[1] }.count
    if diffs == 1
      puts "#{line_1.zip(line_2).select { |a| a[0] == a[1] }.map { |a| a[0] }.join}\n"
    end
  end
end
(1...lines.size).each do |j|
  row_j = lines[j]
  (0...j).each do |i|
    row_i = lines[i]
    diffs = row_i.zip(row_j).select { |a| a[0] != a[1] }.count
    p "#{row_i} vs. #{row_j}" && return if diffs == 1
  end
end
