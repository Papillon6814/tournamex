defmodule TournamexTest do
  use ExUnit.Case
  doctest Tournamex

  describe "generate_matchlist/1" do
    test "generate_matchlist/1 with valid data works fine" do
      data = [1, 2, 3, 4, 5, 6]
      assert {:ok, matchlist} = Tournamex.generate_matchlist(data)
      assert is_list(matchlist)
    end

    test "generate_matchlist/1 with invalid integer data does not work" do
      data = 1
      assert {:error, _} = Tournamex.generate_matchlist(data)
    end

    test "generate_matchlist/1 with invalid map data does not work" do
      data = %{a: 1, b: 2, c: 3}
      assert {:error, _} = Tournamex.generate_matchlist(data)
    end
  end

  describe "brackets" do
    test "brackets/1 works fine with valid list data of size 3" do
      match_list = [3, [1, 2]]
      assert Tournamex.brackets(match_list) == [[2, 1], [nil, 3]]
    end

    test "brackets/1 works fine with valid list data of size 4" do
      match_list = [[1, 2], [3, 4]]
      assert Tournamex.brackets(match_list) == [[4, 3], [2, 1]]
    end

    test "brackets/1 works fine with valid list data of size 5" do
      match_list = [[1, 2], [3, [4, 5]]]
      assert Tournamex.brackets(match_list) == [[5, 4], [nil, 3], [2, 1]]
    end

    test "brackets/1 works fine with valid list data of size 6" do
      match_list = [[1, [2, 3]], [4, [5, 6]]]
      assert Tournamex.brackets(match_list) == [[6, 5], [nil, 4], [3, 2], [nil, 1]]
    end

    test "brackets/1 works fine with valid list data of size 7" do
      match_list = [[1, [2, 3]], [[4, 5], [6, 7]]]
      assert Tournamex.brackets(match_list) == [[7, 6], [5, 4], [3, 2], [nil, 1]]
    end

    test "brackets/1 works fine with valid list data of size 8" do
      match_list = [[[1, 2], [3, 4]], [[5, 6], [7, 8]]]
      assert Tournamex.brackets(match_list) == [[8, 7], [6, 5], [4, 3], [2, 1]]
    end

    test "brackets/1 works fine with valid list data of size 9" do
      match_list = [[[1, 2], [3, 4]], [[5, 6], [7, [8, 9]]]]
      assert Tournamex.brackets(match_list) == [[9, 8], [nil, 7], [6, 5], [4, 3], [2, 1]]
    end
  end
end
