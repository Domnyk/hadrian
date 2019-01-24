defmodule Hadrian.ExternalEventsTest do
  use Hadrian.DataCase

  alias Hadrian.Helpers
  alias Hadrian.Activities
  alias Hadrian.Activities.ExternalEvent

  setup do
    complexes_owner = insert(:complexes_owner)
    sport_complex = insert(:sport_complex, complexes_owner_id: complexes_owner.id)
    sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
    football = insert(:sport_discipline, name: "Football")
    basketball = insert(:sport_discipline, name: "Basketball")
    sport_arena = insert(:sport_arena, sport_object_id: sport_object.id, sport_disciplines: [football, basketball])

    {:ok, sport_arena: sport_arena}
  end

  test "list_external_events/1 returns events in given sport object", %{sport_arena: sport_arena} do
    external_event =
      insert(:external_event, sport_arena: sport_arena)
      |> Helpers.unpreload(:sport_arena)

    assert Activities.list_external_events(sport_arena.id + 1) == []
    assert Activities.list_external_events(sport_arena.id) == [external_event]
  end

  test "get_external_event!/1 returns the external event with given id", %{sport_arena: sport_arena} do
    %ExternalEvent{id: id} = insert(:external_event, sport_arena_id: sport_arena.id)

    assert %ExternalEvent{id: ^id}  = Activities.get_external_event!(id)
  end

  describe "create_external_event/1" do
    test "valid data creates an external event", %{sport_arena: sport_arena} do
      external_event_attrs = params_for(:external_event, sport_arena_id: sport_arena.id)

      assert {:ok, %ExternalEvent{} = external_event} = Activities.create_external_event(external_event_attrs)
      Enum.each(external_event_attrs, fn ({key, value}) ->
        assert value == Map.get(external_event, key)
      end)
    end

    test "invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_external_event(generate_invalid_attrs())
    end
  end

  describe "update_external_event/2" do
    test "valid data updates the event", %{sport_arena: sport_arena}  do
      external_event = insert(:external_event, sport_arena_id: sport_arena.id)
      new_attrs = params_for(:external_event, sport_arena_id: sport_arena.id)

      assert {:ok, %ExternalEvent{} = updated_external_event} = Activities.update_external_event(external_event, new_attrs)
      Enum.each(new_attrs, fn ({key, value}) ->
        assert value == Map.get(updated_external_event, key)
      end)
    end

    test "invalid data returns error changeset", %{sport_arena: sport_arena} do
      external_event = insert(:external_event, sport_arena_id: sport_arena.id)

      assert {:error, %Ecto.Changeset{}} = Activities.update_external_event(external_event, generate_invalid_attrs())
      assert external_event == Activities.get_external_event!(external_event.id)
    end
  end

  test "delete_external_event/1 deletes the external event", %{sport_arena: sport_arena} do
    external_event = insert(:external_event, sport_arena_id: sport_arena.id)

    assert {:ok, %ExternalEvent{}} = Activities.delete_external_event(external_event)
    assert_raise Ecto.NoResultsError, fn -> Activities.get_external_event!(external_event.id) end
  end

  test "change_external_event/1 returns a external event changeset", %{sport_arena: sport_arena} do
    external_event = insert(:external_event, sport_arena_id: sport_arena.id)

    assert %Ecto.Changeset{} = Activities.change_external_event(external_event)
  end

  defp generate_invalid_attrs() do
    params_for(:external_event)
    |> Map.put(:sport_arena_id, nil)
    |> Enum.into(%{}, fn {k, _} -> {k, nil} end)
  end
end
