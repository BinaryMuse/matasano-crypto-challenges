#!/usr/bin/env ruby

require './support'

first    = '1c0111001f010100061a024b53535009181c'
second   = '686974207468652062756c6c277320657965'
expected = '746865206b696420646f6e277420706c6179'

first  = hex_to_str(first)
second = hex_to_str(second)

bytes_array = first.bytes.zip(second.bytes)
result = bytes_array.map { |a, b| a ^ b }.map(&:chr).join
result = str_to_hex(result)

puts "Result:   #{result}"
puts "Expected: #{expected}"

# $ ruby 02_fixed_xor.rb
# Result:   746865206b696420646f6e277420706c6179
# Expected: 746865206b696420646f6e277420706c6179
