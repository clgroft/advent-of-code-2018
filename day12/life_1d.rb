require 'set'

/^initial state: (?<init_line>[#.]*)$/ =~ ARGF.readline
curr_state = Set.new(init_line.chars.each_with_index.select { |c, i| c == "#" }.map { |a| a[1] })

ARGF.readline

$conversion_rules = Hash.new
ARGF.each_line do |l|
  /^(?<input>[.#]{5}) => (?<result>[.#])$/ =~ l
  $conversion_rules[input] = result
end

def window(prev_state, i)
  (i-2..i+2).map { |j| prev_state.include?(j) ? "#" : "." }.join
end

def in_next_state(prev_state, i)
  $conversion_rules[window(prev_state, i)] == "#"
end

def next_state(prev_state)
  Set.new(((prev_state.min - 3)..(prev_state.max + 3)).select { |i| in_next_state(prev_state, i) })
end

20.times do
  curr_state = next_state(curr_state)
end

curr_sum = curr_state.sum
puts "After 20 generations, sum = #{curr_sum}"

130.times do
  curr_state = next_state(curr_state)
  new_sum = curr_state.sum
  p (new_sum - curr_sum)
  curr_sum = new_sum
end

puts "After 150 generations, sum = #{curr_sum}"
puts "After 5 x 10^10 generations, sum = #{curr_sum + 22 * (50_000_000_000 - 150)}"
