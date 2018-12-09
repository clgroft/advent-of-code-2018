require 'set'

dependencies = ("A".."Z").map { |c| [c, Set.new] }.to_h
File.open("day07/input.txt").each_line do |l|
  /^Step (?<dependency>.) must be finished before step (?<next_step>.) can begin\.$/ =~ l
  dependencies[next_step].add(dependency)
end

def next_step(deps)
  deps.each_pair.select { |k, v| v.empty? }.map { |k, _| k }.min
end

MAX_ELVES_WORKING = 5
def time_for_step(step)
  step.ord - "A".ord + 61
end
elves_working = []
current_time = 0

until dependencies.empty? && elves_working.empty?
  step = next_step(dependencies)
  if step && elves_working.size < MAX_ELVES_WORKING
    # assign an elf to perform a task
    elf_record = {step: step, finished: current_time + time_for_step(step)}
    elves_working << elf_record
    dependencies.delete(step)
    # puts "Assigning an elf to step #{step}, will complete at t = #{elf_record[:finished]}"
  else
    # wait for some elves to complete their tasks
    current_time = elves_working.map { |e| e[:finished] }.min
    # puts "Waiting for t = #{current_time}"
    elves_finished_or_not = elves_working.group_by { |e| e[:finished] == current_time }
    elves_working = elves_finished_or_not[false] || []
    elves_finished_or_not[true].map { |e| e[:step] }.each do |s|
      dependencies.values.each { |deps| deps.delete(s) }
      # puts "Completed step #{s}"
    end
  end
  # puts "#{elves_working.size} elves working"
end
puts "Finish in #{current_time} s"
