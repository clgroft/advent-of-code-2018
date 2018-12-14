# Part 1 solution. Once I realized all the array concatenation was slowing
# things down I used a linked list and explicit counting instead.
class Node
  attr_accessor :score, :next, :prev

  def initialize(score)
    @score = score
    @next = self
    @prev = self
  end

  def add_node(node)
    node.next = self.next
    node.prev = self
    self.next.prev = node
    self.next = node
  end
end

first_recipe = Node.new(3)
last_recipe = Node.new(7)
first_recipe.add_node(last_recipe)

elf1_recipe = first_recipe
elf2_recipe = last_recipe

num_recipes = 2
key_recipe = ARGV[0].to_i

while num_recipes < key_recipe + 10
  new_recipes = (elf1_recipe.score + elf2_recipe.score).to_s.chars.map(&:to_i)
  num_recipes += new_recipes.size
  new_recipes.each do |n|
    last_recipe.add_node(Node.new(n))
    last_recipe = last_recipe.next
  end
  (elf1_recipe.score + 1).times { elf1_recipe = elf1_recipe.next }
  (elf2_recipe.score + 1).times { elf2_recipe = elf2_recipe.next }
end

(num_recipes - key_recipe).times { first_recipe = first_recipe.prev }
final_scores = []
10.times do
  final_scores << first_recipe.score
  first_recipe = first_recipe.next
end
puts final_scores.join
