defmodule Mix.Tasks.Matasano do
  defmodule Run do
    use Mix.Task

    @exercises [1, 2, 3, 4, 5, 6, 7, 8]
    @shortdoc "Run one or more Matasano exercises"

    def run([]) do
      exit_with_help
    end

    def run([ex]) when ex in @exercises do
      run_exercise(ex)
    end

    def run(["all"]) do
      for n <- @exercises do
        IO.puts "\n==============================="
        IO.puts "Running exercise #{n}\n"
        Mix.Shell.IO.cmd "mix matasano.run #{n}"
      end
    end

    def run([ex]) when is_binary(ex) do
      num = try do
        String.to_integer(ex)
      rescue
        _ -> exit_with_help
      end

      run([num])
    end

    def run(_) do
      run([])
    end

    defp exit_with_help do
      [
        "Please pass a valid exercise to run.",
        "Valid exercises are #{Enum.join(@exercises, ", ")}, or 'all'."
      ] |> Enum.join("\n") |> Mix.raise
    end

    defp run_exercise(number) do
      case get_exercise_file(number) do
        nil ->
          Mix.raise "Could not find exercise number #{number}"
        file ->
          Mix.Task.run("run", [file])
      end
    end

    defp get_exercise_file(number) do
      get_exercise_files
      |> Enum.find(&is_exercise_number(&1, number))
    end

    defp get_exercise_files do
      Mix.Utils.extract_files(["exercises"], "*.exs")
    end

    defp is_exercise_number(filename, number) do
      filename = Path.split(filename) |> List.last
      two_digit = number
        |> Integer.to_char_list
        |> :string.right(2, ?0)
        |> List.to_string
      String.starts_with?(filename, two_digit)
    end
  end
end
