defmodule DstarParse do
  alias DstarParse.Parsers

  def parse_file(name) do
    content = name
    |> File.read!()
    |> Floki.parse()

    parser = detect_parser(content)
    parser.parse(content)
  end

  defp detect_parser(_content) do
    Parsers.Dplus
  end

end
