recipes = [3,7]
elf1_idx = 0
elf2_idx = 1

key_recipe = ARGV[0].to_i
num_iterations = 0
while recipes.size < key_recipe + 10
  num_iterations += 1
  recipes += (recipes[elf1_idx] + recipes[elf2_idx]).to_s.chars.map(&:to_i)
  elf1_idx = (elf1_idx + 1 + recipes[elf1_idx]) % recipes.size
  elf2_idx = (elf2_idx + 1 + recipes[elf2_idx]) % recipes.size
  puts "#{recipes.size}, #{elf1_idx}, #{elf2_idx}" if num_iterations % 2500 == 0
end

puts recipes[key_recipe...key_recipe+10].join
