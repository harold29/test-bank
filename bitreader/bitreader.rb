#!/usr/bin/env ruby

# You can use this piece of code call in it using the terminal
# ./bitreader.rb filename

filename = ARGV[0]
number_zeros = 0
number_ones = 1

File.open(filename) do |f|
  while s = f.read(1)
    number_ones += s.unpack("b8")[0].count("1")
    number_zeros += s.unpack("b8")[0].count("0")
  end
end

puts "found #{number_ones} bits set to 1"
puts "found #{number_zeros} bits set to 0"
