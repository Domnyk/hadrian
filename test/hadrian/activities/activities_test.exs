defmodule Hadrian.ActivitiesTest do
  use Hadrian.DataCase

  alias Hadrian.Repo
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

  # TODO: Compare all fields
  describe "events" do
    alias Hadrian.Activities.Event

    test "list_events/1 returns events in given sport object", %{sport_arena: sport_arena} do
      event =
        insert(:event, sport_arena: sport_arena)
        |> Repo.preload(:participators)
        |> Helpers.unpreload(:sport_arena)

      assert Activities.list_events(sport_arena.id + 1) == []
      assert Activities.list_events(sport_arena.id) == [event]
    end

    test "get_event!/1 returns the event with given id", %{sport_arena: sport_arena} do
      %Event{id: id} = insert(:event, sport_arena_id: sport_arena.id)

      assert %Event{id: ^id}  = Activities.get_event!(id)
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
      event = insert(:event, sport_arena_id: sport_arena.id) |> Hadrian.Repo.preload(:participators)

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

    defp generate_invalid_attrs() do
      params_for(:event)
      |> Map.put(:sport_arena_id, nil)
      |> Enum.into(%{}, fn {k, _} -> {k, nil} end)
    end
  end

  describe "participations" do
    alias Hadrian.Activities.Participation
    alias Hadrian.Accounts.User
    alias Ecto.Changeset

    test "list_participations/1 lists all participations", %{sport_arena: sport_arena} do
      event = insert(:event, sport_arena_id: sport_arena.id)
      user_1 = insert(:user)
      user_2 = insert(:user)
      user_3 = insert(:user)

      assert {:ok, %Participation{}} = Activities.create_participation(event, user_1)
      assert {:ok, %Participation{}} = Activities.create_participation(event, user_2)
      assert {:ok, %Participation{}} = Activities.create_participation(event, user_3)
      participators = Activities.get_event!(event.id).participators
      assert length(participators) == 3
      assert [user_1.id, user_2.id, user_3.id] == Enum.map(participators, fn %User{id: id} -> id end)
    end

    test "get_participation/2 returns existing participation", %{sport_arena: sport_arena} do
      event = insert(:event, sport_arena_id: sport_arena.id)
      user = insert(:user)

      assert {:ok, %Participation{} = participation} = Activities.create_participation(event, user)
      assert participation == Activities.get_participation!(event.id, user.id)
    end

    test "get_participation!/2 raises error when participation does not exist" do
      bad_user_id = -1
      bad_event_id = -3

      assert_raise Ecto.NoResultsError, fn -> Activities.get_participation!(bad_event_id, bad_user_id) end
    end

    test "create_participation/2 creates new participation", %{sport_arena: sport_arena} do
      event = insert(:event, sport_arena_id: sport_arena.id)
      user = insert(:user)

      assert {:ok, %Participation{} = participation} = Activities.create_participation(event, user)
      assert participation.is_event_owner == false
      assert Activities.get_event!(event.id).participators != []
    end

    test "create_participation/2 does not allow to join same event twice", %{sport_arena: sport_arena} do
      event = insert(:event, sport_arena_id: sport_arena.id)
      user = insert(:user)

      assert {:ok, %Participation{}} = Activities.create_participation(event, user)
      assert {:error, %Changeset{errors: [user_id: {"can't join to the same event twice", []}]}}
             = Activities.create_participation(event, user)
    end

    test "create_participation/2 allows to join same user to different events", %{sport_arena: sport_arena} do
      event_1 = insert(:event, sport_arena_id: sport_arena.id)
      event_2 = insert(:event, sport_arena_id: sport_arena.id)
      user = insert(:user)

      assert {:ok, %Participation{}} = Activities.create_participation(event_1, user)
      assert {:ok, %Participation{}} = Activities.create_participation(event_2, user)
      assert Activities.get_event!(event_1.id).participators != []
      assert Activities.get_event!(event_2.id).participators != []
    end

    test "create_participation/2 allows to join different users to the same event", %{sport_arena: sport_arena} do
      event = insert(:event, sport_arena_id: sport_arena.id)
      user_1 = insert(:user)
      user_2 = insert(:user)

      assert {:ok, %Participation{} = participation_1} = Activities.create_participation(event, user_1)
      assert participation_1.is_event_owner == false
      assert {:ok, %Participation{} = participation_2} = Activities.create_participation(event, user_2)
      assert participation_2.is_event_owner == false
      assert Activities.get_event!(event.id).participators != []
      assert length(Activities.get_event!(event.id).participators) == 2
    end

    test "create_participation/3 allows to mark user as event's owner", %{sport_arena: sport_arena} do
      event = insert(:event, sport_arena_id: sport_arena.id)
      user = insert(:user)
      is_event_owner = true

      assert {:ok, %Participation{} = participation} = Activities.create_participation(event, user, is_event_owner)
      assert participation.is_event_owner == is_event_owner
      assert Activities.get_event!(event.id).participators != []
    end

    test "create_participation/3 does not allow for event to have 2 owners", %{sport_arena: sport_arena} do
      event = insert(:event, sport_arena_id: sport_arena.id)
      user_1 = insert(:user)
      user_2 = insert(:user)
      is_event_owner = true

      assert {:ok, %Participation{}} = Activities.create_participation(event, user_1, is_event_owner)
      assert {:error, %Changeset{errors: [is_event_owner: {"event can have only one owner", []}]}}
             = Activities.create_participation(event, user_2, is_event_owner)
    end

    test "delete_participation/2 deletes participation", %{sport_arena: sport_arena} do
      event = insert(:event, sport_arena_id: sport_arena.id)
      user = insert(:user)
      is_event_owner = true

      assert {:ok, %Participation{} = participation} = Activities.create_participation(event, user, is_event_owner)

      assert {:ok, %Participation{}} = Activities.delete_participation(participation);
      assert Activities.get_event!(event.id).participators == []
    end
  end
end
