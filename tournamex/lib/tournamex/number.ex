defmodule Tournamex.Number do
  def closest_number_to_power_of_two(num, acc \\ 2) do
    if num > acc do
      closest_number_to_power_of_two(num, acc * 2)
    else
      acc
    end
  end
end
