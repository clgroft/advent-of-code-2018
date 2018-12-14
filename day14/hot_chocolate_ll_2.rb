class Node
  attr_accessor :score, :next, :prev, :index

  def initialize(score)
    @score = score
    @next = self
    @prev = self
    @index = 0
  end

  def add_node(node)
    node.next = self.next
    node.prev = self
    node.index = self.index + 1
    self.next.prev = node
    self.next = node
  end
end

first_recipe = Node.new(3)
last_recipe = Node.new(7)
first_recipe.add_node(last_recipe)
checking_recipe = first_recipe

elf1_recipe = first_recipe
elf2_recipe = last_recipe
num_recipes = 2

key_sequence = ARGV[0].chars.map(&:to_i)
loop do
  new_recipes = (elf1_recipe.score + elf2_recipe.score).to_s.chars.map(&:to_i)
  num_recipes += new_recipes.size
  new_recipes.each do |n|
    last_recipe.add_node(Node.new(n))
    last_recipe = last_recipe.next
  end
  (elf1_recipe.score + 1).times { elf1_recipe = elf1_recipe.next }
  (elf2_recipe.score + 1).times { elf2_recipe = elf2_recipe.next }

  while checking_recipe.index + key_sequence.size <= num_recipes
    current_score_string = []
    current_recipe = checking_recipe
    key_sequence.size.times do
      current_score_string << current_recipe.score
      current_recipe = current_recipe.next
    end
    if current_score_string == key_sequence
      puts "#{checking_recipe.index}"
      return
    end
    checking_recipe = checking_recipe.next
  end
end

