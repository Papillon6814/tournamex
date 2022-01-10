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
        ["-20", "10-30"],
        ["-30", "20-10"],
        ["-10", "30-20"]
      ]
    end

    test "generate_match_list/1 with size 4 data works fine" do
      data = [10, 20, 30, 40]
      assert {:ok, match_list} = RoundRobin.generate_match_list(data)
      assert match_list === [
        ["10-30", "20-40"],
        ["10-40", "30-20"],
        ["10-20", "40-30"]
      ]
    end

    test "generate_match_list/1 with size 5 data works fine" do
      data = [10, 20, 30, 40, 50]
      assert {:ok, match_list} = RoundRobin.generate_match_list(data)
      assert match_list === [
        ["-30", "10-40", "20-50"],
        ["-40", "30-50", "10-20"],
        ["-50", "40-20", "30-10"],
        ["-20", "50-10", "40-30"],
        ["-10", "20-30", "50-40"]
      ]
    end

    test "generate_match_list/1 with size 6 data works fine" do
      data = [1, 2, 3, 4, 5, 6]
      assert {:ok, match_list} = RoundRobin.generate_match_list(data)
      assert match_list === [
        ["1-4", "2-5", "3-6"],
        ["1-5", "4-6", "2-3"],
        ["1-6", "5-3", "4-2"],
        ["1-3", "6-2", "5-4"],
        ["1-2", "3-4", "6-5"]
      ]
    end

    test "generate_match_list/1 with size 7 data works fine" do
      data = [1, 2, 3, 4, 5, 6, 7]
      assert {:ok, match_list} = RoundRobin.generate_match_list(data)
      assert match_list === [
        ["-4", "1-5", "2-6", "3-7"],
        ["-5", "4-6", "1-7", "2-3"],
        ["-6", "5-7", "4-3", "1-2"],
        ["-7", "6-3", "5-2", "4-1"],
        ["-3", "7-2", "6-1", "5-4"],
        ["-2", "3-1", "7-4", "6-5"],
        ["-1", "2-4", "3-5", "7-6"]
      ]
    end

    test "generate_match_list/1 with size 8 data works fine" do
      data = [1, 2, 3, 4, 5, 6, 7, 8]
      assert {:ok, match_list} = RoundRobin.generate_match_list(data)
      assert match_list === [
        ["1-5", "2-6", "3-7", "4-8"],
        ["1-6", "5-7", "2-8", "3-4"],
        ["1-7", "6-8", "5-4", "2-3"],
        ["1-8", "7-4", "6-3", "5-2"],
        ["1-4", "8-3", "7-2", "6-5"],
        ["1-3", "4-2", "8-5", "7-6"],
        ["1-2", "3-5", "4-6", "8-7"]
      ]
    end
  end
end
