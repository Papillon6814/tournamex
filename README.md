# tournamex
[![hex.pm version](https://img.shields.io/hexpm/v/tournamex.svg)](https://hex.pm/packages/tournamex)
[![hex.pm](https://img.shields.io/hexpm/l/tournamex.svg)](https://github.com/Papillon6814/tournamex/blob/master/LICENSE)

Elixir module for generating tournament brackets.
We will add functions gradually.

## Installation
```elixir
defp deps do
  [
    {:tournamex, "~> 0.1.0"}
  ]
end
```

## Usage
```elixir
iex(1)> Tournamex.generate_matchlist([1, 2, 3, 4, 5])
{:ok, [[5, 2], [3, [4, 1]]]}
```
