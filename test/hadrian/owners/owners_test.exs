defmodule Hadrian.OwnersTest do
  use Hadrian.DataCase

  alias Hadrian.Owners

  describe "sport_complexes" do
    alias Hadrian.Owners.SportComplex

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def sport_complex_fixture(attrs \\ %{}) do
      {:ok, sport_complex} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Owners.create_sport_complex()

      sport_complex
    end

    test "list_sport_complexes/0 returns all sport_complexes" do
      sport_complex = sport_complex_fixture()
      assert Owners.list_sport_complexes() == [sport_complex]
    end

    test "get_sport_complex!/1 returns the sport_complex with given id" do
      sport_complex = sport_complex_fixture()
      assert Owners.get_sport_complex!(sport_complex.id) == sport_complex
    end

    test "create_sport_complex/1 with valid data creates a sport_complex" do
      assert {:ok, %SportComplex{} = sport_complex} = Owners.create_sport_complex(@valid_attrs)
      assert sport_complex.name == "some name"
    end

    test "create_sport_complex/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Owners.create_sport_complex(@invalid_attrs)
    end

    test "update_sport_complex/2 with valid data updates the sport_complex" do
      sport_complex = sport_complex_fixture()
      assert {:ok, sport_complex} = Owners.update_sport_complex(sport_complex, @update_attrs)
      assert %SportComplex{} = sport_complex
      assert sport_complex.name == "some updated name"
    end

    test "update_sport_complex/2 with invalid data returns error changeset" do
      sport_complex = sport_complex_fixture()
      assert {:error, %Ecto.Changeset{}} = Owners.update_sport_complex(sport_complex, @invalid_attrs)
      assert sport_complex == Owners.get_sport_complex!(sport_complex.id)
    end

    test "delete_sport_complex/1 deletes the sport_complex" do
      sport_complex = sport_complex_fixture()
      assert {:ok, %SportComplex{}} = Owners.delete_sport_complex(sport_complex)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_sport_complex!(sport_complex.id) end
    end

    test "change_sport_complex/1 returns a sport_complex changeset" do
      sport_complex = sport_complex_fixture()
      assert %Ecto.Changeset{} = Owners.change_sport_complex(sport_complex)
    end
  end

  describe "sport_objects" do
    alias Hadrian.Owners.SportObject

    @valid_attrs %{latitude: 89.5, longitude: 120.5, name: "some name", sport_complex_id: 1}
    @update_attrs %{latitude: 76.7, longitude: 145.7, name: "some updated name", sport_complex_id: 2}
    @invalid_attrs %{latitude: nil, longitude: nil, name: nil, sport_complex_id: nil}

    def sport_object_fixture(attrs \\ %{}) do
      {:ok, sport_object} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Owners.create_sport_object()

      sport_object
    end

    test "list_sport_objects/0 returns all sport_objects" do
      sport_object = sport_object_fixture()
      assert Owners.list_sport_objects() == [sport_object]
    end

    test "get_sport_object!/1 returns the sport_object with given id" do
      sport_object = sport_object_fixture()
      assert Owners.get_sport_object!(sport_object.id) == sport_object
    end

    test "create_sport_object/1 with valid data creates a sport_object" do
      assert {:ok, %SportObject{} = sport_object} = Owners.create_sport_object(@valid_attrs)
      assert sport_object.latitude == 89.5
      assert sport_object.longitude == 120.5
      assert sport_object.name == "some name"
    end

    test "create_sport_object/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Owners.create_sport_object(@invalid_attrs)
    end

    test "update_sport_object/2 with valid data updates the sport_object" do
      sport_object = sport_object_fixture()
      assert {:ok, sport_object} = Owners.update_sport_object(sport_object, @update_attrs)
      assert %SportObject{} = sport_object
      assert sport_object.latitude == 76.7
      assert sport_object.longitude == 145.7
      assert sport_object.name == "some updated name"
    end

    test "update_sport_object/2 with invalid data returns error changeset" do
      sport_object = sport_object_fixture()
      assert {:error, %Ecto.Changeset{}} = Owners.update_sport_object(sport_object, @invalid_attrs)
      assert sport_object == Owners.get_sport_object!(sport_object.id)
    end

    test "delete_sport_object/1 deletes the sport_object" do
      sport_object = sport_object_fixture()
      assert {:ok, %SportObject{}} = Owners.delete_sport_object(sport_object)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_sport_object!(sport_object.id) end
    end

    test "change_sport_object/1 returns a sport_object changeset" do
      sport_object = sport_object_fixture()
      assert %Ecto.Changeset{} = Owners.change_sport_object(sport_object)
    end
  end

  describe "daily_schedules" do
    alias Hadrian.Owners.DailySchedule

    @valid_attrs %{schedule_day: ~D[2010-04-17], sport_arena_id: 1}
    @update_attrs %{schedule_day: ~D[2011-05-18], sport_arena_id: 2}
    @invalid_attrs %{schedule_day: nil, sport_arena_id: nil}

    def daily_schedule_fixture(attrs \\ %{}) do
      {:ok, daily_schedule} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Owners.create_daily_schedule()

      daily_schedule
    end

    test "list_daily_schedules/0 returns all daily_schedules" do
      daily_schedule = daily_schedule_fixture()
      assert Owners.list_daily_schedules() == [daily_schedule]
    end

    test "get_daily_schedule!/1 returns the daily_schedule with given id" do
      daily_schedule = daily_schedule_fixture()
      assert Owners.get_daily_schedule!(daily_schedule.id) == daily_schedule
    end

    test "create_daily_schedule/1 with valid data creates a daily_schedule" do
      assert {:ok, %DailySchedule{} = daily_schedule} = Owners.create_daily_schedule(@valid_attrs)
      assert daily_schedule.schedule_day == ~D[2010-04-17]
    end

    test "create_daily_schedule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Owners.create_daily_schedule(@invalid_attrs)
    end

    test "update_daily_schedule/2 with valid data updates the daily_schedule" do
      daily_schedule = daily_schedule_fixture()
      assert {:ok, daily_schedule} = Owners.update_daily_schedule(daily_schedule, @update_attrs)
      assert %DailySchedule{} = daily_schedule
      assert daily_schedule.schedule_day == ~D[2011-05-18]
    end

    test "update_daily_schedule/2 with invalid data returns error changeset" do
      daily_schedule = daily_schedule_fixture()
      assert {:error, %Ecto.Changeset{}} = Owners.update_daily_schedule(daily_schedule, @invalid_attrs)
      assert daily_schedule == Owners.get_daily_schedule!(daily_schedule.id)
    end

    test "delete_daily_schedule/1 deletes the daily_schedule" do
      daily_schedule = daily_schedule_fixture()
      assert {:ok, %DailySchedule{}} = Owners.delete_daily_schedule(daily_schedule)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_daily_schedule!(daily_schedule.id) end
    end

    test "change_daily_schedule/1 returns a daily_schedule changeset" do
      daily_schedule = daily_schedule_fixture()
      assert %Ecto.Changeset{} = Owners.change_daily_schedule(daily_schedule)
    end
  end

  describe "time_blocks" do
    alias Hadrian.Owners.TimeBlock

    @valid_attrs %{end_hour: ~T[14:00:00.000000], start_hour: ~T[14:00:00.000000], daily_schedule_id: 1}
    @update_attrs %{end_hour: ~T[15:01:01.000000], start_hour: ~T[15:01:01.000000], daily_schedule_id: 2}
    @invalid_attrs %{end_hour: nil, start_hour: nil, daily_schedule_id: nil}

    def time_block_fixture(attrs \\ %{}) do
      {:ok, time_block} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Owners.create_time_block()

      time_block
    end

    test "list_time_blocks/0 returns all time_blocks" do
      time_block = time_block_fixture()
      assert Owners.list_time_blocks() == [time_block]
    end

    test "get_time_block!/1 returns the time_block with given id" do
      time_block = time_block_fixture()
      assert Owners.get_time_block!(time_block.id) == time_block
    end

    test "create_time_block/1 with valid data creates a time_block" do
      assert {:ok, %TimeBlock{} = time_block} = Owners.create_time_block(@valid_attrs)
      assert time_block.end_hour == ~T[14:00:00.000000]
      assert time_block.start_hour == ~T[14:00:00.000000]
    end

    test "create_time_block/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Owners.create_time_block(@invalid_attrs)
    end

    test "update_time_block/2 with valid data updates the time_block" do
      time_block = time_block_fixture()
      assert {:ok, time_block} = Owners.update_time_block(time_block, @update_attrs)
      assert %TimeBlock{} = time_block
      assert time_block.end_hour == ~T[15:01:01.000000]
      assert time_block.start_hour == ~T[15:01:01.000000]
    end

    test "update_time_block/2 with invalid data returns error changeset" do
      time_block = time_block_fixture()
      assert {:error, %Ecto.Changeset{}} = Owners.update_time_block(time_block, @invalid_attrs)
      assert time_block == Owners.get_time_block!(time_block.id)
    end

    test "delete_time_block/1 deletes the time_block" do
      time_block = time_block_fixture()
      assert {:ok, %TimeBlock{}} = Owners.delete_time_block(time_block)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_time_block!(time_block.id) end
    end

    test "change_time_block/1 returns a time_block changeset" do
      time_block = time_block_fixture()
      assert %Ecto.Changeset{} = Owners.change_time_block(time_block)
    end
  end
end
