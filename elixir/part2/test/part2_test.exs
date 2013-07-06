Code.require_file "test_helper.exs", __DIR__

defmodule Part2Test do
  use ExUnit.Case, async: true

  doctest Matasano.Bytes
  doctest Matasano.Loader
  doctest Matasano.Plaintext
  doctest Matasano.RepeatingKeyXor

  doctest Matasano.Crypto.AES128
end
