INSTRUCTIONS = {
  addr: lambda { |reg, a, b| reg[a] + reg[b] },
  addi: lambda { |reg, a, b| reg[a] + b },
  mulr: lambda { |reg, a, b| reg[a] * reg[b] },
  muli: lambda { |reg, a, b| reg[a] * b },
  banr: lambda { |reg, a, b| reg[a] & reg[b] },
  bani: lambda { |reg, a, b| reg[a] & b },
  borr: lambda { |reg, a, b| reg[a] | reg[b] },
  bori: lambda { |reg, a, b| reg[a] | b },
  setr: lambda { |reg, a, b| reg[a] },
  seti: lambda { |reg, a, b| a },
  gtir: lambda { |reg, a, b| a > reg[b] ? 1 : 0 },
  gtri: lambda { |reg, a, b| reg[a] > b ? 1 : 0 },
  gtrr: lambda { |reg, a, b| reg[a] > reg[b] ? 1 : 0 },
  eqir: lambda { |reg, a, b| a == reg[b] ? 1 : 0 },
  eqri: lambda { |reg, a, b| reg[a] == b ? 1 : 0 },
  eqrr: lambda { |reg, a, b| reg[a] == reg[b] ? 1 : 0 },
}

# I solved for these manually given the possibilities from opcodes.rb.
# As it turns out, solving automatically would have been easy.
OPCODES_TO_INSTRUCTIONS = [
  :gtrr, :borr, :gtir, :eqri,
  :addr, :seti, :eqrr, :gtri,
  :banr, :addi, :setr, :mulr,
  :bori, :muli, :eqir, :bani,
]

registers = [0] * 4
File.open("day16/input2.txt") do |f|
  until f.eof?
    opcode, a, b, c = f.gets.split(" ").map(&:to_i)
    registers[c] = INSTRUCTIONS[OPCODES_TO_INSTRUCTIONS[opcode]].call(registers, a, b)
  end
end

puts "Contents of registers: #{registers}"
