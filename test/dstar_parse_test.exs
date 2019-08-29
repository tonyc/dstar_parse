defmodule DstarParseTest do
  alias DstarParse.ReflectorInfo

  use ExUnit.Case

  describe "DstarParse.parse_file" do
    test "returns a ReflectorInfo" do
      assert {:ok, %ReflectorInfo{name: "REF053 Reflector System"}} =
               DstarParse.parse_file("test/fixtures/ref053.html")
    end

    test "returns expected last heard" do
      {:ok, info} = DstarParse.parse_file("test/fixtures/ref053.html")

      assert info.last_heard == [
               %{callsign: "NO7E", message: "Chris N Las Vegas NV", module: "D"},
               %{callsign: "N9NWS", message: "", module: "D"},
               %{callsign: "KC0UWG", message: "", module: "A"},
               %{callsign: "WB4IZC", message: "Steve-Horn Lake MS", module: "D"},
               %{callsign: "KD0MOM", message: "Tom Upsala MN ID51", module: "A"},
               %{callsign: "NY9D", message: "", module: "A"},
               %{callsign: "NK8T   D", message: "BOB NK8T DENVER NC", module: "A"},
               %{callsign: "KB9OMH", message: "KB9OMH ID-51A +", module: "A"},
               %{callsign: "WA7ERY", message: "", module: "A"},
               %{callsign: "MM3TWA", message: "Ian - West Coast Sco", module: "B"},
               %{callsign: "N4NBC", message: "", module: "D"},
               %{callsign: "N3SBP", message: "TOWSON MD  3124104", module: "D"},
               %{callsign: "KA2NCD", message: "", module: "D"},
               %{callsign: "KE0LMX", message: "Tim from MN, USA", module: "A"}
             ]
    end

    test "returns expected remote users" do
      {:ok, info} = DstarParse.parse_file("test/fixtures/ref053.html")

      assert Enum.count(info.remote_users) == 25
    end
  end
end
