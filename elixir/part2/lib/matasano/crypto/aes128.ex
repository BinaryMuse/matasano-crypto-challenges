defmodule Matasano.Crypto.AES128 do
  @ecb_iv List.duplicate(0, 16) |> list_to_binary
  :crypto.start

  # Since Erlang does not expose AES-128-ECB to us, we just use
  # CBC mode with a 0-filled IV on each block, one at a time.
  def ecb_encrypt(text, key) do
    parts = binary_to_list(text) |> Matasano.Bytes.split_into(16)
    parts = Enum.map parts, encrypt_block(&1, key)
    Enum.join parts, ""
  end

  def ecb_decrypt(text, key) do
    parts = binary_to_list(text) |> Matasano.Bytes.split_into(16)
    parts = Enum.map parts, decrypt_block(&1, key)
    Enum.join parts, ""
  end

  def encrypt_block(part, key) do
    :crypto.aes_cbc_128_encrypt(key, @ecb_iv, list_to_binary(part))
  end

  def decrypt_block(part, key) do
    :crypto.aes_cbc_128_decrypt(key, @ecb_iv, list_to_binary(part))
  end
end
