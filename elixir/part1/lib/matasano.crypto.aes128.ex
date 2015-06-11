defmodule Matasano.Crypto.AES128 do
  @ecb_iv List.duplicate(0, 16) |> List.to_string

  # Since Erlang does not expose AES-128-ECB to us, we just use
  # CBC mode with a 0-filled IV on each block, one at a time.
  def ecb_encrypt(text, key) do
    parts = :binary.bin_to_list(text) |> Matasano.Bytes.split_into(16)
    parts = Enum.map parts, &encrypt_block(&1, key)
    Enum.join parts, ""
  end

  def ecb_decrypt(text, key) do
    parts = :binary.bin_to_list(text) |> Matasano.Bytes.split_into(16)
    parts = Enum.map parts, &decrypt_block(&1, key)
    Enum.join parts, ""
  end

  def encrypt_block(part, key) do
    :crypto.block_encrypt(:aes_cbc128, key, @ecb_iv, :binary.list_to_bin(part))
  end

  def decrypt_block(part, key) do
    :crypto.block_decrypt(:aes_cbc128, key, @ecb_iv, :binary.list_to_bin(part))
  end
end
