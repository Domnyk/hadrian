defmodule Hadrian.OwnersTest do
  use Hadrian.DataCase

  alias Hadrian.Owners

  describe "sport_complexes" do
    alias Hadrian.Owners.SportComplex

    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_sport_complexes/0 returns all sport_complexes" do
      sport_complexes_list = insert_list(3, :sport_complex)
      assert sport_complexes_list == Owners.list_sport_complexes()
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

    test "delete_sport_complex/1 deletes the sport_complex" do
      sport_complex = insert(:sport_complex)
      assert {:ok, %SportComplex{}} = Owners.delete_sport_complex(sport_complex)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_sport_complex!(sport_complex.id) end
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

    test "list_sport_objects/0 returns all sport_objects" do
      sport_object_list = insert_list(3, :sport_object)
      assert Owners.list_sport_objects() == sport_object_list
    end

    test "get_sport_object!/1 returns the sport_object with given id" do
      sport_object = insert(:sport_object)
      assert Owners.get_sport_object!(sport_object.id) == sport_object
    end

    test "create_sport_object/1 with valid data creates a sport_object" do
      sport_complex = insert(:sport_complex)
      {:ok, booking_margin_val} = EctoInterval.cast(%{"months" => "1", "days" => "2", "secs" => "3"})
      valid_attrs = %{geo_coordinates: %{latitude: 89.5, longitude: 120.5}, name: "some name", 
                      sport_complex_id: sport_complex.id, booking_margin: booking_margin_val}

      assert {:ok, %SportObject{} = sport_object} = Owners.create_sport_object(valid_attrs)
      assert sport_object.geo_coordinates.latitude == valid_attrs.geo_coordinates.latitude
      assert sport_object.geo_coordinates.longitude == valid_attrs.geo_coordinates.longitude
      assert sport_object.name == valid_attrs.name
      assert sport_object.booking_margin == valid_attrs.booking_margin
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
end
