defmodule Hadrian.OwnersTest do
  use Hadrian.DataCase

  alias Hadrian.Owners

  setup do
    sport_complex = insert(:sport_complex)
    sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)

    {:ok, sport_complex: sport_complex, sport_object: sport_object}
  end

  describe "sport_complexes" do
    alias Hadrian.Owners.SportComplex

    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_sport_complexes/0 returns all sport_complexes", %{sport_complex: sport_complex} do
      assert [sport_complex] == Owners.list_sport_complexes()
    end

    test "get_sport_complex!/1 returns the sport_complex with given id" do
      sport_complex = insert(:sport_complex)
      assert Owners.get_sport_complex!(sport_complex.id) == sport_complex
    end

    test "create_sport_complex/1 with valid data creates a sport_complex" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %SportComplex{} = sport_complex} = Owners.create_sport_complex(valid_attrs)
      assert sport_complex.name == "some name"
    end

    test "create_sport_complex/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Owners.create_sport_complex(@invalid_attrs)
    end

    test "update_sport_complex/2 with valid data updates the sport_complex" do
      sport_complex = insert(:sport_complex)
      assert {:ok, sport_complex} = Owners.update_sport_complex(sport_complex, @update_attrs)
      assert %SportComplex{} = sport_complex
      assert sport_complex.name == "some updated name"
    end

    test "update_sport_complex/2 with invalid data returns error changeset" do
      sport_complex = insert(:sport_complex)
      assert {:error, %Ecto.Changeset{}} = Owners.update_sport_complex(sport_complex, @invalid_attrs)
      assert sport_complex == Owners.get_sport_complex!(sport_complex.id)
    end

    test "when passed %SportComplex{} struct delete_sport_complex/1 deletes the sport_complex" do
      sport_complex = insert(:sport_complex)
      assert {:ok, %SportComplex{}} = Owners.delete_sport_complex(sport_complex)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_sport_complex!(sport_complex.id) end
    end

    test "when passed id of existing sport complex delete_sport_complex_1 deletes it" do
      sport_complex = insert(:sport_complex)
      id = Integer.to_string(sport_complex.id)
      assert {:ok, %SportComplex{}} = Owners.delete_sport_complex(id)
    end

    test "when passed id of existing sport complex but it cannot be deleted due to DB constraints delete_sport_comlex 
          returns :error" do
      sport_complex = insert(:sport_complex)
      insert(:sport_object, sport_complex_id: sport_complex.id)
      id = Integer.to_string(sport_complex.id)
      assert {:error, %Ecto.Changeset{}} = Owners.delete_sport_complex(id)
    end

    test "when passed id of non existing sport complex delete_sport_complex_1 returns :error" do
      assert {:error, :not_found} = Owners.delete_sport_complex("1")
    end

    test "change_sport_complex/1 returns a sport_complex changeset" do
      sport_complex = insert(:sport_complex)
      assert %Ecto.Changeset{} = Owners.change_sport_complex(sport_complex)
    end
  end

  describe "sport_objects" do
    alias Hadrian.Owners.SportObject
    @update_attrs %{geo_coordinates: %{latitude: 76.7, longitude: 145.7}, name: "some updated name", 
                    booking_margin: build(:booking_margin)}
    @invalid_attrs %{latitude: nil, longitude: nil, name: nil, sport_complex_id: nil}

    test "list_sport_objects/0 returns all sport_objects", %{sport_object: sport_object} do
      assert [sport_object] == Owners.list_sport_objects()
    end

    test "list_sport_objects/1 returns all sport objects in sport complex" do
      sport_complex = insert(:sport_complex)
      sport_object_1 = insert(:sport_object, sport_complex: sport_complex)
      sport_object_2 = insert(:sport_object, sport_complex: sport_complex)

      sport_objects_array = Owners.list_sport_objects(sport_complex.id)
      sport_object_from_resp_1 = Enum.at(sport_objects_array, 1)
      sport_object_from_resp_2 = Enum.at(sport_objects_array, 0)

      assert are_sport_objects_the_same(sport_object_1 ,sport_object_from_resp_1)
      assert are_sport_objects_the_same(sport_object_2, sport_object_from_resp_2)
    end

    test "list_sport_objects/1 returns [] when no sport objects in sport complex" do
      assert [] == Owners.list_sport_objects(0)
    end

    defp are_sport_objects_the_same(%SportObject{} = a, %SportObject{} = b) do
      assert a.id == b.id
      assert a.name == b.name
      assert a.booking_margin == b.booking_margin
      assert a.geo_coordinates == b.geo_coordinates
    end

    test "get_sport_object!/1 returns the sport_object with given id" do
      sport_object = insert(:sport_object)
      assert Owners.get_sport_object!(sport_object.id) == sport_object
    end

    test "create_sport_object/1 with valid data creates a sport_object" do
      sport_complex = insert(:sport_complex)
      booking_margin_val = %{"months" => 1, "days" => 2, "secs" => 3}
      address_val = %{"street" => "Szkolna", "building_number" => "7", "city" => "Marki", "postal_code" => "05-270"}
      valid_attrs = %{geo_coordinates: %{latitude: 89.5, longitude: 120.5}, name: "some name", 
                      sport_complex_id: sport_complex.id, booking_margin: booking_margin_val, address: address_val}

      assert {:ok, %SportObject{} = sport_object} = Owners.create_sport_object(valid_attrs)
      assert sport_object.geo_coordinates.latitude == valid_attrs.geo_coordinates.latitude
      assert sport_object.geo_coordinates.longitude == valid_attrs.geo_coordinates.longitude
      assert sport_object.name == valid_attrs.name
      assert sport_object.booking_margin.months == valid_attrs.booking_margin["months"]
      assert sport_object.booking_margin.days == valid_attrs.booking_margin["days"]
      assert sport_object.booking_margin.secs == valid_attrs.booking_margin["secs"]
      assert sport_object.address.street == valid_attrs.address["street"]
      assert sport_object.address.building_number == valid_attrs.address["building_number"]
      assert sport_object.address.city == valid_attrs.address["city"]
      assert sport_object.address.postal_code == valid_attrs.address["postal_code"]

    end

    test "create_sport_object/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Owners.create_sport_object(@invalid_attrs)
    end

    test "update_sport_object/2 with valid data updates the sport_object" do
      sport_complex = build(:sport_complex)
      sport_object = insert(:sport_object, sport_complex: sport_complex)

      assert {:ok, sport_object} = Owners.update_sport_object(sport_object, @update_attrs)
      assert %SportObject{} = sport_object
      assert sport_object.geo_coordinates.latitude == @update_attrs.geo_coordinates.latitude
      assert sport_object.geo_coordinates.longitude == @update_attrs.geo_coordinates.longitude
      assert sport_object.name == @update_attrs.name
    end

    test "update_sport_object/2 with invalid data returns error changeset" do
      sport_object = insert(:sport_object)

      assert {:error, %Ecto.Changeset{}} = Owners.update_sport_object(sport_object, @invalid_attrs)
      assert sport_object == Owners.get_sport_object!(sport_object.id)
    end

    test "delete_sport_object/1 deletes the sport_object" do
      sport_object = insert(:sport_object)

      assert {:ok, %SportObject{}} = Owners.delete_sport_object(sport_object)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_sport_object!(sport_object.id) end
    end

    test "when passed id of existing sport object delete_sport_object/1 deletes it", %{sport_object: sport_object} do
      id = Integer.to_string(sport_object.id)
      assert {:ok, %SportObject{}} = Owners.delete_sport_object(id)
    end

    test "when passed id of existing sport object but it cannot be deleted due to DB constraints delete_sport_object/1
          returns :error", %{sport_object: sport_object} do
      insert(:sport_arena, sport_object_id: sport_object.id)
      id = Integer.to_string(sport_object.id)
      assert {:error, %Ecto.Changeset{}} = Owners.delete_sport_object(id)
    end

    test "when passed id of non existing sport object delete_sport_object/1 returns :error" do
      assert {:error, :not_found} = Owners.delete_sport_object("1")
    end

    test "change_sport_object/1 returns a sport_object changeset" do
      sport_object = insert(:sport_object)

      assert %Ecto.Changeset{} = Owners.change_sport_object(sport_object)
    end
  end

  describe "daily_schedules" do
    alias Hadrian.Owners.DailySchedule

    @update_attrs %{schedule_day: ~D[2011-05-18]}
    @invalid_attrs %{schedule_day: nil, sport_arena_id: nil}

    test "list_daily_schedules/0 returns all daily_schedules" do
      daily_schedules_list = insert_list(3, :daily_schedule)

      assert Owners.list_daily_schedules() == daily_schedules_list
    end

    test "get_daily_schedule!/1 returns the daily_schedule with given id" do
      daily_schedule = insert(:daily_schedule)

      assert Owners.get_daily_schedule!(daily_schedule.id) == daily_schedule
    end

    test "create_daily_schedule/1 with valid data creates a daily_schedule" do
      sport_arena = insert(:sport_arena)
      valid_attrs = %{schedule_day: ~D[2010-04-17], sport_arena_id: sport_arena.id}

      assert {:ok, %DailySchedule{} = daily_schedule} = Owners.create_daily_schedule(valid_attrs)
      assert daily_schedule.schedule_day == valid_attrs.schedule_day
    end

    test "create_daily_schedule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Owners.create_daily_schedule(@invalid_attrs)
    end

    test "update_daily_schedule/2 with valid data updates the daily_schedule" do
      sport_arena = insert(:sport_arena)
      daily_schedule = insert(:daily_schedule, sport_arena_id: sport_arena.id)

      assert {:ok, daily_schedule} = Owners.update_daily_schedule(daily_schedule, @update_attrs)
      assert %DailySchedule{} = daily_schedule
      assert daily_schedule.schedule_day == @update_attrs.schedule_day
    end

    test "update_daily_schedule/2 with invalid data returns error changeset" do
      daily_schedule = insert(:daily_schedule)

      assert {:error, %Ecto.Changeset{}} = Owners.update_daily_schedule(daily_schedule, @invalid_attrs)
      assert daily_schedule == Owners.get_daily_schedule!(daily_schedule.id)
    end

    test "delete_daily_schedule/1 deletes the daily_schedule" do
      daily_schedule = insert(:daily_schedule)
      assert {:ok, %DailySchedule{}} = Owners.delete_daily_schedule(daily_schedule)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_daily_schedule!(daily_schedule.id) end
    end

    test "change_daily_schedule/1 returns a daily_schedule changeset" do
      daily_schedule = insert(:daily_schedule)

      assert %Ecto.Changeset{} = Owners.change_daily_schedule(daily_schedule)
    end
  end

  describe "time_blocks" do
    alias Hadrian.Owners.TimeBlock

    @update_attrs %{end_hour: ~T[15:01:01.000000], start_hour: ~T[14:01:01.000000]}
    @invalid_attrs %{end_hour: nil, start_hour: nil, daily_schedule_id: nil}

    test "list_time_blocks/0 returns all time_blocks" do
      time_blocks_list = insert_list(3, :time_block)

      assert Owners.list_time_blocks() == time_blocks_list
    end

    test "get_time_block!/1 returns the time_block with given id" do
      time_block = insert(:time_block)

      assert Owners.get_time_block!(time_block.id) == time_block
    end

    test "create_time_block/1 with valid data creates a time_block" do
      daily_schedule = insert(:daily_schedule)
      valid_attrs = %{end_hour: ~T[15:00:00.000000], start_hour: ~T[14:00:00.000000], 
                      daily_schedule_id: daily_schedule.id}
      
      assert {:ok, %TimeBlock{} = time_block} = Owners.create_time_block(valid_attrs)
      assert time_block.end_hour == valid_attrs.end_hour
      assert time_block.start_hour == valid_attrs.start_hour
    end

    test "create_time_block/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Owners.create_time_block(@invalid_attrs)
    end

    test "update_time_block/2 with valid data updates the time_block" do
      daily_schedule = insert(:daily_schedule)
      time_block = insert(:time_block, daily_schedule_id: daily_schedule.id)

      assert {:ok, time_block} = Owners.update_time_block(time_block, @update_attrs)
      assert %TimeBlock{} = time_block
      assert time_block.end_hour == @update_attrs.end_hour
      assert time_block.start_hour == @update_attrs.start_hour
    end

    test "update_time_block/2 with invalid data returns error changeset" do
      time_block = insert(:time_block)

      assert {:error, %Ecto.Changeset{}} = Owners.update_time_block(time_block, @invalid_attrs)
      assert time_block == Owners.get_time_block!(time_block.id)
    end

    test "delete_time_block/1 deletes the time_block" do
      time_block = insert(:time_block)

      assert {:ok, %TimeBlock{}} = Owners.delete_time_block(time_block)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_time_block!(time_block.id) end
    end

    test "change_time_block/1 returns a time_block changeset" do
      time_block = insert(:time_block)
      
      assert %Ecto.Changeset{} = Owners.change_time_block(time_block)
    end
  end

  describe "sport_disciplines" do
    alias Hadrian.Owners.SportDiscipline

    @invalid_attrs %{name: nil}

    test "list_sport_disciplines/0 returns all sport_disciplines" do
      football = insert(:sport_discipline)
      basketball = insert(:sport_discipline, name: "Basketball")
      assert Owners.list_sport_disciplines() == [football, basketball]
    end

    test "get_sport_discipline!/1 returns the sport_discipline with given id" do
      sport_discipline = insert(:sport_discipline)
      assert Owners.get_sport_discipline!(sport_discipline.id) == sport_discipline
    end

    test "create_sport_discipline/1 with valid data creates a sport_discipline" do
      valid_attrs = %{name: "some name"}
      
      assert {:ok, %SportDiscipline{} = sport_discipline} = Owners.create_sport_discipline(valid_attrs)
      assert sport_discipline.name == "some name"
    end

    test "create_sport_discipline/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Owners.create_sport_discipline(@invalid_attrs)
    end

    test "update_sport_discipline/2 with valid data updates the sport_discipline" do
      sport_discipline = insert(:sport_discipline)
      update_attrs = %{name: "Basketball"}
      
      assert {:ok, sport_discipline} = Owners.update_sport_discipline(sport_discipline, update_attrs)
      assert %SportDiscipline{} = sport_discipline
      assert sport_discipline.name == update_attrs.name
    end

    test "update_sport_discipline/2 with invalid data returns error changeset" do
      sport_discipline = insert(:sport_discipline)

      assert {:error, %Ecto.Changeset{}} = Owners.update_sport_discipline(sport_discipline, @invalid_attrs)
      assert sport_discipline == Owners.get_sport_discipline!(sport_discipline.id)
    end

    test "delete_sport_discipline/1 deletes the sport_discipline" do
      sport_discipline = insert(:sport_discipline)

      assert {:ok, %SportDiscipline{}} = Owners.delete_sport_discipline(sport_discipline)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_sport_discipline!(sport_discipline.id) end
    end

    test "change_sport_discipline/1 returns a sport_discipline changeset" do
      sport_discipline = insert(:sport_discipline)
      assert %Ecto.Changeset{} = Owners.change_sport_discipline(sport_discipline)
    end
  end

  describe "sport_arenas" do
    alias Hadrian.Owners.SportArena

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def sport_arena_fixture() do
      sport_complex = insert(:sport_complex)
      sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
      sport_arena = insert(:sport_arena, sport_object_id: sport_object.id)

      {sport_complex, sport_object, sport_arena}
    end

    test "list_sport_arenas/0 returns all sport_arenas" do
      {_sport_complex, _sport_object, sport_arena } = sport_arena_fixture()
      assert Owners.list_sport_arenas() == [sport_arena]
    end

    test "list_sport_arenas/1 returns all sport arenas in sport object" do
      sport_complex = insert(:sport_complex)
      sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
      sport_arena_1 = insert(:sport_arena, sport_object_id: sport_object.id)
      sport_arena_2 = insert(:sport_arena, sport_object_id: sport_object.id)

      sport_arenas_array = Owners.list_sport_arenas(sport_object.id)
      sport_arena_from_resp_1 = Enum.at(sport_arenas_array, 1)
      sport_arena_from_resp_2 = Enum.at(sport_arenas_array, 0)

      assert are_sport_arenas_the_same(sport_arena_1 ,sport_arena_from_resp_1)
      assert are_sport_arenas_the_same(sport_arena_2, sport_arena_from_resp_2)
    end

    defp are_sport_arenas_the_same(%SportArena{} = a, %SportArena{} = b) do
      assert a.id == b.id
      assert a.name == b.name
      assert a.sport_object_id == b.sport_object_id
    end

    test "get_sport_arena!/1 returns the sport_arena with given id" do
      {_sport_complex, _sport_object, sport_arena } = sport_arena_fixture()
      assert Owners.get_sport_arena!(sport_arena.id) == sport_arena
    end

    test "create_sport_arena/1 with valid data creates a sport_arena" do
      sport_complex = insert(:sport_complex)
      sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
      params = @valid_attrs
               |> Map.put(:sport_object_id, sport_object.id)

      assert {:ok, %SportArena{} = sport_arena} = Owners.create_sport_arena(params)
      assert sport_arena.name == "some name"
    end

    test "create_sport_arena/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Owners.create_sport_arena(@invalid_attrs)
    end

    test "update_sport_arena/2 with valid data updates the sport_arena" do
      {_sport_complex, _sport_object, sport_arena } = sport_arena_fixture()
      assert {:ok, sport_arena} = Owners.update_sport_arena(sport_arena, @update_attrs)
      assert %SportArena{} = sport_arena
      assert sport_arena.name == "some updated name"
    end

    test "update_sport_arena/2 with invalid data returns error changeset" do
      {_sport_complex, _sport_object, sport_arena } = sport_arena_fixture()
      assert {:error, %Ecto.Changeset{}} = Owners.update_sport_arena(sport_arena, @invalid_attrs)
      assert sport_arena == Owners.get_sport_arena!(sport_arena.id)
    end

    test "delete_sport_arena/1 deletes the sport_arena" do
      {_sport_complex, _sport_object, sport_arena } = sport_arena_fixture()
      assert {:ok, %SportArena{}} = Owners.delete_sport_arena(sport_arena)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_sport_arena!(sport_arena.id) end
    end

    test "change_sport_arena/1 returns a sport_arena changeset" do
      {_sport_complex, _sport_object, sport_arena } = sport_arena_fixture()
      assert %Ecto.Changeset{} = Owners.change_sport_arena(sport_arena)
    end
  end
end
