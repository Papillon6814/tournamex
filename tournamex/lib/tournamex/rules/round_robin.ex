defmodule Tournamex.RoundRobin do
  @moduledoc """
  # Round-Robin
  Generate round robin match-making data.
  """

  @doc """
  Generates a round robin match list.
  """
  @spec generate_match_list([integer()]) :: {:ok, [any()]}
  def generate_match_list(list) when is_list(list) do
    w = 1
    {x, y} = gen_members(list)

    {:ok, next_round(len(list), w, x, y)}
  end

  defp len(list) when rem(length(list), 2) == 0, do: length(list) - 1
  defp len(list),                                do: length(list)

  defp gen_members(list) do
    divider = list
      |> length()
      |> div(2)

    {list1, list2} = Enum.split(list, divider)

    if rem(length(list), 2) == 1 do
      if length(list1) < length(list2),
        do:   {[nil | list1], list2},
        else: {list1, [nil | list2]}
    else
      {list1, list2}
    end
  end

  defp next_round(n, w, list_x, list_y, matches \\ [])
  defp next_round(n, w, list_x, list_y, matches) when n >= w do
    list_x = List.insert_at(list_x, length(list_x), Enum.at(list_y, length(list_x)-1))
    list_y = List.insert_at(list_y, 0,              Enum.at(list_x, 1))
    {_, list_x} = List.pop_at(list_x, 1)
    {_, list_y} = List.pop_at(list_y, length(list_y)-1)

    new_matches =
      0..length(list_x)-1
      |> Enum.to_list()
      |> Enum.map(&"#{Enum.at(list_x, &1)}-#{Enum.at(list_y, &1)}")

    next_round(n, w+1, list_x, list_y, [new_matches | matches])
  end
  defp next_round(_, _, _, _, matches), do: matches
end
