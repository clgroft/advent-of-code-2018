twos = 0
threes = 0

File.open('day02/input.txt').each do |l|
  counts = l.chomp.chars.group_by { |c| c }.values.map(&:size)
  twos += 1 if counts.include?(2)
  threes += 1 if counts.include?(3)
end

checksum = twos * threes
p checksum

