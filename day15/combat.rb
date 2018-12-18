require 'byebug'
require 'set'

def next_steps(grid, y, x)
  [[y-1,x], [y,x-1], [y,x+1], [y+1,x]].select { |j, i| grid[j][i] == "." }
end

class Fighter
  attr_accessor :species, :hp, :power, :y, :x, :our_side, :their_side, :grid

  def initialize(species, power, y, x, our_side, their_side, grid)
    @species = species
    @hp = 200
    @power = power
    @y = y
    @x = x
    @our_side = our_side
    @their_side = their_side
    @grid = grid
  end

  def position
    [y,x]
  end

  def to_s
    "Fighter type #{species} (HP = #{hp}, position = #{position})"
  end

  def move(new_p)
    our_side.delete(position)
    grid[y][x] = "."
    self.y = new_p[0]
    self.x = new_p[1]
    our_side[position] = self
    grid[y][x] = species
  end

  def die
    grid[y][x] = "."
    our_side.delete(position)
  end

  def attack(other)
    other.hp -= self.power
    other.die if other.hp <= 0
  end

  def enemy_to_attack
    [[y-1, x], [y, x-1], [y, x+1], [y+1, x]].map { |p| their_side[p] }.compact.min_by(&:hp)
  end

  def spaces_in_range
    next_steps(grid, y, x)
  end

  def all_their_positions
    their_side.values.flat_map(&:spaces_in_range).sort.uniq
  end

  def position_closer_to_in_range
    targets = all_their_positions.to_set
    most_recent_found = next_steps(grid, y, x)
    all_found = most_recent_found.map { |p| [p,p] }.to_h
    num_steps_away = 1
    loop do
      return nil if most_recent_found.empty?
      maybe_target = most_recent_found.detect { |p| targets.include?(p) }
      return all_found[maybe_target] if maybe_target

      newly_found = []
      most_recent_found.sort_by { |p| all_found[p] }.each do |p|
        j, i = *p
        next_steps(grid, j, i).reject { |q| all_found[q] }.each do |q|
          all_found[q] = all_found[p]
          newly_found << q
        end
      end
      most_recent_found = newly_found.sort
      num_steps_away += 1
    end
  end
end

grid = ARGF.each_line.map(&:chars)

def run_with_elf_power(grid, elf_power)
  grid = grid.map(&:dup)
  all_elves = {}
  all_goblins = {}

  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      case cell
      when "E"
        all_elves[[y,x]] = Fighter.new(cell, elf_power, y, x, all_elves, all_goblins, grid)
      when "G"
        all_goblins[[y,x]] = Fighter.new(cell, 3, y, x, all_goblins, all_elves, grid)
      end
    end
  end

  original_elf_population = all_elves.size
  num_complete_rounds = 0
  loop do
    (all_elves.keys + all_goblins.keys).sort.each do |p|
      fighter = all_elves[p] || all_goblins[p]
      next if fighter.nil?  # could have died earlier in the loop

      if fighter.their_side.empty?
        puts "Species #{fighter.species} wins!"
        hp_remaining = fighter.our_side.values.sum(&:hp)
        puts "after #{num_complete_rounds} rounds, total remaining HP = #{hp_remaining}"
        puts "Outcome: #{hp_remaining * num_complete_rounds}"
        return all_elves.size == original_elf_population
      end

      enemy = fighter.enemy_to_attack
      fighter.attack(enemy) && next if enemy

      next_position = fighter.position_closer_to_in_range
      if next_position
        fighter.move(next_position)
        enemy = fighter.enemy_to_attack
        fighter.attack(enemy) if enemy
      end
    end

    num_complete_rounds += 1
  end
end

elf_power = 3
loop do
  elves_win_in_rout = run_with_elf_power(grid, elf_power)
  return if elves_win_in_rout
  elf_power += 1
end
