def processed_size(atoms)
  resultant = []
  atoms.each do |a|
    if resultant.last == a.swapcase
      resultant.pop
    else
      resultant << a
    end
  end
  resultant.size
end

atoms = File.read("day05/input.txt").chomp.chars

puts "The resulting molecule has #{processed_size(atoms)} atoms"

fixed_lengths = ("a".."z").map do |remove_atom|
  processed_size(atoms.reject { |a| a.downcase == remove_atom })
end

puts "The shortest fixed molecule has #{fixed_lengths.min} atoms"
