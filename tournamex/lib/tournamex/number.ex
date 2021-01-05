defmodule Tournamex.Number do
  @moduledoc """
  # Number
  Numbers for managing a tournament.
  """

  @doc """
  Finds a closest number to power of 2.
  It is used for presenting tournament brackets.
  """
  def closest_number_to_power_of_two(num, acc \\ 2) do
    if num > acc do
      closest_number_to_power_of_two(num, acc * 2)
    else
      acc
    end
  end
end
