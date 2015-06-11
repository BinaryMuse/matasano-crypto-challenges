defmodule BytesTest do
  use ExUnit.Case, async: true

  doctest Matasano.Bytes
  doctest Matasano.Plaintext
  doctest Matasano.RepeatingKeyXor
end

