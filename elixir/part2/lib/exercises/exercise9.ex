# 9. Implement PKCS#7 padding
#
# Pad any block to a specific block length, by appending the number of
# bytes of padding to the end of the block. For instance,
#
#     "YELLOW SUBMARINE"
#
# padded to 20 bytes would be:
#
#     "YELLOW SUBMARINE\x04\x04\x04\x04"
#
# The particulars of this algorithm are easy to find online.

defmodule Part2.Exercise9 do
  use ExUnit.Case

  def run do
    bytes = <<1, 2, 3, 4, 5, 6, 7, 8, 9, 10>>
    padded = Matasano.Bytes.pad_to(bytes, 16)
    assert padded == <<1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 6, 6, 6, 6, 6, 6>>

    bytes = <<1, 2, 3, 4, 5, 6, 7>>
    padded = Matasano.Bytes.pad_to(bytes, 8)
    assert padded == <<1, 2, 3, 4, 5, 6, 7, 1>>

    bytes = "YELLOW SUBMARINE"
    padded = Matasano.Bytes.pad_to(bytes, 20)
    assert padded == "YELLOW SUBMARINE\x04\x04\x04\x04"

    IO.puts "Padding #{bytes} to 20 bytes:"
    IO.puts inspect padded
  end
end

# $ mix exercise 9
# Padding YELLOW SUBMARINE to 20 bytes:
# <<89,69,76,76,79,87,32,83,85,66,77,65,82,73,78,69,4,4,4,4>>
