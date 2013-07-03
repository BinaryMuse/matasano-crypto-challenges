#!/usr/bin/env ruby

def hex_to_str(str)
  [str].pack("H*")
end

def str_to_hex(str)
  str.unpack("H*").join
end

def base64_to_str(str)
  str.unpack("m0").join
end

def str_to_base64(str)
  [str].pack("m0")
end

hex      = '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d'
expected = 'SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t'

puts "Original hex:     #{hex}"

encoded = str_to_base64(hex_to_str(hex))

puts "Base64 encoded:   #{encoded}"
puts "Expected encoded: #{expected}"

decoded = str_to_hex(base64_to_str(encoded))

puts "Decoded:          #{decoded}"

# $ ruby 01_base64.rb
# Original hex:     49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d
# Base64 encoded:   SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t
# Expected encoded: SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t
# Decoded:          49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d
