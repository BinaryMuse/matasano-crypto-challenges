defmodule Matasano.RepeatingKeyXor do
  @doc """
  Encrypt `plaintext`, a binary, with `key`, also a binary, using repeating-key
  XOR encryption.

  ## Examples

      iex> Matasano.RepeatingKeyXor.encrypt "So long and thanks for all the fish", "adams"
      <<50,11,65,1,28,15,3,65,12,29,5,68,21,5,18,15,15,18,77,21,14,22,65,12,31,13,68,21,5,22,65,2,8,30,27>>
  """
  def encrypt(plaintext, key) do
    key = repeat_key(key, size plaintext)
    Matasano.Bytes.xor_sum plaintext, key
  end

  defp repeat_key(key, final_length) do
    key_len       = size key
    repeat_amount = div(final_length, key_len) + 1
    List.duplicate(key, repeat_amount) |> Enum.join("") |> String.slice(0, final_length)
  end
end
