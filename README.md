# WorkParallelizer

WorkParallelizer processes enumerable data concurrently.

## Installation
```
mix deps.get
```

## Usage
```elixir
data = 1..50

worker = fn chunk -> Enum.sum(chunk) end

distributor = fn data -> Enum.chunk_every(data, 5) end

WorkParallelizer.process(data, worker, distributor)
```
