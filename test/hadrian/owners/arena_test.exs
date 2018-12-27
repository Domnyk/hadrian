defmodule Hadrian.ArenaTest do
  use Hadrian.DataCase

  alias Hadrian.Owners.SportArena

  @seconds_in_hour 3600

  setup do
    football =  insert(:sport_discipline, name: "Football")
    basketball = insert(:sport_discipline, name: "Basketball")

    {:ok, football: football, basketball: basketball}
  end

  describe "are_disciplines_available?/2" do
    test "returns true if all desired disciplines are available", %{football: football} do
      arena = insert(:sport_arena, sport_disciplines: [football])
      desired_disciplines_ids = [football.id]

      assert SportArena.are_disciplines_available?(arena, desired_disciplines_ids)
    end

    test "returns false if only some desired disciplines are available", %{football: football, basketball: basketball} do
      arena = insert(:sport_arena, sport_disciplines: [football])
      desired_disciplines_ids = [football.id, basketball.id]

      refute SportArena.are_disciplines_available?(arena, desired_disciplines_ids)
    end
  end

  describe "calculate_num_of_time_windows/2" do
    setup do
      day = ~D[2019-01-03]
      arena = insert(:sport_arena)

      {:ok, day: day, arena: arena}
    end

    test "returns 1 time window when arena has no events", %{arena: arena} do
      assert SportArena.calculate_num_of_time_windows(arena, ~D[2019-01-03]) == 1
    end

    test "returns 2 time windows when arena has only one event" do
      day = ~D[2019-01-03]
      start_time = ~T[10:00:00]
      end_time = Time.add(start_time, 3 * @seconds_in_hour)
      arena = insert(:sport_arena)
      insert(:event, event_day: day, start_time: start_time, end_time: end_time, sport_arena_id: arena.id)

      assert SportArena.calculate_num_of_time_windows(arena, ~D[2019-01-03]) == 2
    end

    test "returns 3 time windows when arena has two events", %{day: day, arena: arena} do
      start_time_1 = ~T[10:00:00]
      end_time_1 = Time.add(start_time_1, 3 * @seconds_in_hour)
      start_time_2 = ~T[15:00:00]
      end_time_2 = Time.add(start_time_2, 2 * @seconds_in_hour)
      insert(:event, event_day: day, start_time: start_time_1, end_time: end_time_1, sport_arena_id: arena.id)
      insert(:event, event_day: day, start_time: start_time_2, end_time: end_time_2, sport_arena_id: arena.id)

      assert SportArena.calculate_num_of_time_windows(arena, ~D[2019-01-03]) == 3
    end

    test "returns 4 or more time windows when arena has three or more events", %{day: day, arena: arena} do
      start_time_1 = ~T[10:00:00]
      end_time_1 = Time.add(start_time_1, 3 * @seconds_in_hour)
      start_time_2 = ~T[15:00:00]
      end_time_2 = Time.add(start_time_2, 2 * @seconds_in_hour)
      start_time_3 = ~T[19:00:00]
      end_time_3 = Time.add(start_time_3, 1 * @seconds_in_hour)
      insert(:event, event_day: day, start_time: start_time_1, end_time: end_time_1, sport_arena_id: arena.id)
      insert(:event, event_day: day, start_time: start_time_2, end_time: end_time_2, sport_arena_id: arena.id)
      insert(:event, event_day: day, start_time: start_time_3, end_time: end_time_3, sport_arena_id: arena.id)

      assert SportArena.calculate_num_of_time_windows(arena, ~D[2019-01-03]) == 4
    end

    test "counts time windows longer than 1 hour", %{day: day, arena: arena} do
      start_time_1 = ~T[10:00:00]
      end_time_1 = Time.add(start_time_1, 3 * @seconds_in_hour)
      start_time_2 = ~T[13:00:00]
      end_time_2 = Time.add(start_time_2, 2 * @seconds_in_hour)
      insert(:event, event_day: day, start_time: start_time_1, end_time: end_time_1, sport_arena_id: arena.id)
      insert(:event, event_day: day, start_time: start_time_2, end_time: end_time_2, sport_arena_id: arena.id)

      assert SportArena.calculate_num_of_time_windows(arena, ~D[2019-01-03]) == 2
    end
  end

end
