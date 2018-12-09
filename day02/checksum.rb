twos = 0
threes = 0

File.open("day02/input.txt").each_line do |l|
  counts = l.chomp.chars.group_by { |c| c }.values.map(&:size)
  twos += 1 if counts.include?(2)
  threes += 1 if counts.include?(3)
end

puts "The checksum value is #{twos * threes}"
