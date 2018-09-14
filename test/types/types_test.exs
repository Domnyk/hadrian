defmodule TypesTest do
  use ExUnit.Case, async: true

  describe "GeoCoordinastes" do
    alias Types.GeoCoordinates

    test "when casting from map returns {:ok, %Types.GeoCoordinates}" do
      external_data = %{latitude: 1.234, longitude: 2.345}

      assert {:ok, internal_data = %GeoCoordinates{}} = GeoCoordinates.Ecto.cast(external_data)
      assert internal_data.latitude == external_data.latitude
      assert internal_data.longitude == external_data.longitude
    end

    test "when casting from something diffrent than map returns :error" do
      external_data = "San Junipero"

      assert :error = GeoCoordinates.Ecto.cast(external_data)
    end

    test "when loading from database returns {:ok, %Types.GeoCoordinates}" do
      assert false
    end

    test "when dumping map to database returns {:ok, %Types.GeoCoordinates}" do
      assert false
    end

    test "when dumping something diffrent than map to database returns :error" do
      external_data = "Thanos"

      assert :error = GeoCoordinates.Ecto.dump(external_data)
    end
  end
end