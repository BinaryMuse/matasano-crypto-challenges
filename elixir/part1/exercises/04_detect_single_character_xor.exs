# 4. Detect single-character XOR
#
# One of the 60-character strings at:
#
#     https://gist.github.com/3132713
#
# has been encrypted by single-character XOR. Find it. (Your code from
# #3 should help.)

ExUnit.start

defmodule Exercise04 do
  alias Matasano.Bytes
  alias Matasano.Plaintext

  def go do
    strings = Matasano.Loader.lines_from_file("fixtures/04.txt") |> Enum.map(&Bytes.from_hex(&1)) |> Enum.map(&:binary.bin_to_list(&1))
    scores = Parallel.pmap strings, &analyze_string(&1)
    Enum.max_by scores, fn({score, _, _}) -> score end
  end

  defp analyze_string(string) do
    keys = Enum.map Plaintext.printables, &List.duplicate(&1, length(string))
    scores = Parallel.pmap keys, fn(key) ->
      text = Bytes.xor_sum(key, string)
      { Plaintext.score_english(text), key, text }
    end
    Enum.max_by scores, fn({score, _, _}) -> score end
  end
end

defmodule Matasano.Exercise.Test do
  use ExUnit.Case

  test "detects single-character xor" do
    { score, key, text } = Exercise04.go

    IO.puts "Best scoring key (with a score of #{score} out of 10) is #{key}. Plaintext:"
    IO.puts text

    # Tests written after the fact; here for regression testing.
    assert key == '555555555555555555555555555555'
    assert text == 'Now that the party is jumping\n'
  end
end

# $ ./run.sh 04
# Best scoring key (with a score of 10.0 out of 10) is 555555555555555555555555555555. Plaintext:
# Now that the party is jumping
#
