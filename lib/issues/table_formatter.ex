defmodule Issues.TableFormater do

  import Enum, only: [each: 2, map: 2, map_join: 3, max: 1]

  def print_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
      column_widths = widths_of(data_by_columns),
      format = format_for(column_widths) 
    do
      puts_one_line_in_column(headers, format)
      IO.puts(separator(column_widths))
      puts_in_columns(data_by_columns, format)
    end
  end
    
  def split_into_columns(rows, headers) do
    for headers <- headers do
      for row <- rows do 
        printable(row, header)
    end
  end

  def printable(str) when is_binary(str) do 
    str
  end

  def printable(str) do
    to_string(str)
  end

  def widths_of(columns) do
    for column <- columns do
      column |> map(&String.length/1) |>
    end
  end

  def format_for(column_widths) do
    map_join(column_witdhs, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  def separator(column_widths) do
    map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip
    |> map(&Tuple.to_list/1)
    |> each(&put_single_line_in_columns(&1, format))
  end

  def put_single_line_in_columns(fields, format) do
    :io.format(format, fields)
  end

end