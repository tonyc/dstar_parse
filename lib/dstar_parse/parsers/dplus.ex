defmodule DstarParse.Parsers.Dplus do
  alias DstarParse.{ReflectorInfo}

  def parse(html) do
    {_html, info} =
      html
      |> make_info()
      |> find_name()
      |> parse_remote_users()
      |> parse_last_heard()

    {:ok, info}
  end

  defp make_info(html) do
    {html, %ReflectorInfo{}}
  end

  defp find_name({html, %ReflectorInfo{} = info}) do
    reflector_name =
      html
      |> Floki.find("#navigation tr td.navText:nth-child(2)")
      |> Floki.text()

    {html, %{info | name: reflector_name}}
  end

  defp parse_remote_users({html, %ReflectorInfo{} = info}) do
    {_tag, _attrs, children} =
      html
      |> Floki.find("table table")
      |> Enum.at(3)

    remote_users =
      children
      |> Enum.drop(1)
      |> Enum.map(fn {_tr, _attrs, rows} ->
        Enum.map(rows, &Floki.text/1)
      end)
      |> Enum.map(fn [callsign, user_message, last_tx_on, station_type] ->
        %{
          callsign: String.trim(callsign),
          user_message: String.trim(user_message),
          last_tx_on: String.trim(last_tx_on),
          station_type: station_type
        }
      end)

    {html, %{info | remote_users: remote_users}}
  end

  defp parse_last_heard({html, %ReflectorInfo{} = info}) do
    {_tag, _attrs, children} =
      html
      |> Floki.find("table table")
      |> Enum.at(4)

    last_heard =
      children
      |> Enum.drop(1)
      |> Enum.map(fn {_tr, _attrs, rows} ->
        Enum.map(rows, &Floki.text/1)
      end)
      |> Enum.map(fn [callsign, message, module, _last_seen_timestamp] ->
        %{
          callsign: String.trim(callsign),
          message: String.trim(message),
          module: module
        }
      end)

    {html, %{info | last_heard: last_heard}}
  end
end
