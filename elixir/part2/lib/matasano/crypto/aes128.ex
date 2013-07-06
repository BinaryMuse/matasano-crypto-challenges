defmodule Matasano.Crypto.AES128 do
  @ecb_iv List.duplicate(0, 16) |> list_to_binary

  # Since Erlang does not expose AES-128-ECB to us, we just use
  # CBC mode with a 0-filled IV on each block, one at a time.
  def ecb_encrypt(text, key) do
    parts = binary_to_list(text) |> Matasano.Bytes.split_into(16)
    parts = Enum.map parts, ecb_encrypt_block(&1, key)
    Enum.join parts, ""
  end

  def ecb_decrypt(text, key) do
    parts = binary_to_list(text) |> Matasano.Bytes.split_into(16)
    parts = Enum.map parts, ecb_decrypt_block(&1, key)
    Enum.join parts, ""
  end

  def ecb_encrypt_block(part, key) when is_list(part) do
    :crypto.aes_cbc_128_encrypt(key, @ecb_iv, list_to_binary(part))
  end

  def ecb_encrypt_block(part, key) do
    :crypto.aes_cbc_128_encrypt(key, @ecb_iv, part)
  end

  def ecb_decrypt_block(part, key) when is_list(part) do
    :crypto.aes_cbc_128_decrypt(key, @ecb_iv, list_to_binary(part))
  end

  def ecb_decrypt_block(part, key) do
    :crypto.aes_cbc_128_decrypt(key, @ecb_iv, part)
  end

  # Hand-rolled CBC mode, using our ECB mode above (which is,
  # unfortunately, implemented with CBC mode).
  def cbc_encrypt(bytes, key, iv) do
    parts = bytes |> Matasano.Bytes.split_into(16)
    cbc_encrypt_block(iv, parts, key, [])
  end

  def cbc_encrypt_block(_, [], _, acc), do: Enum.reverse(acc) |> list_to_binary

  def cbc_encrypt_block(last_block, [this_block | tail], key, acc) do
    xored_block = Matasano.Bytes.xor_sum(last_block, this_block)
    encrypted = ecb_encrypt_block(xored_block, key)
    cbc_encrypt_block(encrypted, tail, key, [encrypted | acc])
  end

  def cbc_decrypt(bytes, key, iv) do
    parts = bytes |> Matasano.Bytes.split_into(16)
    cbc_decrypt_block(iv, parts, key, [])
  end

  def cbc_decrypt_block(_, [], _, acc), do: Enum.reverse(acc) |> list_to_binary

  def cbc_decrypt_block(last_block, [this_block | tail], key, acc) do
    decrypted = ecb_decrypt_block(this_block, key)
    xored_block = Matasano.Bytes.xor_sum(decrypted, last_block)
    # The *unencrypted* block is sent as the "last_block" parameter
    # to be XOR'd with the next block, while the xored_block
    # becomes the next block of plaintext.
    #
    # See https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher-block_chaining_.28CBC.29
    cbc_decrypt_block(this_block, tail, key, [xored_block | acc])
  end
end
