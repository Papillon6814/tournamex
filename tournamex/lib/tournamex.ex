defmodule Tournamex do
  @moduledoc """
  # Tournamex
  Simple package for managing online tournament system.
  Tournamex only has a function for generating matchlist from list.
  We will add functions gradually.
  """

  @doc """
  Generates a matchlist.
  """
  def generate_matchlist(list) do
    unless is_list(list) do
      {:error, "Argument is not list"}
    else
      list
      |> generate()
      |> case do
        list when is_list(list) -> {:ok, list}
        tuple when is_tuple(tuple) -> tuple
        scala -> {:ok, [scala]}
      end
    end
  end

  defp generate(list) when list != [] do
    shuffled = list |> Enum.shuffle()
    case(length(shuffled)) do
    1 ->
      shuffled |> hd()
    2 -> shuffled
    _ ->
      b = Enum.slice(shuffled, 0..trunc(length(shuffled)/2 -1))
      |> generate()

      c = Enum.slice(shuffled, trunc(length(shuffled)/2)..length(shuffled)-1)
      |> generate()

      [b,c]
    end
  end
  defp generate([]), do: {:error, "No entrants"}
end
