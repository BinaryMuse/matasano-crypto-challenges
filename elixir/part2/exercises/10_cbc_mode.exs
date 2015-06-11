# 10. Implement CBC Mode
#
# In CBC mode, each ciphertext block is added to the next plaintext
# block before the next call to the cipher core.
#
# The first plaintext block, which has no associated previous ciphertext
# block, is added to a "fake 0th ciphertext block" called the IV.
#
# Implement CBC mode by hand by taking the ECB function you just wrote,
# making it encrypt instead of decrypt (verify this by decrypting
# whatever you encrypt to test), and using your XOR function from
# previous exercise.
#
# DO NOT CHEAT AND USE OPENSSL TO DO CBC MODE, EVEN TO VERIFY YOUR
# RESULTS. What's the point of even doing this stuff if you aren't going
# to learn from it?
#
# The buffer at:
#
#     https://gist.github.com/3132976
#
# is intelligible (somewhat) when CBC decrypted against "YELLOW
# SUBMARINE" with an IV of all ASCII 0 (\x00\x00\x00 &c)

ExUnit.start()

defmodule Part2.Exercise10 do
  use ExUnit.Case

  alias Matasano.Bytes
  alias Matasano.Plaintext
  alias Matasano.Crypto.AES128

  test "implements CBC mode" do
    data = Matasano.Loader.text_from_file("fixtures/10.txt") |> Bytes.from_base64
    null_iv = List.duplicate(0, 16) |> :binary.list_to_bin

    # Test decryption visually
    decrypted = AES128.cbc_decrypt(data, "YELLOW SUBMARINE", null_iv)
    Enum.each :binary.bin_to_list(decrypted), fn(byte) ->
      if Enum.member? Plaintext.printables, byte do
        IO.write [byte]
      else
        IO.write "?"
      end
    end

    # Test encryption by re-encrypting decrypted data
    encrypted = AES128.cbc_encrypt(decrypted, "YELLOW SUBMARINE", null_iv)
    assert encrypted == data
  end
end

# $ mix exercise 10
# I'm back and I'm ringin' the bell
# A rockin' on the mike while the fly girls yell
# In ecstasy in the back of me
# Well that's my DJ Deshay cuttin' all them Z's
