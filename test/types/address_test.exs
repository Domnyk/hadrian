defmodule AddressTest do
  use ExUnit.Case, async: true

  alias Types.Address

  describe "type" do
    test "returns map" do
      assert Address.Ecto.type == :map
    end
  end

  describe "cast" do
    test "when casting from map with symbol keys returns {:ok, %Types.Address}" do
      external_data = %{street: "Konopnickiej", building_number: "7", postal_code: "05-270", city: "Marki"}

      assert {:ok, internal_data = %Address{}} = Address.Ecto.cast(external_data)
      assert internal_data.street == external_data.street
      assert internal_data.building_number == external_data.building_number
      assert internal_data.postal_code == external_data.postal_code
      assert internal_data.city == external_data.city
    end

    test "when casting from map with string keys returns {:ok, %Types.Address}" do
      external_data = %{"street" => "Konopnickiej", "building_number" => "7", "postal_code" => "05-270",
                        "city" => "Marki"}

      assert {:ok, internal_data = %Address{}} = Address.Ecto.cast(external_data)
      assert internal_data.street == external_data["street"]
      assert internal_data.building_number == external_data["building_number"]
      assert internal_data.postal_code == external_data["postal_code"]
      assert internal_data.city == external_data["city"]
    end

    test "when casting from something diffrent than map returns :error" do
      external_data = "San Junipero"

      assert :error = Address.Ecto.cast(external_data)
    end
  end

  describe "load" do
    test "returns {:ok, %Types.Address}" do
      data_from_db = %{"street" => "Konopnickiej", "building_number" => "7", "postal_code" => "05-270",
                       "city" => "Marki"}

      assert {:ok, internal_data} = Address.Ecto.load(data_from_db);
      assert internal_data.street == data_from_db["street"]
      assert internal_data.building_number == data_from_db["building_number"]
      assert internal_data.postal_code == data_from_db["postal_code"]
      assert internal_data.city == data_from_db["city"]
    end
  end

  describe "dump" do
    test "when dumping structure to database returns {:ok, Map}" do
      internal_data = %Address{street: "Konopnickiej", building_number: "7", postal_code: "05-270", city: "Marki"}
      expected_map = %{street: internal_data.street, building_number: internal_data.building_number,
                       postal_code: internal_data.postal_code, city: internal_data.city}

      assert {:ok, actual_map} = Address.Ecto.dump(internal_data)
      assert actual_map == expected_map
    end

    test "when dumping something diffrent than map to database returns :error" do
      external_data = "Thanos"

      assert :error = Address.Ecto.dump(external_data)
    end
  end
end
