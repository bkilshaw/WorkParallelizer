defmodule WorkParallelizer do
  @moduledoc """
  Documentation for `WorkParallelizer`.
  """

  @doc """
  Accepts enumerable data, chunks it according to the distributor
  and sends chunks to the worker to be processed in concurrent tasks

  ## Examples
      iex> WorkParallelizer.process(1..15, &Enum.sum(&1), &Enum.chunk_every(&1, 5))
      [15, 40, 65]

  """

  @spec process(Enumerable.t(), function(), function()) :: list()
  def process(data, worker, distributor) when is_function(worker) and is_function(distributor) do
    data
    |> distributor.()
    |> Enum.map(fn chunk ->
      Task.async(fn ->
        worker.(chunk)
      end)
    end)
    |> Task.await_many()
  end
end
