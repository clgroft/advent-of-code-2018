entries = File.open('day04/input.txt').each_line.sort

current_guard_id = nil
when_fell_asleep = nil
guard_minutes_asleep = Hash.new(0)

entries.each do |e|
  /^\[\d{4}-\d{2}-\d{2} \d{2}:(?<minute>\d{2})\] (?<event>.*)$/ =~ e
  case event
  when /Guard \#(\d+) begins shift/
    current_guard_id = $1.to_i
  when "falls asleep"
    when_fell_asleep = minute.to_i
  when "wakes up"
    minute = minute.to_i
    (when_fell_asleep...minute).each do |m|
      guard_minutes_asleep[[current_guard_id, m]] += 1
    end
  end
end

guard_id, minute = guard_minutes_asleep.max_by { |k, v| v }[0]
puts "Guard ##{guard_id} spent minute #{minute} asleep more than any other"
puts "Result: #{guard_id * minute}"
