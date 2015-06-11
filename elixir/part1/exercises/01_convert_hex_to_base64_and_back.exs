# 1. Convert hex to base64 and back.
#
# The string:
#
#     49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d
#
# should produce:
#
#     SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t

ExUnit.start

defmodule Matasano.Exercise.Test do
  use ExUnit.Case

  alias Matasano.Bytes

  @hex    "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
  @base64 "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

  test "converts from hex to base64 and back" do
    base64 = @hex |> Bytes.from_hex |> Bytes.to_base64
    assert base64 == @base64

    hex = @base64 |> Bytes.from_base64 |> Bytes.to_hex
    assert hex == @hex

    IO.puts "Hex to Base64: #{base64}"
    IO.puts "Back to Hex:   #{hex}"
  end
end

# $ ./run.sh 01
# Hex to Base64: SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t
# Back to Hex:   49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d
