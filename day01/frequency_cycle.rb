deltas = File.open("day01/input.txt").each_line.map { |l| l.chomp.to_i }
puts "Frequency after all changes is #{deltas.sum}"

require 'set'

current_frequency = 0
frequencies_seen = Set.new
frequencies_seen.add(current_frequency)

loop do
  deltas.each do |d|
    current_frequency += d
    if frequencies_seen.include?(current_frequency)
      puts "First requeating frequency is #{current_frequency}"
      return
    end
    frequencies_seen.add(current_frequency)
  end
end
