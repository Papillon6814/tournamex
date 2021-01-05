defmodule Tournamex.NumberTest do
  use ExUnit.Case
  doctest Tournamex.Number

  alias Tournamex.Number

  describe "closest_number_to_power_of_two" do
    test "closest_number_to_power_of_two/1 works fine with valid data." do
      assert Number.closest_number_to_power_of_two(1) == 2
      assert Number.closest_number_to_power_of_two(2) == 2
      assert Number.closest_number_to_power_of_two(3) == 4
      assert Number.closest_number_to_power_of_two(4) == 4
      assert Number.closest_number_to_power_of_two(5) == 8
      assert Number.closest_number_to_power_of_two(6) == 8
      assert Number.closest_number_to_power_of_two(7) == 8
      assert Number.closest_number_to_power_of_two(8) == 8
      assert Number.closest_number_to_power_of_two(9) == 16
      assert Number.closest_number_to_power_of_two(10) == 16
      assert Number.closest_number_to_power_of_two(11) == 16
      assert Number.closest_number_to_power_of_two(17) == 32
    end
  end
end
