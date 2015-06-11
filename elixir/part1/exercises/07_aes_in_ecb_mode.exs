# 7. AES in ECB Mode
#
# The Base64-encoded content at the following location:
#
#     https://gist.github.com/3132853
#
# Has been encrypted via AES-128 in ECB mode under the key
#
#     "YELLOW SUBMARINE".
#
# (I like "YELLOW SUBMARINE" because it's exactly 16 bytes long).
#
# Decrypt it.
#
# Easiest way:
#
# Use OpenSSL::Cipher and give it AES-128-ECB as the cipher.

ExUnit.start

defmodule Matasano.Exercise.Test do
  use ExUnit.Case

  alias Matasano.Bytes
  alias Matasano.Crypto.AES128

  @key "YELLOW SUBMARINE"

  test "decrypts using AES-128-ECB" do
    ciphertext = Matasano.Loader.text_from_file("fixtures/07.txt") |> Bytes.from_base64
    decrypted  = AES128.ecb_decrypt(ciphertext, @key)

    IO.puts decrypted

    # Tests written after the fact; here for regression testing.
    first_line = decrypted |> String.split("\n") |> List.first |> String.strip
    assert first_line == "I'm back and I'm ringin' the bell"
  end
end

# $ ./run.sh 07
# I'm back and I'm ringin' the bell
# A rockin' on the mike while the fly girls yell
# In ecstasy in the back of me
# Well that's my DJ Deshay cuttin' all them Z's
# ... (truncated)
