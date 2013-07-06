defmodule Part2 do
  def run_exercise(num) when num >= 9 and num <= 16 do
    case num do
       9 -> Part2.Exercise9.run
      10 -> Part2.Exercise10.run
      11 -> Part2.Exercise11.run
      12 -> Part2.Exercise12.run
      13 -> Part2.Exercise13.run
      14 -> Part2.Exercise14.run
      15 -> Part2.Exercise15.run
      16 -> Part2.Exercise16.run
    end
  end

  def run_exercise(_) do
    IO.puts :stderr, "This module only runs exercises 9 through 16..."
  end
end
