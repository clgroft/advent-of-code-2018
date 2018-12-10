class Point
  attr_reader :x_pos, :y_pos
  def initialize(x_pos, y_pos, x_vel, y_vel)
    @x_pos = x_pos
    @y_pos = y_pos
    @x_vel = x_vel
    @y_vel = y_vel
  end

  def fast_forward(num_steps)
    @x_pos += @x_vel * num_steps
    @y_pos += @y_vel * num_steps
  end
end

points = File.open("day10/input.txt").each_line.map do |l|
  /^position=\s*<(?<x_pos>.*?),\s+(?<y_pos>.*?)> velocity=\s*<(?<x_vel>.*?),\s+(?<y_vel>.*?)>$/ =~ l
  Point.new(x_pos.to_i, y_pos.to_i, x_vel.to_i, y_vel.to_i)
end

puts "There are #{points.size} points"
wait_time = 10000
points.each { |p| p.fast_forward(wait_time) }

# Will have to cancel <CTRL-C> to stop the script when the message is legible
loop do
  x_poses = points.map(&:x_pos)
  x_min = x_poses.min
  x_max = x_poses.max
  y_poses = points.map(&:y_pos)
  y_min = y_poses.min
  y_max = y_poses.max
  # puts "x in [#{x_min}, #{x_max}]; y in [#{y_min}, #{y_max}]"

  if x_max - x_min < 200 && y_max - y_min < 200
    puts "t = #{wait_time}"
    field = []
    (y_max - y_min + 1).times { field << ["."] * (x_max - x_min + 1) }
    points.each { |p| field[p.y_pos - y_min][p.x_pos - x_min] = "#" }
    field.each { |row| puts row.join }
    sleep(1)
  end
  wait_time += 1
  points.each { |p| p.fast_forward(1) }
end
