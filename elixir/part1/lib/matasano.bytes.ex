defmodule Matasano.Bytes do
  use Bitwise

  @doc """
  Convert a binary or list of bytes to a hexadecimal string representation,

  ## Examples
  
      iex> Matasano.Bytes.to_hex <<1,2,3,253,254,255>>
      "010203fdfeff"

      iex> Matasano.Bytes.to_hex [1,2,3,253,254,255]
      '010203fdfeff'
  """
  def to_hex(bytes) when is_binary(bytes), do: binary_to_list(bytes) |> to_hex |> list_to_binary

  def to_hex(bytes) when is_list(bytes) do
    hexes = Enum.map bytes, fn(byte) -> :string.right(integer_to_list(byte, 16), 2, ?0) end
    Enum.join(hexes, "") |> String.downcase |> binary_to_list
  end

  @doc """
  Convert a hexadecimal string representation of a series of bytes into a binary containing those bytes.

  ## Examples

      iex> Matasano.Bytes.from_hex "010203fdfeff"
      <<1,2,3,253,254,255>>

      iex> Matasano.Bytes.from_hex '010203fdfeff'
      [1,2,3,253,254,255]
  """
  def from_hex(hex) when is_binary(hex), do: from_hex(binary_to_list(hex)) |> list_to_binary

  def from_hex(hex) when is_list(hex) do
    hex |> split_into(2) |> Enum.map(list_to_integer(&1, 16))
  end

  @doc """
  Split a list at every `size` elements. List that do not have a length that
  is evenly divisible by `size` will end in a list that has less than `size`
  elements.

  ## Examples

      iex> Matasano.Bytes.split_into [1,2,3,4,5,6,7,8,9,10], 3
      [[1,2,3], [4,5,6], [7,8,9], [10]]
  """
  def split_into([], _size), do: []

  def split_into(list, size) when length(list) >= size do
    { some, rest } = Enum.split list, size
    [ some | split_into(rest, size) ]
  end

  def split_into(list, _size), do: [list]

  @doc """
  Base64 encode a binary or list of bytes.
  
  ## Examples

      iex> Matasano.Bytes.to_base64 <<1,2,3,253,254,255>>
      "AQID/f7/"

      iex> Matasano.Bytes.to_base64 [1,2,3,253,254,255]
      'AQID/f7/'
  """
  def to_base64(bytes) when is_binary(bytes) do
    :base64.encode(bytes)
  end

  def to_base64(bytes) when is_list(bytes) do
    :base64.encode_to_string(bytes)
  end

  @doc """
  Base64 decode a binary or list of bytes.
  
  ## Examples

      iex> Matasano.Bytes.from_base64 "AQID/f7/"
      <<1,2,3,253,254,255>>

      iex> Matasano.Bytes.from_base64 'AQID/f7/'
      [1,2,3,253,254,255]
  """
  def from_base64(base64) when is_binary(base64) do
    :base64.decode(base64)
  end

  def from_base64(base64) when is_list(base64) do
    :base64.decode_to_string(base64)
  end

  @doc """
  Base64 encode the binary represented by a hexadecimal string representation of a series of bytes.
  
  ## Examples

      iex> Matasano.Bytes.hex_to_base64 "010203fdfeff"
      "AQID/f7/"

      iex> Matasano.Bytes.hex_to_base64 '010203fdfeff'
      'AQID/f7/'
  """
  def hex_to_base64(hex) do
    hex |> from_hex |> to_base64
  end

  @doc """
  Convert a Base64-encoded binary into a hexadecimal string representation of the decoded bytes.
  
  ## Examples

      iex> Matasano.Bytes.base64_to_hex "AQID/f7/"
      "010203fdfeff"

      iex> Matasano.Bytes.base64_to_hex 'AQID/f7/'
      '010203fdfeff'
  """
  def base64_to_hex(base64) do
    base64 |> from_base64 |> to_hex
  end

  @doc """
  Calculate the XOR sum of two binaries or lists of integers.

  ## Examples

      iex> Matasano.Bytes.xor_sum <<1,2,3,4,5,6,7>>, <<2,3,4,5,6,7,8>>
      <<3,1,7,1,3,1,15>>

      iex> Matasano.Bytes.xor_sum [1,2,3,4,5,6,7], [2,3,4,5,6,7,8]
      [3,1,7,1,3,1,15]

      iex> Matasano.Bytes.xor_sum { [1,2,3,4,5,6,7], [2,3,4,5,6,7,8] }
      [3,1,7,1,3,1,15]
  """
  def xor_sum(binary1, binary2) when is_binary(binary1) and is_binary(binary2) do
    xor_sum(binary_to_list(binary1), binary_to_list(binary2)) |> list_to_binary
  end

  def xor_sum(list1, list2) when is_list(list1) and is_list(list2) do
    Enum.zip(list1, list2) |> Enum.map(fn({x, y}) -> bxor x, y end)
  end

  def xor_sum({a, b}), do: xor_sum(a, b)

  @doc """
  Calculate the hamming distance between two binaries or lists of bytes.

  ## Examples

      iex> Matasano.Bytes.hamming_distance "this is a test", "wokka wokka!!!"
      37

      iex> Matasano.Bytes.hamming_distance 'this is a test', 'wokka wokka!!!'
      37
  """
  def hamming_distance(a, b) when is_binary(a) and is_binary(b) do
    hamming_distance(binary_to_list(a), binary_to_list(b))
  end

  def hamming_distance(a, b) when is_list(a) and is_list(b) do
    zipped = Enum.zip(a, b)
    distances = Enum.map zipped, fn({x, y}) ->
      hamming_distance <<x::integer>>, <<y::integer>>, 0
    end
    Enum.reduce distances, 0, &1 + &2
  end

  defp hamming_distance(<< bit_a::size(1), rest_a::bitstring >>, << bit_b::size(1), rest_b::bitstring >>, sum) do
    if bit_a != bit_b, do: sum = sum + 1
    hamming_distance rest_a, rest_b, sum
  end

  defp hamming_distance(_, _, sum), do: sum

  @doc """
  Transpose a list of lists such that the first sub-list in the final list
  contains the first element of each initial sub-list, and so forth.

  Lists with a final sub-list of a different length as the other lists
  will result in a final list whose sub-lists are not all the same size;
  the elements of the final list will be distributed to the lists in the
  return list, in order, until there are none left.

  ## Examples

      iex> Matasano.Bytes.transpose [[1,2,3,4], [5,6,7], [8,9,10], [11,12,13,14,15]]
      [[1,5,8,11], [2,6,9,12], [3,7,10,13], [4,14], [15]]
  """
  def transpose(list) when is_list(list) do
    longest = Enum.max list, fn(l) -> length l end
    transpose list, length(longest) - 1, []
  end

  defp transpose(_, -1, acc), do: acc

  defp transpose(list, position, acc) do
    at_pos = Enum.map(list, Enum.at(&1, position)) |> Enum.filter(&1 != nil)
    transpose list, position - 1, [ at_pos | acc ]
  end
end
