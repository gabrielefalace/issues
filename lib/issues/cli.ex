defmodule Issues.CLI do
  import Issues.TableFormatter, only: [print_columns: 2]

  @default_count 4

  @moduledoc """
  Handle command-line parsing and the dispatch to functions
  that will generate a table of the last _n_ issues in a github project
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which return :help.
  Otherwise it is a github name, project name, and optionally the number
  of entries to format.

  Return a tuple of `{user, project, count}` or `:help` if help was given.
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_resolver
  end

  def args_resolver([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def args_resolver([user, project]) do
    {user, project, @default_count}
  end

  def args_resolver(_) do
    :help
  end

  def process(:help) do
    IO.puts("""
    usage: issues <user> <project> [ count | #{@default_count}]
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_descending()
    |> select_last(count)
    |> print_columns(["number", "created_at", "title"])
  end

  def decode_response({:ok, body}) do
    body
  end

  def decode_response({:error, error}) do
    IO.puts("Error fetching from Github: #{error["message"]}")
    System.halt(2)
  end

  def sort_descending(issue_list) do
    issue_list
    |> Enum.sort(fn a, b ->
      a["created_at"] >= b["created_at"]
    end)
  end

  def select_last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse()
  end

  @doc """
  This is an old implementation. Kept for syntax reference.
  """
  def old_parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])

    case parse do
      {[help: true], _, _} -> :help
      {_, [user, project, count], _} -> {user, project, String.to_integer(count)}
      {_, [user, project], _} -> {user, project, @default_count}
      _ -> :help
    end
  end
end
