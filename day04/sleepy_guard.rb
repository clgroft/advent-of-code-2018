entries = File.open('day04/input.txt').each_line.sort

minutes_asleep = Hash.new(0)
sleepy_times = {}
current_guard_id = nil
when_fell_asleep = nil

entries.each do |e|
  /^\[\d{4}-\d{2}-\d{2} \d{2}:(?<minute>\d{2})\] (?<event>.*)$/ =~ e
  case event
  when /Guard \#(\d+) begins shift/
    current_guard_id = $1.to_i
  when "falls asleep"
    when_fell_asleep = minute.to_i
  when "wakes up"
    minute = minute.to_i
    minutes_asleep[current_guard_id] += minute - when_fell_asleep
    sleepy_times[current_guard_id] ||= []
    sleepy_times[current_guard_id] << [when_fell_asleep, minute]
  else
    p event
  end
end

guard_id, minutes = minutes_asleep.max_by { |k, v| v }
puts "Guard ##{guard_id} spent #{minutes} minutes asleep"

sleepy_intervals = sleepy_times[guard_id]
all_minutes = [0] * 60
sleepy_intervals.each do |fell_asleep, woke_up|
  (fell_asleep...woke_up).each { |m| all_minutes[m] += 1 }
end
sleepiest_minute = (0...60).max_by { |m| all_minutes[m] }
puts "His sleepiest minute is minute #{sleepiest_minute}"

puts "Result: #{guard_id * sleepiest_minute}"

# FIELD = []
# 2000.times { FIELD << ([0] * 2000) }
#
# File.open('day03/input.txt').each do |l|
#   /#\d+ @ (?<x_coord>\d+),(?<y_coord>\d+): (?<width>\d+)x(?<height>\d+)/ =~ l
#   x_coord = x_coord.to_i
#   y_coord = y_coord.to_i
#   width = width.to_i
#   height = height.to_i
#
#   (0...width).each do |i|
#     (0...height).each do |j|
#       FIELD[x_coord + i][y_coord + j] += 1
#     end
#   end
# end
#
# p FIELD.flatten.count { |c| c > 1 }
