defmodule Mix.Tasks.Exercise do
  use Mix.Task

  @shortdoc "Run a specific Matasno Crypto Challenge exercise"

  def run([exercise | []]) do
    Mix.Task.run "compile", ["--quick"]
    exercise |> binary_to_integer |> Part2.run_exercise
  end

  def run(_) do
    IO.puts "Usage: mix exercise <num>"
  end
end
