defmodule Parallel do
  @doc """
  Perform an Enum.map operation in parallel.
  """
  def pmap(collection, func) do
    collection |> Enum.map(&do_spawn(&1, self, func)) |> Enum.map(&do_collect(&1))
  end

  defp do_spawn(elem, parent, func) do
    spawn_link fn -> (send parent, { self, func.(elem) }) end
  end

  defp do_collect(pid) do
    receive do { ^pid, result } -> result end
  end
end
