defmodule Hadrian.ActivitiesTest do
  use Hadrian.DataCase

  alias Hadrian.Activities
  alias HadrianTest.Helpers

  setup do
    complexes_owner = insert(:complexes_owner)
    sport_complex = insert(:sport_complex, complexes_owner_id: complexes_owner.id)
    sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
    football = insert(:sport_discipline, name: "Football")
    basketball = insert(:sport_discipline, name: "Basketball")
    sport_arena = insert(:sport_arena, sport_object_id: sport_object.id, sport_disciplines: [football, basketball])

    {:ok, sport_arena: sport_arena}
  end

  describe "events" do
    alias Hadrian.Activities.Event

    test "list_events/0 returns all events", %{sport_arena: sport_arena} do
      event =
        insert(:event, sport_arena: sport_arena)
        |> Helpers.unpreload(:sport_arena)

      assert Activities.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id", %{sport_arena: sport_arena} do
      event = insert(:event, sport_arena_id: sport_arena.id)

      assert Activities.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates an event", %{sport_arena: sport_arena} do
      event_attrs = params_for(:event, sport_arena_id: sport_arena.id)

      assert {:ok, %Event{} = event} = Activities.create_event(event_attrs)
      Enum.each(event_attrs, fn ({key, value}) ->
        assert value == Map.get(event, key)
      end)
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_event(generate_invalid_attrs())
    end

    test "update_event/2 with valid data updates the event", %{sport_arena: sport_arena}  do
      event = insert(:event, sport_arena_id: sport_arena.id)
      new_attrs = params_for(:event, sport_arena_id: sport_arena.id)

      assert {:ok, %Event{} = updated_event} = Activities.update_event(event, new_attrs)
      Enum.each(new_attrs, fn ({key, value}) ->
        assert value == Map.get(updated_event, key)
      end)
    end

    test "update_event/2 with invalid data returns error changeset", %{sport_arena: sport_arena} do
      event = insert(:event, sport_arena_id: sport_arena.id)

      assert {:error, %Ecto.Changeset{}} = Activities.update_event(event, generate_invalid_attrs())
      assert event == Activities.get_event!(event.id)
    end

    test "delete_event/1 deletes the event", %{sport_arena: sport_arena} do
      event = insert(:event, sport_arena_id: sport_arena.id)

      assert {:ok, %Event{}} = Activities.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset", %{sport_arena: sport_arena} do
      event = insert(:event, sport_arena_id: sport_arena.id)

      assert %Ecto.Changeset{} = Activities.change_event(event)
    end
  end

  defp generate_invalid_attrs() do
    params_for(:event)
    |> Map.put(:sport_arena_id, nil)
    |> Enum.into(%{}, fn {k, _} -> {k, nil} end)
  end
end
