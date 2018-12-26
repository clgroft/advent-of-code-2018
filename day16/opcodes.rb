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

OPCODES_TO_INSTRUCTIONS = 16.times.map { INSTRUCTIONS.keys }

num_samples = 0
until ARGF.eof?
  match = /Before: \[(\d+), (\d+), (\d+), (\d+)\]/.match(ARGF.gets)
  start_reg = (1..4).map { |n| match[n].to_i }.freeze
  opcode, a, b, c = ARGF.gets.split(" ").map(&:to_i)
  match = /After:  \[(\d+), (\d+), (\d+), (\d+)\]/.match(ARGF.gets)
  end_reg = (1..4).map { |n| match[n].to_i }.freeze
  ARGF.gets

  num_opcodes = INSTRUCTIONS.values.count do |instr|
    reg = start_reg.dup
    reg[c] = instr.call(reg, a, b)
    reg == end_reg
  end
  num_samples += 1 if num_opcodes >= 3
end

puts "Found #{num_samples} samples that match at least 3 opcodes"
