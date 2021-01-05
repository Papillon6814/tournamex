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

  @doc """
  Delete losers from match list.
  """
  def delete_loser(list, loser) when is_integer(loser) do
    delete_loser(list, [loser])
  end

  def delete_loser([a, b], loser) when is_integer(a) and is_integer(b) do
    list = [a, b] -- loser
    if length(list) == 1, do: hd(list), else: list
  end

  def delete_loser(list, loser) do
    case list do
      [[a, b], [c, d]] ->
        [delete_loser([a, b], loser), delete_loser([c, d], loser)]
      [a, [b, c]] when is_integer(a) and [a] == loser ->
        [b, c]
      [a, [b, c]] ->
        [a, delete_loser([b, c], loser)]
      [[a, b], c] when is_integer(c) and [c] == loser ->
        [a, b]
      [[a, b], c] ->
        [delete_loser([a, b], loser), c]
      [a, b] ->
        delete_loser([a, b], loser)
      _ -> raise "Bad Argument"
    end
  end

  @doc """
  Returns data which is presenting tournament brackets.
  """
  def brackets(match_list) do
    {:ok, align(match_list)}
  end

  defp align(match_list, result \\ []) do
    Enum.reduce(match_list, result, fn x, acc ->
      case x do
        x when is_list(x) ->
          align(x, acc)
        x when is_integer(x) and hd(match_list) == x ->
          [ml(match_list) | acc]
        x when is_integer(x) ->
          acc
        _ ->
          raise "invalid list"
      end
    end)
  end

  # Length of this list should be 2.
  defp ml(list) do
    Enum.reduce(list, [], fn element, acc ->
      case element do
        x when is_integer(x) -> [x | acc]
        _ -> [nil | acc]
      end
    end)
  end
end
