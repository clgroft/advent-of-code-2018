line = File.read("day09/input.txt").chomp
/^(?<num_players>\d+) players; last marble is worth (?<last_score>\d+) points$/ =~ line

num_players = num_players.to_i
last_score = last_score.to_i * 100

class Marble
  attr_accessor :value, :marble_cw, :marble_ccw

  def initialize(value)
    @value = value
    @marble_cw = self
    @marble_ccw = self
  end

  def insert_clockwise(new_marble_cw)
    new_marble_cw.marble_ccw = self
    new_marble_cw.marble_cw = self.marble_cw
    self.marble_cw.marble_ccw = new_marble_cw
    self.marble_cw = new_marble_cw
  end

  def remove_self_from_cycle
    self.marble_ccw.marble_cw = self.marble_cw
    self.marble_cw.marble_ccw = self.marble_ccw
    self.marble_cw
  end
end

elf_scores = [0] * num_players
current_player = 0
current_marble = Marble.new(0)

(1..last_score).each do |value|
  if value % 23 == 0
    elf_scores[current_player] += value
    7.times { current_marble = current_marble.marble_ccw }
    elf_scores[current_player] += current_marble.value
    current_marble = current_marble.remove_self_from_cycle
  else
    current_marble = current_marble.marble_cw.insert_clockwise(Marble.new(value))
  end
  current_player = (current_player + 1) % num_players
end

puts "The winning elf's score is #{elf_scores.max}"
