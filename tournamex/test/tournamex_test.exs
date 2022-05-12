defmodule TournamexTest do
  use ExUnit.Case
  doctest Tournamex

  describe "generate_matchlist_without_shuffle/1" do
    test "generate_matchlist_without_shuffle/1 with valid data works fine" do
      data = [1, 2, 3, 4, 5, 6]
      assert {:ok, matchlist} = Tournamex.generate_matchlist_without_shuffle(data)
      assert matchlist == [[1, [2, 3]], [4, [5, 6]]]
    end

    test"generate_matchlist_without_shuffle/2 with valid data size 9 works fine" do
      data = [1, 2, 3, 4, 5, 6, 7, 8, 9]
      assert {:ok, matchlist} = Tournamex.generate_matchlist_without_shuffle(data)
      assert matchlist == [[[1, 2], [3, 4]], [[5, 6], [7, [8, 9]]]]
    end
  end

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

  describe "initialize_match_list_with_fight_result/2" do
    test "initialize_match_list_with_fight_result/2 with valid data works fine" do
      data = [1, 2, 3, 4, 5, 6]
      {:ok, matchlist} = Tournamex.generate_matchlist(data)
      assert l = Tournamex.initialize_match_list_with_fight_result(matchlist)
      l
      |> hd()
      |> hd()
      |> Map.get("is_loser")
      |> refute()
    end
  end

  describe "check_lose?/2" do
    test "check_lose?/2 works fine with valid data (light check)" do
      data = [1, 2, 3, 4, 5, 6]
      {:ok, matchlist} = Tournamex.generate_matchlist(data)
      l = Tournamex.initialize_match_list_with_fight_result(matchlist)
      refute Tournamex.check_lose?(l, 2)
    end
  end

  describe "renew_match_list/2" do
    test "renew_match_list/2 with valid data works fine" do
      data = [1, 2, 3, 4, 5, 6]
      {:ok, matchlist} = Tournamex.generate_matchlist(data)
      l = Tournamex.initialize_match_list_with_fight_result(matchlist)
      assert new_list = Tournamex.renew_match_list_with_loser(l, 2)
      assert Tournamex.check_lose?(new_list, 2)
      refute Tournamex.check_lose?(new_list, 3)
    end

    test "renew_match_list_with_loser/2 with valid data works fine" do
      data = [
        %{"user_id" => 3, "is_loser" => false},
        [
          %{"user_id" => 1, "is_loser" => false},
          %{"user_id" => 2, "is_loser" => false}
        ]
      ]
      assert new_list = Tournamex.renew_match_list_with_loser(data, 2)
      assert Tournamex.check_lose?(new_list, 2)
      refute Tournamex.check_lose?(new_list, 3)
    end
  end

  describe "win_count_increment/2" do
    test "win_count_increment/2 with valid data works fine" do
      data = [
        %{"user_id" => 3, "win_count" => 1},
        [
          %{"user_id" => 1, "win_count" => 0},
          %{"user_id" => 2, "win_count" => 0}
        ]
      ]

      assert new_list = Tournamex.win_count_increment(data, 1)
      assert new_list == [
        %{"user_id" => 3, "win_count" => 1},
        [
          %{"user_id" => 1, "win_count" => 1},
          %{"user_id" => 2, "win_count" => 0}
        ]
      ]

      assert new_list = Tournamex.win_count_increment(new_list, 1)
      assert new_list == [
        %{"user_id" => 3, "win_count" => 1},
        [
          %{"user_id" => 1, "win_count" => 2},
          %{"user_id" => 2, "win_count" => 0}
        ]
      ]
    end
  end

  describe "brackets with fight result" do
    test "brackets_with_fight_result/1 works fine with valid list data of size 3" do
      match_list = [
        %{"user_id" => 3, "is_loser" => false},
        [
          %{"user_id" => 1, "is_loser" => false},
          %{"user_id" => 2, "is_loser" => false}
        ]
      ]

      assert Tournamex.brackets_with_fight_result(match_list) == {:ok,
        [[%{"user_id" => 2, "is_loser" => false}, %{"user_id" => 1, "is_loser" => false}],
        [nil, %{"user_id" => 3, "is_loser" => false}]]
      }
    end

    test "brackets_with_fight_result/1 works fine with valid list data of size 4" do
      match_list = [
        [%{"user_id" => 1, "is_loser" => false}, %{"user_id" => 2, "is_loser" => false}],
        [%{"user_id" => 3, "is_loser" => false}, %{"user_id" => 4, "is_loser" => false}]
      ]

      assert Tournamex.brackets_with_fight_result(match_list) == {:ok,
        [[%{"user_id" => 4, "is_loser" => false}, %{"user_id" => 3, "is_loser" => false}],
        [%{"user_id" => 2, "is_loser" => false}, %{"user_id" => 1, "is_loser" => false}]]
      }
    end

    test "brackets_with_fight_result/1 works fine with valid list data of size 5" do
      match_list = [
        [%{"user_id" => 1, "is_loser" => false}, %{"user_id" => 2, "is_loser" => false}],
        [%{"user_id" => 3, "is_loser" => false},
        [%{"user_id" => 4, "is_loser" => false}, %{"user_id" => 5, "is_loser" => false}]]
      ]
      assert Tournamex.brackets_with_fight_result(match_list) == {:ok,
        [[%{"user_id" => 5, "is_loser" => false}, %{"user_id" => 4, "is_loser" => false}],
        [nil, %{"user_id" => 3, "is_loser" => false}],
        [%{"user_id" => 2, "is_loser" => false}, %{"user_id" => 1, "is_loser" => false}]]
      }
    end

    test "brackets_with_fight_result/1 works fine with valid list data of size 6" do
      match_list = [
        [%{"user_id" => 1, "is_loser" => false}, [%{"user_id" => 2, "is_loser" => false}, %{"user_id" => 3, "is_loser" => false}]],
        [%{"user_id" => 4, "is_loser" => false}, [%{"user_id" => 5, "is_loser" => false}, %{"user_id" => 6, "is_loser" => false}]]
      ]
      assert Tournamex.brackets_with_fight_result(match_list) == {:ok,
        [[%{"user_id" => 6, "is_loser" => false}, %{"user_id" => 5, "is_loser" => false}],
        [nil, %{"user_id" => 4, "is_loser" => false}],
        [%{"user_id" => 3, "is_loser" => false}, %{"user_id" => 2, "is_loser" => false}],
        [nil, %{"user_id" => 1, "is_loser" => false}]]
      }
    end

    test "brackets/1 works fine with valid list data of size 7" do
      match_list = [
        [%{"user_id" => 1, "is_loser" => false},
        [%{"user_id" => 2, "is_loser" => false}, %{"user_id" => 3, "is_loser" => false}]],
        [[%{"user_id" => 4, "is_loser" => false}, %{"user_id" => 5, "is_loser" => false}],
        [%{"user_id" => 6, "is_loser" => false}, %{"user_id" => 7, "is_loser" => false}]]
      ]

      assert Tournamex.brackets_with_fight_result(match_list) == {:ok,
        [[%{"user_id" => 7, "is_loser" => false}, %{"user_id" => 6, "is_loser" => false}],
        [%{"user_id" => 5, "is_loser" => false}, %{"user_id" => 4, "is_loser" => false}],
        [%{"user_id" => 3, "is_loser" => false}, %{"user_id" => 2, "is_loser" => false}],
        [nil, %{"user_id" => 1, "is_loser" => false}]]
      }
    end
  end

  describe "brackets" do
    test "brackets/1 works fine with valid list data of size 3" do
      match_list = [3, [1, 2]]
      assert Tournamex.brackets(match_list) == {:ok, [[2, 1], [nil, 3]]}
    end

    test "brackets/1 works fine with valid list data of size 4" do
      match_list = [[1, 2], [3, 4]]
      assert Tournamex.brackets(match_list) == {:ok, [[4, 3], [2, 1]]}
    end

    test "brackets/1 works fine with valid list data of size 5" do
      match_list = [[1, 2], [3, [4, 5]]]
      assert Tournamex.brackets(match_list) == {:ok, [[5, 4], [nil, 3], [2, 1]]}
    end

    test "brackets/1 works fine with valid list data of size 6" do
      match_list = [[1, [2, 3]], [4, [5, 6]]]
      assert Tournamex.brackets(match_list) == {:ok, [[6, 5], [nil, 4], [3, 2], [nil, 1]]}
    end

    test "brackets/1 works fine with valid list data of size 7" do
      match_list = [[1, [2, 3]], [[4, 5], [6, 7]]]
      assert Tournamex.brackets(match_list) == {:ok, [[7, 6], [5, 4], [3, 2], [nil, 1]]}
    end

    test "brackets/1 works fine with valid list data of size 8" do
      match_list = [[[1, 2], [3, 4]], [[5, 6], [7, 8]]]
      assert Tournamex.brackets(match_list) == {:ok, [[8, 7], [6, 5], [4, 3], [2, 1]]}
    end

    test "brackets/1 works fine with valid list data of size 9" do
      match_list = [[[1, 2], [3, 4]], [[5, 6], [7, [8, 9]]]]
      assert Tournamex.brackets(match_list) == {:ok, [[9, 8], [nil, 7], [6, 5], [4, 3], [2, 1]]}
    end
  end

  describe "put value on brackets" do
    test "put_value_on_brackets/4 works fine with a valid data size of 3" do
      match_list = [
        %{"user_id" => 3, "is_loser" => false},
        [
          %{"user_id" => 1, "is_loser" => false},
          %{"user_id" => 2, "is_loser" => false}
        ]
      ]

      brackets = Tournamex.put_value_on_brackets(match_list, 2, %{"add" => "data"})
      assert brackets == [
        %{"user_id" => 3, "is_loser" => false},
        [
          %{"user_id" => 1, "is_loser" => false},
          %{"user_id" => 2, "is_loser" => false, "add" => "data"}
        ]
      ]
    end

    test "put_value_on_brackets/4 works fine with a valid data size of 4" do
      match_list = [
        [%{"user_id" => 1, "is_loser" => false}, %{"user_id" => 2, "is_loser" => false}],
        [%{"user_id" => 3, "is_loser" => false}, %{"user_id" => 4, "is_loser" => false}]
      ]

      brackets = Tournamex.put_value_on_brackets(match_list, 2, %{"add" => "data"})
      assert brackets == [
        [%{"user_id" => 1, "is_loser" => false},
        %{"user_id" => 2, "is_loser" => false, "add" => "data"}],
        [%{"user_id" => 3, "is_loser" => false},
        %{"user_id" => 4, "is_loser" => false}]
      ]
    end
  end

  describe "delete loser" do
    test "delete_loser/2 works fine with a valid data of 4 players" do
      list = [[1, 2], [3, 4]]
      assert Tournamex.delete_loser(list, 1) == [2, [3, 4]]
      assert Tournamex.delete_loser(list, [1]) == [2, [3, 4]]
      assert Tournamex.delete_loser(list, 2) == [1, [3, 4]]
      assert Tournamex.delete_loser(list, [2]) == [1, [3, 4]]
      assert Tournamex.delete_loser(list, 3) == [[1, 2], 4]
      assert Tournamex.delete_loser(list, [3]) == [[1, 2], 4]
      assert Tournamex.delete_loser(list, 4) == [[1, 2], 3]
      assert Tournamex.delete_loser(list, [4]) == [[1, 2], 3]
    end

    test "delete_loser/2 works fine with a valid data of 3 players" do
      list = [[1, 2], 3]

      assert Tournamex.delete_loser(list, 1) == [2, 3]
      assert Tournamex.delete_loser(list, [1]) == [2, 3]
      assert Tournamex.delete_loser(list, 2) == [1, 3]
      assert Tournamex.delete_loser(list, [2]) == [1, 3]
      assert Tournamex.delete_loser(list, 3) == [1, 2]
      assert Tournamex.delete_loser(list, [3]) == [1, 2]
    end

    test "delete_loser/2 works fine with a valid data of 5 players" do
      list = [[1, 2], [[3, 4], 5]]

      assert Tournamex.delete_loser(list, 1) == [2, [[3, 4], 5]]
      assert Tournamex.delete_loser(list, [1]) == [2, [[3, 4], 5]]
      assert Tournamex.delete_loser(list, 2) == [1, [[3, 4], 5]]
      assert Tournamex.delete_loser(list, [2]) == [1, [[3, 4], 5]]
      assert Tournamex.delete_loser(list, 3) == [[1, 2], [4, 5]]
      assert Tournamex.delete_loser(list, [3]) == [[1, 2], [4, 5]]
      assert Tournamex.delete_loser(list, 4) == [[1, 2], [3, 5]]
      assert Tournamex.delete_loser(list, [4]) == [[1, 2], [3, 5]]
      assert Tournamex.delete_loser(list, 5) == [[1, 2], [3, 4]]
      assert Tournamex.delete_loser(list, [5]) == [[1, 2], [3, 4]]
    end

    test "delete_loser/2 does not work with an invalid data of 3 players" do
      list = [1, 2, 3]

      assert catch_error(Tournamex.delete_loser(list, 1)) == %RuntimeError{message: "Bad Argument"}
    end

    test "delete_loser/2 does not work with an invalid data of 1 player" do
      list = [1]

      #assert catch_error(Tournamex.delete_loser(list, 1)) == %RuntimeError{message: "Bad Argument"}
      assert Tournamex.delete_loser(list, 1) == []
    end
  end
end
