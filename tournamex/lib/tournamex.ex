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
      hd(shuffled)
    2 ->
      shuffled
    _ ->
      b =
        Enum.slice(shuffled, 0..trunc(length(shuffled)/2 -1))
        |> generate()

      c =
        Enum.slice(shuffled, trunc(length(shuffled)/2)..length(shuffled)-1)
        |> generate()

      [b,c]
    end
  end
  defp generate([]), do: {:error, "No entrants"}

  @doc """
  Convert match list to list.
  FIXME: 不要
  """
  def match_list_to_list(match_list) do
    List.flatten(match_list)
  end

  @doc """
  Initialize match list with fight result.
  """
  def initialize_match_list_with_fight_result(match_list, result \\ []) do
    Enum.reduce(match_list, result, fn match, acc ->
      case match do
        x when is_integer(match) ->
          acc ++ [%{"user_id" => x, "is_loser" => false}]
        x when is_list(match) ->
          acc ++ [initialize_match_list_with_fight_result(x)]
        x -> x
      end
    end)
  end

  @doc """
  Initialize match list of teams with fight result.
  """
  def initialize_match_list_of_team_with_fight_result(match_list, result \\ []) do
    Enum.reduce(match_list, result, fn match, acc ->
      case match do
        x when is_integer(match) ->
          acc ++ [%{"team_id" => x, "is_loser" => false}]
        x when is_list(match) ->
          acc ++ [initialize_match_list_of_team_with_fight_result(x)]
        x -> x
      end
    end)
  end

  @doc """
  Renew match list with loser.
  """
  def renew_match_list_with_loser(match_list, loser) when is_integer(loser) do
    renew_defeat(match_list, loser)
  end

  defp renew_defeat(match_list, loser, result \\ []) do
    Enum.reduce(match_list, result, fn match, acc ->
      case match do
        x when is_map(match) ->
          if x["user_id"] == loser do
            acc ++ [Map.put(x, "is_loser", true)]
          else
            acc ++ [x]
          end
        x when is_list(match) ->
          acc ++ [renew_defeat(x, loser)]
        x -> x
      end
    end)
  end

  @doc """
  Win count increment.
  """
  def win_count_increment(match_list, user_id) when is_integer(user_id) do
    renew_win_count(match_list, user_id)
  end

  defp renew_win_count(match_list, user_id, result \\ []) do
    Enum.reduce(match_list, result, fn match, acc ->
      case match do
        x when is_map(match) ->
          if x["user_id"] == user_id do
            count = x["win_count"]
            acc ++ [Map.put(x, "win_count", count+1)]
          else
            acc ++ [x]
          end
        x when is_list(match) ->
          acc ++ [renew_win_count(x, user_id)]
        x -> x
      end
    end)
  end

  @doc """
  Check if the user has already lost.
  """
  def check_lose?(match_list, user_id) when is_integer(user_id) do
    check?(match_list, user_id)
  end

  defp check?(match_list, user_id, result \\ false) do
    Enum.reduce(match_list, result, fn match, acc ->
      case match do
        x when is_map(match) ->
          if x["user_id"] == user_id do
            x["is_loser"]
          else
            acc
          end
        x when is_list(match) -> check?(x, user_id, acc)
        _ -> acc
      end
    end)
  end

  @doc """
  Put value on bracket list.
  The second argument 'key' should be the user id.
  """
  def put_value_on_brackets(match_list, key, value, result \\ []) when is_map(value) do
    Enum.reduce(match_list, result, fn match, acc ->
      case match do
        x when is_list(x) ->
          acc ++ [put_value_on_brackets(x, key, value)]
        x when is_map(x) ->
          if x["user_id"] == key do
            acc ++ [Map.merge(x, value)]
          else
            acc ++ [x]
          end
        x ->
          acc ++ [x]
      end
    end)
  end

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
      [a] when is_integer(a) ->
        []
      a when is_integer(a) ->
        []
      _ -> raise "Bad Argument"
    end
  end

  @doc """
  Returns data which is presenting tournament brackets.
  """
  def brackets_with_fight_result(match_list) do
    {:ok, align_with_fight_result(match_list)}
  end

  defp align_with_fight_result(match_list, result \\ []) do
    Enum.reduce(match_list, result, fn x, acc ->
      case x do
        x when is_list(x) ->
          align_with_fight_result(x, acc)
        x when is_map(x) ->
          if hd(match_list) == x do
            [fr(match_list) | acc]
          else
            acc
          end
        _ -> acc
      end
    end)
  end

  defp fr(list) do
    Enum.reduce(list, [], fn element, acc ->
      case element do
        x when is_map(x) -> [x | acc]
        _ -> [nil | acc]
      end
    end)
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
