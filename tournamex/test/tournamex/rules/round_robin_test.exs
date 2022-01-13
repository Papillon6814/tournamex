defmodule Tournamex.RoundRobinTest do
  @moduledoc """
  総当りテスト
  """
  use ExUnit.Case

  alias Tournamex.RoundRobin
  doctest Tournamex.RoundRobin

  describe "generate_match_list/1" do
    test "generate_match_list/1 with size 3 data works fine" do
      data = [10, 20, 30]
      assert {:ok, match_list} = RoundRobin.generate_match_list(data)
      assert match_list === [
        [
          {"-20", nil},
          {"10-30", nil}
        ],
        [
          {"-30", nil},
          {"20-10", nil}
        ],
        [
          {"-10", nil},
          {"30-20", nil}
        ]
      ]
    end

    test "generate_match_list/1 with size 4 data works fine" do
      data = [10, 20, 30, 40]
      assert {:ok, match_list} = RoundRobin.generate_match_list(data)
      assert match_list === [
        [
          {"10-30", nil},
          {"20-40", nil}
        ],
        [
          {"10-40", nil},
          {"30-20", nil}
        ],
        [
          {"10-20", nil},
          {"40-30", nil}
        ]
      ]
    end

    test "generate_match_list/1 with size 5 data works fine" do
      data = [10, 20, 30, 40, 50]
      assert {:ok, match_list} = RoundRobin.generate_match_list(data)
      assert match_list === [
        [
          {"-30", nil},
          {"10-40", nil},
          {"20-50", nil}
        ],
        [
          {"-40", nil},
          {"30-50", nil},
          {"10-20", nil}
        ],
        [
          {"-50", nil},
          {"40-20", nil},
          {"30-10", nil}
        ],
        [
          {"-20", nil},
          {"50-10", nil},
          {"40-30", nil}
        ],
        [
          {"-10", nil},
          {"20-30", nil},
          {"50-40", nil}
        ]
      ]
    end

    test "generate_match_list/1 with size 6 data works fine" do
      data = [1, 2, 3, 4, 5, 6]
      assert {:ok, match_list} = RoundRobin.generate_match_list(data)
      assert match_list === [
        [
          {"1-4", nil},
          {"2-5", nil},
          {"3-6", nil}
        ],
        [
          {"1-5", nil},
          {"4-6", nil},
          {"2-3", nil}
        ],
        [
          {"1-6", nil},
          {"5-3", nil},
          {"4-2", nil}
        ],
        [
          {"1-3", nil},
          {"6-2", nil},
          {"5-4", nil}
        ],
        [
          {"1-2", nil},
          {"3-4", nil},
          {"6-5", nil}
        ]
      ]
    end

    test "generate_match_list/1 with size 7 data works fine" do
      data = [1, 2, 3, 4, 5, 6, 7]
      assert {:ok, match_list} = RoundRobin.generate_match_list(data)
      assert match_list === [
        [
          {"-4", nil},
          {"1-5", nil},
          {"2-6", nil},
          {"3-7", nil}
        ],
        [
          {"-5", nil},
          {"4-6", nil},
          {"1-7", nil},
          {"2-3", nil}
        ],
        [
          {"-6", nil},
          {"5-7", nil},
          {"4-3", nil},
          {"1-2", nil}
        ],
        [
          {"-7", nil},
          {"6-3", nil},
          {"5-2", nil},
          {"4-1", nil}
        ],
        [
          {"-3", nil},
          {"7-2", nil},
          {"6-1", nil},
          {"5-4", nil}
        ],
        [
          {"-2", nil},
          {"3-1", nil},
          {"7-4", nil},
          {"6-5", nil}
        ],
        [
          {"-1", nil},
          {"2-4", nil},
          {"3-5", nil},
          {"7-6", nil}
        ]
      ]
    end

    test "generate_match_list/1 with size 8 data works fine" do
      data = [1, 2, 3, 4, 5, 6, 7, 8]
      assert {:ok, match_list} = RoundRobin.generate_match_list(data)
      assert match_list === [
        [
          {"1-5", nil},
          {"2-6", nil},
          {"3-7", nil},
          {"4-8", nil}
        ],
        [
          {"1-6", nil},
          {"5-7", nil},
          {"2-8", nil},
          {"3-4", nil}
        ],
        [
          {"1-7", nil},
          {"6-8", nil},
          {"5-4", nil},
          {"2-3", nil}
        ],
        [
          {"1-8", nil},
          {"7-4", nil},
          {"6-3", nil},
          {"5-2", nil}
        ],
        [
          {"1-4", nil},
          {"8-3", nil},
          {"7-2", nil},
          {"6-5", nil}
        ],
        [
          {"1-3", nil},
          {"4-2", nil},
          {"8-5", nil},
          {"7-6", nil}
        ],
        [
          {"1-2", nil},
          {"3-5", nil},
          {"4-6", nil},
          {"8-7", nil}
        ]
      ]
    end
  end

  describe "count_win/2" do
    test "works" do
      match_list = [
          [
            {"10-30", 10},
            {"20-40", 20}
          ],
          [
            {"10-40", 10},
            {"30-20", 20}
          ],
          [
            {"10-20", 10},
            {"40-30", 30}
          ]
        ]

      assert RoundRobin.count_win(match_list, 10) === 3
      assert RoundRobin.count_win(match_list, 20) === 2
      assert RoundRobin.count_win(match_list, 30) === 1
      assert RoundRobin.count_win(match_list, 40) === 0
    end
  end

  describe "insert_winner_id" do
    test "works with current index: 0" do
      match_list = [
        [
          {"10-30", nil},
          {"20-40", nil}
        ],
        [
          {"10-40", nil},
          {"30-20", nil}
        ],
        [
          {"10-20", nil},
          {"40-30", nil}
        ]
      ]

      match_list = %{
        "match_list" => match_list,
        "current_match_index" => 0,
      }

      assert RoundRobin.insert_winner_id(match_list, 40, "20-40") === [
        [{"10-30", nil}, {"20-40", 40}],
        [{"10-40", nil}, {"30-20", nil}],
        [{"10-20", nil}, {"40-30", nil}]
      ]
      assert RoundRobin.insert_winner_id(match_list, 20, "20-40") === [
        [{"10-30", nil}, {"20-40", 20}],
        [{"10-40", nil}, {"30-20", nil}],
        [{"10-20", nil}, {"40-30", nil}]
      ]

      match_list = [
        [
          {"10-30", nil},
          {"20-40", 20}
        ],
        [
          {"10-40", nil},
          {"30-20", nil}
        ],
        [
          {"10-20", nil},
          {"40-30", nil}
        ]
      ]

      match_list = %{
        "match_list" => match_list,
        "current_match_index" => 0,
      }

      assert RoundRobin.insert_winner_id(match_list, 10, "10-30") === [
        [{"10-30", 10}, {"20-40", 20}],
        [{"10-40", nil}, {"30-20", nil}],
        [{"10-20", nil}, {"40-30", nil}]
      ]
    end

    test "works with current index: 1" do
      match_list = [
        [
          {"10-30", nil},
          {"20-40", nil}
        ],
        [
          {"10-40", nil},
          {"30-20", nil}
        ],
        [
          {"10-20", nil},
          {"40-30", nil}
        ]
      ]

      match_list = %{
        "match_list" => match_list,
        "current_match_index" => 1,
      }

      assert RoundRobin.insert_winner_id(match_list, 40, "10-40") === [
        [{"10-30", nil}, {"20-40", nil}],
        [{"10-40", 40}, {"30-20", nil}],
        [{"10-20", nil}, {"40-30", nil}]
      ]
      assert RoundRobin.insert_winner_id(match_list, 20, "30-20") === [
        [{"10-30", nil}, {"20-40", nil}],
        [{"10-40", nil}, {"30-20", 20}],
        [{"10-20", nil}, {"40-30", nil}]
      ]
    end
  end
end
