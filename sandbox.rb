require "ascii_charts"

#
array = []
12.times do |coord|
  coord = []
  array.append(coord)
end
x = 0
array.each do |pair|
  x = x + 1
  pair.append("#{x}, ")
end

pp array
