defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1, sort_descending: 1]

  test ":help returned when parsing option with -h and --help" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "gives default when only 2 arguments are given" do
    assert parse_args(["user", "project", "55"]) == {"user", "project", 55}
  end

  test "returns values when all 3 are given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "descending sort works the right way" do
    result = sort_descending(fake_list(["a", "b", "c"]))

    issues =
      for issue <- result do
        Map.get(issue, "created_at")
      end

    assert issues == ~w{ c b a }
  end

  defp fake_list(values) do
    for value <- values do
      %{"created_at" => value, "other_data" => "xxx"}
    end
  end
end
