# 3. Single-character XOR Cipher
#
# The hex encoded string:
#
#     1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736
#
# ... has been XOR'd against a single character. Find the key, decrypt
# the message.
#
# Write code to do this for you. How? Devise some method for "scoring" a
# piece of English plaintext. (Character frequency is a good metric.)
# Evaluate each output and choose the one with the best score.
#
# Tune your algorithm until this works.

ExUnit.start

defmodule Matasano.Exercise.Test do
  use ExUnit.Case

  alias Matasano.Bytes
  alias Matasano.Plaintext

  @ciphertext "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"

  test "decrypts a message encrypted by single-character xor" do
    bytes = @ciphertext |> Bytes.from_hex |> :binary.bin_to_list
    len = length(bytes)
    keys = Enum.map Plaintext.printables, &List.duplicate(&1, len)
    scores = Parallel.pmap keys, fn(key) ->
      text = Bytes.xor_sum(key, bytes)
      { Plaintext.score_english(text), key, text }
    end
    { score, key, text } = Enum.max_by scores, fn({score, _, _}) -> score end

    IO.puts "Best scoring key (with a score of #{score} out of 10) is #{key}. Plaintext:"
    IO.puts text

    # Tests written after the fact; here for regression testing.
    assert key == 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    assert text == 'Cooking MC\'s like a pound of bacon'
  end
end

# $ ./run.sh 03
# Best scoring key (with a score of 9.85294117647058875775 out of 10) is XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX. Plain text:
# Cooking MC's like a pound of bacon
