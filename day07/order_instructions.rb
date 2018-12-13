require 'set'

dependencies = ("A".."Z").map { |c| [c, Set.new] }.to_h
ARGF.each_line do |l|
  /^Step (?<dependency>.) must be finished before step (?<next_step>.) can begin\./ =~ l
  dependencies[next_step].add(dependency)
end

steps_in_order = []
until dependencies.empty?
  next_steps = dependencies.each_pair.select { |k, v| v.empty? }.map { |k, _| k }
  next_step = next_steps.min
  steps_in_order << next_step
  dependencies.delete(next_step)
  dependencies.values.each { |v| v.delete(next_step) }
end
puts steps_in_order.join
