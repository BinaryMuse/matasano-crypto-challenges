defmodule Matasano.Plaintext do
  @printables Enum.to_list(32..126) ++ [10]
  @alphabet   List.flatten(List.foldr [65..90, 97..122, [10, 32]], [], fn(x, acc) -> [ Enum.to_list(x) ++ acc ] end)

  def printables, do: @printables
  def alphabet, do: @alphabet

  @doc """
  Calculate how likely a string or list of bytes represents English, ASCII
  text based on a basic scoring algorithm that counts alpha characters as 10
  points, printable characters as 5 points, and non-printable characters
  as -10 points. The score is normalized against the length of the text so
  that potential strings of different lengths can be compared to each other.

  ## Examples

      iex> Matasano.Plaintext.score_english "Cats"
      10.0

      iex> Matasano.Plaintext.score_english "This is a test"
      10.0

      iex> Matasano.Plaintext.score_english "cat!"
      8.75

      iex> Matasano.Plaintext.score_english "!@#$"
      5.0

      iex> Matasano.Plaintext.score_english <<7, 187, 234, 10>>
      -5.0
  """
  def score_english(text) when is_binary(text) do
    score_english binary_to_list(text)
  end

  def score_english(text) when is_list(text) do
    score = Enum.reduce text, 0, fn(x, acc) -> acc + score_letter(x) end
    score / length(text)
  end

  def score_letter(letter) do
    cond do
      Enum.member? alphabet, letter -> 10
      Enum.member? printables, letter -> 5
      true -> -10
    end
  end
end
