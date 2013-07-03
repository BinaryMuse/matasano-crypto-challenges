#!/usr/bin/env ruby

require './support'

plaintext = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
key       = "ICE"
expected  = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"

def repeating_xor_cipher(plaintext, key)
  plain_bytes = plaintext.bytes
  key_cycle   = key.bytes
  key_bytes   = []
  plain_bytes.each do |byte|
    key_bytes << key_cycle[0]
    key_cycle.rotate!
  end

  zipped = plain_bytes.zip(key_bytes)
  zipped.map { |a, b| a ^ b }.map(&:chr).join
end

result = str_to_hex(repeating_xor_cipher(plaintext, key))

puts "Result:   #{result}"
puts "Expected: #{expected}"
puts

plaintext = "Shee, you guys are so unhip it's a wonder your bums don't fall off."
key       = "Adams"
puts "Encrypting: #{plaintext}"
puts " with key: #{key}"
puts
puts str_to_hex(repeating_xor_cipher(plaintext, key))

# $ ruby 05_repeating_key_xor_cipher.rb
# Result:   0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f
# Expected: 0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f
#
# Encrypting: Shee, you guys are so unhip it's a wonder your bums don't fall off.
#  with key: Adams
#
# 120c04085f611d0e18532611181e532016044d002e4414031b28144104076617410c53360b0f09163344180206334403181e324405021d6610410b122d08410215274a
