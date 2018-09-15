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
      data_from_db = %{"latitude" => 52.299035, "longitude" => 21.03369}

      assert {:ok, internal_data} = GeoCoordinates.Ecto.load(data_from_db);
      assert internal_data.latitude == data_from_db["latitude"]
      assert internal_data.longitude == data_from_db["longitude"]
    end

    test "when dumping structure to database returns {:ok, Map}" do
      internal_data = %GeoCoordinates{latitude: 52.299035, longitude: 21.03369}
      expected_map = %{latitude: internal_data.latitude, longitude: internal_data.longitude} 

      assert {:ok, actual_map} = GeoCoordinates.Ecto.dump(internal_data) 
      assert actual_map == expected_map
    end

    test "when dumping something diffrent than map to database returns :error" do
      external_data = "Thanos"

      assert :error = GeoCoordinates.Ecto.dump(external_data)
    end
  end
end