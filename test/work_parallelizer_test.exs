defmodule WorkParallelizerTest do
  use ExUnit.Case, async: true
  doctest WorkParallelizer

  test "chunks the numbers 1 through 50 in groups of 5 and gets their sum" do
    worker = fn chunk ->
      Process.sleep(2_500)
      Enum.sum(chunk)
    end

    distributor = fn data -> Enum.chunk_every(data, 5) end

    start_time = System.monotonic_time(:millisecond)

    results = WorkParallelizer.process(1..50, worker, distributor)

    duration = System.monotonic_time(:millisecond) - start_time

    # Sleep and duration test only for example to prove concurrency
    assert duration < 2600
    assert results == [15, 40, 65, 90, 115, 140, 165, 190, 215, 240]
  end

  test "groups words by their length and lower cases them" do
    test_data = ~w[THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG]

    worker = fn chunk -> Enum.map(chunk, &String.downcase/1) end

    distributor = fn data ->
      data
      |> Enum.group_by(&String.length/1)
      |> Enum.map(fn {_, l} -> l end)
    end

    results = WorkParallelizer.process(test_data, worker, distributor)

    assert results == [
             ["the", "fox", "the", "dog"],
             ["over", "lazy"],
             ["quick", "brown", "jumps"]
           ]
  end
end
