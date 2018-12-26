defmodule Hadrian.ParticipationsTest do
  use Hadrian.DataCase

  alias Ecto.Changeset
  alias Hadrian.Activities
  alias Hadrian.Activities.Participation
  alias Hadrian.Accounts.User

  @independence_day_2018 ~D[2018-11-11]

  setup do
    complexes_owner = insert(:complexes_owner)
    sport_complex = insert(:sport_complex, complexes_owner_id: complexes_owner.id)
    sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
    football = insert(:sport_discipline, name: "Football")
    basketball = insert(:sport_discipline, name: "Basketball")
    sport_arena = insert(:sport_arena, sport_object_id: sport_object.id, sport_disciplines: [football, basketball])

    {:ok, sport_arena: sport_arena}
  end

  test "list_participations/1 lists all participations", %{sport_arena: sport_arena} do
    event = insert(:event, sport_arena_id: sport_arena.id)
    [user_1, user_2, user_3] = insert_list(3, :user)

    assert {:ok, %Participation{}} = Activities.create_participation(event, user_1)
    assert {:ok, %Participation{}} = Activities.create_participation(event, user_2)
    assert {:ok, %Participation{}} = Activities.create_participation(event, user_3)
    participators = Activities.get_event!(event.id).participators
    assert length(participators) == 3
    assert Enum.sort([user_1.id, user_2.id, user_3.id]) == Enum.map(participators, fn %User{id: id} -> id end)
                                                           |> Enum.sort()
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

  describe "create_participation/2" do
    test "creates new participation", %{sport_arena: sport_arena} do
      event = insert(:event, sport_arena_id: sport_arena.id)
      user = insert(:user)

      assert {:ok, %Participation{} = participation} = Activities.create_participation(event, user)
      assert participation.is_event_owner == false
      assert Activities.get_event!(event.id).participators != []
    end

    test "does not allow to join same event twice", %{sport_arena: sport_arena} do
      event = insert(:event, sport_arena_id: sport_arena.id)
      user = insert(:user)

      assert {:ok, %Participation{}} = Activities.create_participation(event, user)
      assert {:error, %Changeset{errors: [user_id: {"can't join to the same event twice", []}]}}
             = Activities.create_participation(event, user)
    end

    test "allows to join same user to different events", %{sport_arena: sport_arena} do
      event_1 = insert(:event, sport_arena_id: sport_arena.id)
      event_2 = insert(:event, sport_arena_id: sport_arena.id)
      user = insert(:user)

      assert {:ok, %Participation{}} = Activities.create_participation(event_1, user)
      assert {:ok, %Participation{}} = Activities.create_participation(event_2, user)
      assert Activities.get_event!(event_1.id).participators != []
      assert Activities.get_event!(event_2.id).participators != []
    end

    test "allows to join different users to the same event", %{sport_arena: sport_arena} do
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

    test "does not allow to join event after joining phase has ended", %{sport_arena: arena} do
      past_date = ~D[2018-11-11]
      event = insert(:event, sport_arena_id: arena.id, end_of_joining_phase: past_date)
      user = insert(:user)

      assert {:error, %Changeset{errors: [end_of_joining_phase: {"joining phase has ended already", []}]}}
             = Activities.create_participation(event, user)
    end
  end

  describe "create_participation/3" do
    test "allows to mark user as event's owner", %{sport_arena: sport_arena} do
      event = insert(:event, sport_arena_id: sport_arena.id)
      user = insert(:user)
      is_event_owner = true

      assert {:ok, %Participation{} = participation} = Activities.create_participation(event, user, is_event_owner)
      assert participation.is_event_owner == is_event_owner
      assert Activities.get_event!(event.id).participators != []
    end

    # TODO: Write trigger to make this test pass
    # test "create_participation/3 does not allow for event to have 2 owners", %{sport_arena: sport_arena} do
    #   event = insert(:event, sport_arena_id: sport_arena.id)
    #   user_1 = insert(:user)
    #   user_2 = insert(:user)
    #   is_event_owner = true
    #
    #   assert {:ok, %Participation{}} = Activities.create_participation(event, user_1, is_event_owner)
    #   assert {:error, %Changeset{errors: [is_event_owner: {"event can have only one owner", []}]}}
    #          = Activities.create_participation(event, user_2, is_event_owner)
    # end
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
