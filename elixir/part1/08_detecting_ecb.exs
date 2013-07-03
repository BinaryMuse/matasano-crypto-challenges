# 8. Detecting ECB
#
# At the following URL are a bunch of hex-encoded ciphertexts:
#
#     https://gist.github.com/3132928
#
# One of them is ECB encrypted. Detect it.
#
# Remember that the problem with ECB is that it is stateless and
# deterministic; the same 16 byte plaintext block will always produce
# the same 16 byte ciphertext.

ExUnit.start

defmodule Exercise08 do
  def find_duplicate([]), do: nil

  def find_duplicate([ head | tail]) do
    case Enum.find tail, &1 == head do
      nil -> find_duplicate(tail)
      _ -> head
    end
  end
end

defmodule Matasano.Exercise.Test do
  use ExUnit.Case

  alias Matasano.Bytes

  test "detects AES-128-ECB encrypted buffers" do
    lines = Matasano.Loader.lines_from_file("fixtures/08.txt")
    dup = Enum.find lines, fn(line) ->
      parts = line |> Bytes.from_hex |> binary_to_list |> Bytes.split_into(16)
      duplicated = Exercise08.find_duplicate(parts)
      duplicated != nil
    end

    case dup do
      nil -> IO.puts "No exact duplicate found."
      line -> IO.puts "Found duplicate block in: #{line}"
    end

    # Tests written after the fact; here for regression testing.
    assert line == "d880619740a8a19b7840a8a31c810a3d08649af70dc06f4fd5d2d69c744cd283e2dd052f6b641dbf9d11b0348542bb5708649af70dc06f4fd5d2d69c744cd2839475c9dfdbc1d46597949d9c7e82bf5a08649af70dc06f4fd5d2d69c744cd28397a93eab8d6aecd566489154789a6b0308649af70dc06f4fd5d2d69c744cd283d403180c98c8f6db1f2a3f9c4040deb0ab51b29933f2c123c58386b06fba186a"
  end
end

# $ ./run.sh 08
# Found duplicate block in: d880619740a8a19b7840a8a31c810a3d08649af70dc06f4fd5d2d69c744cd283e2dd052f6b641dbf9d11b0348542bb5708649af70dc06f4fd5d2d69c744cd2839475c9dfdbc1d46597949d9c7e82bf5a08649af70dc06f4fd5d2d69c744cd28397a93eab8d6aecd566489154789a6b0308649af70dc06f4fd5d2d69c744cd283d403180c98c8f6db1f2a3f9c4040deb0ab51b29933f2c123c58386b06fba186a
