lines = File.open("day02/input.txt").each_line.map { |l| l.chomp.chars }

# A bit inefficient since it compares lines to themselves and checks some pairs twice,
# but only by a constant factor.
lines.each do |line_1|
  lines.each do |line_2|
    diffs = line_1.zip(line_2).select { |a| a[0] != a[1] }.count
    if diffs == 1
      puts "#{line_1.zip(line_2).select { |a| a[0] == a[1] }.map { |a| a[0] }.join}\n"
      return
    end
  end
end
