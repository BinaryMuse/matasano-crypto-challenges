#!/usr/bin/env ruby

require './support'

encoded = '1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'

bytes = hex_to_str(encoded).bytes

ALPHABET   = (65..90).to_a + (97..122).to_a + [32]
PRINTABLES = (32..126).to_a

def score_text(str)
  score = str.bytes.inject(0) do |memo, byte|
    if ALPHABET.include?(byte)
      memo + 2
    elsif PRINTABLES.include?(byte)
      memo + 1
    else
      memo - 1
    end
  end
end

winner = { score: 0, text: nil }

PRINTABLES.each do |letter|
  str = letter.chr * bytes.length
  zipped = bytes.zip(str.bytes)
  result = zipped.map { |a, b| a ^ b }.map(&:chr).join
  score = score_text(result)
  winner = { score: score, text: result } if score > winner[:score]
end

puts "Result: #{winner[:text]}"

# $ ruby 03_single_character_xor_cipher.rb
# Result: Cooking MC's like a pound of bacon
