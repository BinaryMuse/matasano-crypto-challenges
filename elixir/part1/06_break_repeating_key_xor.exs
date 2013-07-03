# 6. Break repeating-key XOR
#
# The buffer at the following location:
#
#     https://gist.github.com/3132752
#
# is base64-encoded repeating-key XOR. Break it.
#
# Here's how:
#
# a. Let KEYSIZE be the guessed length of the key; try values from 2 to
# (say) 40.
#
# b. Write a function to compute the edit distance/Hamming distance
# between two strings. The Hamming distance is just the number of
# differing bits. The distance between:
#
#     this is a test
#
# and:
#
#     wokka wokka!!!
#
# is 37.
#
# c. For each KEYSIZE, take the FIRST KEYSIZE worth of bytes, and the
# SECOND KEYSIZE worth of bytes, and find the edit distance between
# them. Normalize this result by dividing by KEYSIZE.
#
# d. The KEYSIZE with the smallest normalized edit distance is probably
# the key. You could proceed perhaps with the smallest 2-3 KEYSIZE
# values. Or take 4 KEYSIZE blocks instead of 2 and average the
# distances.
#
# e. Now that you probably know the KEYSIZE: break the ciphertext into
# blocks of KEYSIZE length.
#
# f. Now transpose the blocks: make a block that is the first byte of
# every block, and a block that is the second byte of every block, and
# so on.
#
# g. Solve each block as if it was single-character XOR. You already
# have code to do this.
#
# e. For each block, the single-byte XOR key that produces the best
# looking histogram is the repeating-key XOR key byte for that
# block. Put them together and you have the key.

ExUnit.start

defmodule Exercise06 do
  alias Parallel
  alias Matasano.Bytes
  alias Matasano.Plaintext
  alias Matasano.RepeatingKeyXor

  def go do
    data = Matasano.Loader.text_from_file("fixtures/06.txt") |> Bytes.from_base64

    key_per_keysize = Parallel.pmap most_likely_keysizes(data), fn({keysize, _}) ->
      Exercise06.find_key_for_keysize(data, keysize)
    end

    decryptions = Enum.map key_per_keysize, decrypt(data, &1)

    Enum.find decryptions, fn({_, decrypted}) ->
      Enum.all? binary_to_list(decrypted), fn(byte) -> Enum.member?(Plaintext.printables, byte) end
    end
  end

  def decrypt(data, key) do
    key = list_to_binary(key)
    { key, RepeatingKeyXor.encrypt(data, key) }
  end

  # Get the five most likely keysizes, in order, based on the average of
  # the consecutive hamming distances between the first four blocks, normalized
  # by the key length.
  def most_likely_keysizes(data) do
    keysizes = Parallel.pmap 2..40, fn(keysize) ->
      { keysize, normalized_hamming_distance(data, keysize) }
    end
    keysizes = Enum.sort keysizes, fn({_, score_a}, {_, score_b}) -> score_a < score_b end
    Enum.take keysizes, 5
  end

  def normalized_hamming_distance(bytes, keysize) when is_binary(bytes) do
    normalized_hamming_distance(binary_to_list(bytes), keysize)
  end

  def normalized_hamming_distance(bytes, keysize) when is_list(bytes) do
    [ a, b, c, d | _ ] = Bytes.split_into bytes, keysize
    distances = Enum.map [[a, b], [b, c], [c, d]], fn([x, y]) -> Bytes.hamming_distance(x, y) end
    Enum.reduce(distances, 0, &1 + &2) / length(distances) / keysize
  end

  # Determines the most likely key for the given ciphertext for the given assumed key size
  def find_key_for_keysize(bytes, keysize) do
    blocks = bytes |> binary_to_list |> Bytes.split_into(keysize) |> Bytes.transpose
    Parallel.pmap blocks, find_best_xor_byte(&1)
  end

  # Find the most likely XOR byte for this block based on scores
  # by Plaintext.score_english (rates alphabetic characters higher
  # than other printable characters).
  defp find_best_xor_byte(block) do
    scores = Parallel.pmap Plaintext.printables, fn(char) ->
      key = List.duplicate(char, length(block))
      { char, Bytes.xor_sum(block, key) |> Plaintext.score_english }
    end
    { char, _score } = Enum.max scores, fn({_char, score}) -> score end
    char
  end
end

defmodule Matasano.Exercise.Test do
  use ExUnit.Case

  test "breaks repeating-key xor encryption" do
    { key, decrypted } = Exercise06.go
    IO.puts "Key: #{key}"
    IO.puts ""
    IO.puts decrypted

    # Tests written after the fact; here for regression testing.
    assert key == "Terminator X: Bring the noise"
    first_line = decrypted |> String.split("\n") |> Enum.first |> String.strip
    assert first_line == "I'm back and I'm ringin' the bell"
  end
end

# $ ./run.sh 06
# Key: Terminator X: Bring the noise
#
# I'm back and I'm ringin' the bell
# A rockin' on the mike while the fly girls yell
# In ecstasy in the back of me
# ... (truncated)
