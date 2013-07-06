defmodule Matasano.Loader do
  @doc """
  Load a file as a list of binaries, one per line of the file.
  Newlines and other whitespace are stripped and blank lines
  are skipped.
  """
  def lines_from_file(path) do
    File.open! path, [:read], fn(file) ->
      do_readline file, []
    end
  end

  defp do_readline(file, acc) do
    case IO.readline(file) do
      :eof -> Enum.reverse acc
      data -> do_readline file, [ String.strip(data) | acc ]
    end
  end

  @doc """
  Load text from a file; the text can optionally be split by newlines.
  Newlines and other whitespace are stripped and blank lines
  are skipped.
  """
  def text_from_file(path) do
    lines_from_file(path) |> Enum.join("")
  end
end
