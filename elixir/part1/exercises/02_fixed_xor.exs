# 2. Write a function that takes two equal-length buffers and produces their XOR sum.
#
# The string:
#
#     1c0111001f010100061a024b53535009181c
#
# ... after hex decoding, when xor'd against:
#
#     686974207468652062756c6c277320657965
#
# ... should produce:
#
#     746865206b696420646f6e277420706c6179

ExUnit.start

defmodule Matasano.Exercise.Test do
  use ExUnit.Case

  alias Matasano.Bytes

  @start   "1c0111001f010100061a024b53535009181c"
  @against "686974207468652062756c6c277320657965"
  @target  "746865206b696420646f6e277420706c6179"

  test "calculates the XOR sum of two buffers" do
    bytes   = @start   |> Bytes.from_hex
    against = @against |> Bytes.from_hex
    result  = Bytes.xor_sum(bytes, against) |> Bytes.to_hex
    assert result == @target

    IO.puts "Result: #{result}"
  end
end

# $ ./run.sh 02
# Result: 746865206b696420646f6e277420706c6179
