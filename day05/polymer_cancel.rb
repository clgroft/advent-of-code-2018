def reduce_atoms(atoms)
  reduced = []
  atoms.each do |a|
    if reduced.last == a.swapcase
      reduced.pop
    else
      reduced << a
    end
  end
  reduced
end

atoms = File.read("day05/input.txt").chomp.chars
initial_reduction = reduce_atoms(atoms)

puts "The resulting molecule has #{initial_reduction.size} atoms"

shortest_fixed_length = ("a".."z").map do |remove_atom|
  reduce_atoms(initial_reduction.reject { |a| a.downcase == remove_atom }).size
end.min

puts "The shortest fixed molecule has #{shortest_fixed_length} atoms"
