defmodule CliTest do
  use ExUnit.Case
  doctest Issues
  
  import Issues.CLI, only: [ parse_args: 1 ]

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

end