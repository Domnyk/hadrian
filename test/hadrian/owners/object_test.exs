defmodule Hadrian.ObjectTest do
  use Hadrian.DataCase

  alias Hadrian.Owners
  alias Hadrian.Owners.SportObject

  setup do
    football =  insert(:sport_discipline, name: "Football")
    basketball = insert(:sport_discipline, name: "Basketball")

    {:ok, football: football, basketball: basketball}
  end

  describe "are_disciplines_available/2" do
    test "returns true if at least one arena supports all desired disciplines", %{football: football,
                                                                                  basketball: basketball} do
      object = insert(:object)
      insert(:arena, sport_disciplines: [football], sport_object_id: object.id)
      insert(:arena, sport_disciplines: [football, basketball], sport_object_id: object.id)
      object = Hadrian.Repo.preload(object, :sport_arenas)

      assert SportObject.are_disciplines_available?(object, [football.id, basketball.id])
    end

    test "returns false if none of arenas support desired disciplines", %{football: football, basketball: basketball} do
      object = insert(:object) |> Hadrian.Repo.preload(:sport_arenas)
      insert(:arena, sport_disciplines: [football], sport_object_id: object.id)
      insert(:arena, sport_disciplines: [basketball], sport_object_id: object.id)

      refute SportObject.are_disciplines_available?(object, [football.id, basketball.id])
    end
  end

  describe "get_average_price/2" do
    test "returns average price of all arenas that support all desired disciplines", %{football: football,
                                                                                       basketball: basketball} do
      object = insert(:object)
      insert(:arena, sport_disciplines: [football, basketball], sport_object_id: object.id, price_per_hour: 10)
      insert(:arena, sport_disciplines: [basketball], sport_object_id: object.id, price_per_hour: 20)
      insert(:arena, sport_disciplines: [football], sport_object_id: object.id, price_per_hour: 30)
      object = Hadrian.Repo.preload(object, :sport_arenas)

      assert SportObject.get_average_price(object, [basketball.id]) == 15
      refute SportObject.get_average_price(object, [basketball.id]) == 20
    end
  end

  describe "search_for_objects/2" do
    test "returns only those objects which have arenas with desired disciplines", %{football: football,
                                                                                   basketball: basketball} do
      [%SportObject{id: id1}, %SportObject{id: id2}] = insert_list(2, :object)
      insert(:arena, sport_disciplines: [football], sport_object_id: id1)
      insert(:arena, sport_disciplines: [basketball], sport_object_id: id2)
      insert(:arena, sport_disciplines: [football, basketball], sport_object_id: id1)
      criteria = %{day: ~D[2019-01-03], disciplines: [football.id], geo_location: {52.287604, 21.075429}}

      assert [%{object_id: ^id1, average_price: _, distance: _}] = Owners.search_for_objects(criteria)
    end
  end

end
