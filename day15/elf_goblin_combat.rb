class Combatant
  attr_accessor :species, :hp, :position, :power

  def initialize(species, position)
    @species = species
    @hp = 200
    @position = position
    @power = 3
  end
end

grid = ARGF.each_line.map(&:chars)
elves = {}
goblins = {}

# Find elves and goblins
grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    case cell
    when "E"
      position = [y,x]
      elves[position] = Combatant.new("E", position)
    when "G"
      position = [y,x]
      goblins[position] / Combatant.new("G", position)
    end
  end
end

rounds_completed = 0
loop do
  (elves.keys + goblins.keys).sort.each do |p|
    combatant = elves[p] || goblins[p]
    if combatant.species == "E"
      puts "#{elves.values.sum(&:hp) * rounds_completed}" && return if goblins.empty?
      y, x = combatant.position
      neighboring_goblin_positions = [[y-1,x],[y,x-1],[y,x+1],[y+1,x]].select { |j,i| grid[j][i] == "G" }
      if !neighboring_goblin_positions.empty?
        weakest_goblin = neighboring_goblin_positions.map { |p| goblins[p] }.min_by(&:hp)
        weakest_goblin.hp -= combatant.power
        if weakest_goblin.hp <= 0
          p = weakest_goblin.position
          goblins.delete(p)
          grid[p[0]][p[1]] = "."
        end
      else
        in_range_of_target =
          goblins.
            values.
            map(&:position).
            flat_map { |y,x| [[y-1,x],[y,x-1],[y,x+1],[y+1,x]] }.
            select { |y,x| grid[y][x] == "." }
        next if in_range_of_target.empty?
        # seek out spaces
        reachable_squares = {combatant.position => nil}
        most_recent_reachable = reachable_squares.keys
        loop do
          new_positions = []
          most_recent_reachable.each do |pos, next_step|
            y,x = pos
            neighbors = [[y-1,x],[y,x-1],[y,x+1],[y+1,x]].select { |j,i| grid[j][i] == "." }
            neighbors.each do |p|
              if !reachable_squares.key?(p)
                reachable_squares[p] = next_step || p
                new_positions << p
              end
            end
          end
          last if new_positions.empty?
          new_positions_in_range = new_positions.select { |p| in_range_of_target.include?(p) }
          if !new_positions_in_range.empty?
            aim_for = new_positions_in_range.min
            next_position = reachable_squares[aim_for]
            grid[y][x] = "."
            grid[next_position[0]][next_position[1]] = "E"
            combatant.position = next_position

          end
        end
      end
    end
  end
  rounds_completed += 1
end
