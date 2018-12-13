class Node
  def initialize(entries)
    num_children = entries.shift
    num_metadata_values = entries.shift
    @children = []
    @metadata = []
    num_children.times { @children << Node.new(entries) }
    num_metadata_values.times { @metadata << entries.shift }
  end

  def sum_all_metadata
    @metadata.sum + @children.map(&:sum_all_metadata).sum
  end

  def value
    @value ||= calculate_value
  end

  private

  def calculate_value
    return @metadata.sum if @children.empty?
    @metadata.select { |n| 0 < n && n <= @children.size }.map { |n| @children[n-1].value }.sum
  end
end

entries = ARGF.read.chomp.split(" ").map(&:to_i)
node = Node.new(entries)
puts "Metadata sum is #{node.sum_all_metadata}"
puts "Value of root node is #{node.value}"
