# 5. Repeating-key XOR Cipher
#
# Write the code to encrypt the string:
#
#     Burning 'em, if you ain't quick and nimble
#     I go crazy when I hear a cymbal
#
# Under the key "ICE", using repeating-key XOR. It should come out to:
#
#     0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f
#
# Encrypt a bunch of stuff using your repeating-key XOR function. Get a
# feel for it.

ExUnit.start

defmodule Matasano.Exercise.Test do
  use ExUnit.Case

  alias Matasano.Bytes
  alias Matasano.RepeatingKeyXor

  @key    "ICE"
  @text   "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
  @result "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"

  test "encrypts using repeating-key xor" do
    ciphertext = RepeatingKeyXor.encrypt(@text, @key) |> Bytes.to_hex
    assert ciphertext == @result

    IO.puts "Encrypting:"
    IO.puts "#{binary_to_list @text}"
    IO.puts "with key #{@key}:"
    IO.puts ciphertext
    IO.puts ""
    IO.puts "Encryping 'So long and thanks for all the fish.' with key 'adams':"
    IO.puts Bytes.to_hex RepeatingKeyXor.encrypt("So long and thanks for all the fish", "adams")
  end
end

# $ ./run.sh 05
# Encrypting:
# Burning 'em, if you ain't quick and nimble
# I go crazy when I hear a cymbal
# with key ICE:
# 0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f
#
# Encryping 'So long and thanks for all the fish.' with key 'adams':
# 320b41011c0f03410c1d05441505120f0f124d150e16410c1f0d441505164102081e1b
