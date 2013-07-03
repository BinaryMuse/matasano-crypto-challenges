# Run with `./run.sh tests`

ExUnit.start

defmodule Matasano.Test do
  use ExUnit.Case, async: true
  doctest Matasano.Bytes
  doctest Matasano.Plaintext
  doctest Matasano.RepeatingKeyXor
end
